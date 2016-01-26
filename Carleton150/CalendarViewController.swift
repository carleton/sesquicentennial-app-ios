//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UICollectionViewController {
    
    var schedule : [Dictionary<String, String>] = []
    var eventImages: [UIImage]!
    var tableLimit : Int!
    var colors = [UIColor.yellowColor(), UIColor.blueColor()]
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utils.showLogo(self)
        getCalendar(20, date: NSDate())
        
        for _ in 0 ..< 5 {
            colors += colors
        }

        view.backgroundColor = UIColor(red: 252, green: 212, blue: 80, alpha: 1.0)
        collectionView!.backgroundColor = UIColor.greenColor()
    }
   
    // TODO: make this method get the images
    func getEventImages() -> [UIImage] {
      var eventImages = [UIImage]()
      if let URL = NSBundle.mainBundle().pathForResource("EventImages", ofType: "plist") {
        if let tutorialsFromPlist = NSArray(contentsOfURL: NSURL(fileURLWithPath: URL)) {
          for dictionary in tutorialsFromPlist {
            let eventImage = UIImage(named: dictionary["Background"] as! String)
            if let eventImage = eventImage {
              eventImages.append(eventImage)
            }
          }
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
            });
        } else {
            CalendarDataService.requestEvents(NSDate(), limit: limit, completion: {
                (success: Bool, result: [Dictionary<String, String>]?) in
                self.schedule = result!
            });
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCell", forIndexPath: indexPath) as! CalendarCell
        let images = getEventImages()
        cell.currentImage = images[indexPath.item]
        
        return cell
    }
}