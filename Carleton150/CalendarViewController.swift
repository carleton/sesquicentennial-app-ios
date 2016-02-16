//
//  CalendarViewController.swift
//  Carleton150

import Foundation
import SwiftOverlays

class CalendarViewController: UICollectionViewController {
   
    var calendar: [Dictionary<String, String>] = []
    var cells: [CalendarCell] = []
    var eventImages: [UIImage] = []
    var tableLimit : Int!
   
    /**
        Initializes this view and sets up the 
        observer for the calendar data.
     */
    required init?(coder decoder : NSCoder) {
        super.init(coder: decoder)

        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: "actOnCalendarUpdate:", name: "carleton150.calendarUpdate", object: nil)
        
    }
    
    /**
        Upon load of this view, load the calendar and adjust the 
        collection cells for the calendar.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the current table limit
        self.tableLimit = calendar.count
        
        // set properties on the navigation bar 
        Utils.setUpNavigationBar(self)
       
        // stop the navigation bar from covering the calendar content
        self.navigationController!.navigationBar.translucent = false;

        // set the view's background colors
        view.backgroundColor = UIColor(red: 252, green: 212, blue: 80, alpha: 1.0)
        collectionView!.backgroundColor = UIColor(red: 224, green: 224, blue: 224, alpha: 1.0)
        
        // set the deceleration rate for the event cell snap
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "showCalendarDetail") {
			let detailViewController = (segue.destinationViewController as! CalendarDetailView)
			detailViewController.parentView = self
            detailViewController.setData(sender as! CalendarCell)
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
        Upon noticing that the calendar has been updated,
        update the UI accordingly.
     
        - Parameters:
            - notification: The notification triggered from the CalendarDataService.
     */
    func actOnCalendarUpdate(notification: NSNotification) {
        if let calendar = CalendarDataService.schedule {
            self.calendar = calendar
            let indexPath = NSIndexPath(forItem: 0, inSection: 0)
            let _ = CalendarDetailView()
            let _ = self.collectionView!
                .dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        }
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
        return calendar.count
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
        let eventText = calendar[indexPath.item]["title"]
        cell.eventTitle.text = eventText
        cell.currentImage = images[indexPath.item % 10]
        cell.locationLabel.text = calendar[indexPath.item]["location"]!
        cell.timeLabel.text = calendar[indexPath.item]["startTime"]!
        cell.eventDescription = calendar[indexPath.item]["description"]!
        return cell
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