//
//  CalendarViewController.swift
//  Carleton150

import Foundation
import SwiftOverlays

class CalendarViewController: UICollectionViewController {
   
    var calendar: [Dictionary<String, AnyObject?>] = []
    var filteredCalendar: [Dictionary<String, AnyObject?>] = []
    var cells: [CalendarCell] = []
    var eventImages: [UIImage] = []
    var tableLimit : Int!
    var parentView: CalendarFilterViewController!
    
    
    @IBOutlet weak var warningSign: UIImageView!
    @IBOutlet weak var noDataButton: UIButton!
    
    /**
        Upon load of this view, load the calendar and adjust the 
        collection cells for the calendar.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // set an observer to see if the filter button is pressed
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(CalendarViewController.actOnFilterUpdate(_:)), name: "carleton150.filterUpdate", object: nil)
        
        // set an observer to see if the parent calendar can update
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(CalendarViewController.actOnParentCalendarUpdate(_:)), name: "carleton150.filterCalendarUpdate", object: nil)
    
        // set an observer to see if the parent calendar fails to update
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(CalendarViewController.actOnFailure(_:)), name: "carleton150.calendarUpdateFailure", object: nil)
        
        // depending on the current state of the calendar data, change the button text
        if calendar.count == 0 {
            self.noDataButton.setTitle("Seems like we didn't get data for some reason. Try again?", forState: UIControlState.Normal)
        } else {
            self.noDataButton.setTitle("Seems like there isn't data for this date. Go back?", forState: UIControlState.Normal)
        }
        
        // set the parent view
        self.calendar = self.parentView.calendar
        self.filteredCalendar = self.parentView.calendar
        
        // set the current table limit
        self.tableLimit = self.filteredCalendar.count

        // set the view's background colors
        view.backgroundColor = UIColor(red: 252, green: 212, blue: 80, alpha: 1.0)
        
        // set the deceleration rate for the event cell snap
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    /**
        If there's nothing in the calendar view, there's either
        data that's missing or we simply don't have information for
        that date. Either way, the user should get either today's stuff
        or we should get more data.
     */
    @IBAction func reloadCalendarData(sender: AnyObject) {
        self.noDataButton.hidden = true
        self.warningSign.hidden = true
        if calendar.count == 0 {
            self.showWaitOverlay()
            CalendarDataService.updateEvents()
        } else {
            if filteredCalendar.count == 0 {
                let userInfo: [NSObject : AnyObject]? = ["date" : NSDate()]
                NSNotificationCenter
                    .defaultCenter()
                    .postNotificationName("carleton150.filterUpdate", object: nil, userInfo: userInfo)
            }
        }
    }
   
    /**
        When the calendar has been updated, set the calendar and 
        reload the view.
     */
    func actOnParentCalendarUpdate(notification: NSNotification) {
        self.removeAllOverlays()
        self.noDataButton.hidden = true
        self.warningSign.hidden = true
        self.calendar = self.parentView.calendar
        self.filteredCalendar = self.calendar
        self.collectionView!.reloadData()
    }
    
    /**
        If the calendar fails to update, bring back the button
        and get rid of the overlay.
     */
    func actOnFailure(notification: NSNotification) {
        self.removeAllOverlays()
        self.noDataButton.hidden = false
        self.warningSign.hidden = false
    }
   
    /**
        Prepares for segues from the calendar to its detail modals by passing
        the data required for the modal along to the modal instance.
     
        - Parameters:
            - segue: The triggered segue.
     
            - sender: The collecton view cell that triggered the segue.
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "showCalendarDetail") {
			let detailViewController = (segue.destinationViewController as! CalendarDetailView)
			detailViewController.parentView = self
            detailViewController.setData(sender as! CalendarCell)
		}
    }
   
    /**
        Upon an update to the filter (which occurs whenever the checkmark 
        is pressed next to the date picker) changes the currently viewed
        events by filtering on the current day.
     
        - Parameters:
            - notification: The notification that passes along the date used
                            for filtering and triggers this method.
     */
    func actOnFilterUpdate(notification: NSNotification) {
        if let date: NSDate = notification.userInfo!["date"] as? NSDate {
            self.filteredCalendar = calendar.filter() {
                event in
                return (event["startTime"] as! NSDate).isGreaterThanDate(date)
            }
            self.collectionView!.reloadData()
            self.collectionView!.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
        }
    }
    
    /**
        Gets the image backgrounds for the calendar.
     
        - Returns: A list of UIImage backgrounds to place in the collection view.
     */
    func getEventImages() -> [UIImage] {
        for i in 1 ..< 11 {
            let eventImage = UIImage(named: "Event-" + String(i))
            if let eventImage = eventImage {
              eventImages.append(eventImage)
            }
        }
        return eventImages
    }
    
    /**
        Determines the number of sections in the calendar collection view.
     
        - Parameters:
            - collectionView: The collection view being used for the calendar.
     */
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    /**
        Determines the number of cells in the calendar collection view.
     
        - Parameters:
            - collectionView:         The collection view being used for the calendar.
     
            - numberOfItemsInSection: The number of items in the calendar.
     */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCalendar.count
    }
    
    /**
        Animates a section of the calendar to focus at the top of the page on tap.
     
        - Parameters:
            - collectionView: The collection view being used for the calendar.
     
            - indexPath:      The index of the cell that was clicked.
     */
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let layout = collectionViewLayout as! CalendarLayout
        let offset = layout.dragOffset * CGFloat(indexPath.item)
        if collectionView.contentOffset.y != offset {
            collectionView.setContentOffset(CGPoint(x: 0, y: offset), animated: true)
        }
    }
    
    /**
        Fills each section of the calendar with data as they are loaded into the view.
     
        - Parameters:
            - collectionView: The collection view being used for the calendar.
     
            - indexPath:      The index of the current cell.
     
        - Returns: A built calendar cell.
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        let images = getEventImages()
        let eventText = filteredCalendar[indexPath.item]["title"]
        cell.eventTitle.text = eventText as? String
        cell.currentImage = images[indexPath.item % 10]
        cell.locationLabel.text = filteredCalendar[indexPath.item]["location"]! as? String
        let date: String
        if let result: NSDate = filteredCalendar[indexPath.item]["startTime"] as? NSDate {
            date = parseDate(result)
        } else {
            date = "No Time Available"
        }
        cell.timeLabel.text = date
        cell.eventDescription = filteredCalendar[indexPath.item]["description"]! as? String
        return cell
    }
   
    /**
        A convenience function to turn the NSDate objects returned
        from the data service into human readable strings for presentation.
     
        - Parameters:
            - date: A date to be turned into a nice stringified version of itself.
     */
    private func parseDate(date: NSDate) -> String {
        let outFormatter = NSDateFormatter()
        outFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        outFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return outFormatter.stringFromDate(date)
    }
   
    /**
        In case of a bad connection, handles it and informs the user.
    
        - Parameters: 
            - limit: The limit on the number of events in case the
                     user wants to try requesting for information again. 
     
            - date:  The earliest date from which to get data in case the 
                     user wants to try again.
     */
    func badConnection(limit: Int, date: NSDate) {
        let alert = UIAlertController(title: "Bad Connection", message: "You seemed to have trouble connecting to our server. Try again?", preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
            (UIAlertAction) -> Void in
            // do nothing for now.
        }
        let alertAction2 = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) {
            (UIAlertAction) -> Void in
            // TODO: Fix how this works.
        }
        alert.addAction(alertAction1)
        alert.addAction(alertAction2)
        self.presentViewController(alert, animated: true) { () -> Void in }
    }
}


