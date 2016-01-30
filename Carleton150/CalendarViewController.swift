//
//  CalendarViewController.swift
//  Carleton150

import Foundation

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
                self.schedule = result!
                self.collectionView!.reloadData()
            });
        } else {
            CalendarDataService.requestEvents(NSDate(), limit: limit, completion: {
                (success: Bool, result: [Dictionary<String, String>]?) in
                self.schedule = result!
                self.collectionView!.reloadData()
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
        let images = getEventImages()
        let eventText = schedule[indexPath.item]["title"]
        cell.eventTitle.text = eventText
        cell.currentImage = images[indexPath.item % 10]
        cell.locationLabel.text = schedule[indexPath.item]["location"]!
        cell.timeLabel.text = schedule[indexPath.item]["startTime"]!
        return cell
    }
}