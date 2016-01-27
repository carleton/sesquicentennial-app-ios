//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UICollectionViewController {
    
    var schedule : [Dictionary<String, String>] = []
    var eventImages: [UIImage] = []
    var tableLimit : Int!
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.showLogo(self)
        getCalendar(20, date: NSDate())

        view.backgroundColor = UIColor(red: 252, green: 212, blue: 80, alpha: 1.0)
        collectionView!.backgroundColor = UIColor(red: 224, green: 224, blue: 224, alpha: 1.0)
    }
   
    // TODO: make this method get the images
    func getEventImages() -> [UIImage] {
        for i in 1 ..< 11 {
            let eventImage = UIImage(named: "Event-" + String(i))
            if let eventImage = eventImage {
              eventImages.append(eventImage)
            }
        }
        return eventImages
    }
    
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
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return schedule.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        let images = getEventImages()
        cell.currentImage = images[indexPath.item % 10]
        
        return cell
    }
}