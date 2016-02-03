//
//  CalendarViewController.swift
//  Carleton150

import Foundation
import SwiftOverlays

class CalendarViewController: UICollectionViewController {
    
    var schedule : [Dictionary<String, String>] = []
    var eventImages: [UIImage] = []
    var tableLimit : Int!
    
    /**
        Upon load of this view, load the calendar and adjust the 
        collection cells for the calendar.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // shows a wait overlay while setting up the calendar
        self.showWaitOverlay()
        
        // set properties on the navigation bar 
        Utils.setUpNavigationBar(self)
       
        // gets the calendar data
        getCalendar(20, date: NSDate())
        
        // stop the navigation bar from covering the calendar content
        self.navigationController!.navigationBar.translucent = false;

        // set the view's background colors
        view.backgroundColor = UIColor(red: 252, green: 212, blue: 80, alpha: 1.0)
        collectionView!.backgroundColor = UIColor(red: 224, green: 224, blue: 224, alpha: 1.0)
        
        // set the deceleration rate for the event cell snap
        collectionView!.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
   
    /**
        Upon view appearance, checks to see if there's currently data. If not, attempts
        to load data.
     */
    override func viewWillAppear(animated: Bool) {
        if self.schedule.count == 0 {
            getCalendar(20, date: NSDate())
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
        Pulls the calendar data from the server, and loads the collection to
        place the data into the views.
     
        - Parameters:
            - limit:      A hard limit on the amount of quests returned
                          by the server.
     
            - date:       The earliest date from which to get data.
     */
    func getCalendar(limit: Int, date: NSDate?) {
        
        self.tableLimit = limit
        
        if let desiredDate = date {
            CalendarDataService.requestEvents(desiredDate, limit: limit, completion: {
                (success: Bool, result: [Dictionary<String, String>]?) in
                if success {
                    self.schedule = result!
                    self.collectionView!.reloadData()
                } else {
                    self.badConnection(limit, date: desiredDate)
                }
            });
        } else {
            CalendarDataService.requestEvents(NSDate(), limit: limit, completion: {
                (success: Bool, result: [Dictionary<String, String>]?) in
                if success {
                    self.schedule = result!
                    self.collectionView!.reloadData()
                } else {
                    self.badConnection(limit, date: NSDate())
                }
            });
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
        return schedule.count
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
        self.removeAllOverlays()
        let images = getEventImages()
        let eventText = schedule[indexPath.item]["title"]
        cell.eventTitle.text = eventText
        cell.currentImage = images[indexPath.item % 10]
        cell.locationLabel.text = schedule[indexPath.item]["location"]!
        cell.timeLabel.text = schedule[indexPath.item]["startTime"]!
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
            self.getCalendar(limit, date: date)
        }
        alert.addAction(alertAction1)
        alert.addAction(alertAction2)
        self.presentViewController(alert, animated: true) { () -> Void in }
    }
}