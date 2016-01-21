//
//  QuestCollectionViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 1/20/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

private let reuseIdentifier = "QuestCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class QuestCollectionViewController: UICollectionViewController {

    var quests: [Quest] = []
    let images: [UIImage] = [UIImage(named: "magical_mystery.jpg")!, UIImage(named: "let_it_be.jpg")!]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getQuests()
    }

	func getQuests() {
        
		let waypoint = WayPoint(location: CLLocationCoordinate2D(latitude: 100, longitude: 100), radius: 100.0, clue: "I am the Walrus", hint: "They are the Eggmen!")
		let quest = Quest(wayPoints: [waypoint], name: "Magical Mystery Tour", description: "The magical mystery tour is coming to take you away! Coming to take you away. Embark on this tittalating and tantalizing journey through the lands of the Walrus!", completionMessage: "You are the eggman")
		quests.append(quest)
		
		let waypoint2 = WayPoint(location: CLLocationCoordinate2D(latitude: 100, longitude: 100), radius: 100.0, clue: "Mother Mary Comes To Me", hint: "Speaking Words of Wisdom")
		let quest2 = Quest(wayPoints: [waypoint2], name: "Let It Be", description: "A quest for those with chiller inclinations. If you can decipher the words of wisdom, you might just be mother mary. What? You heard me.", completionMessage: "You are the eggman")
		quests.append(quest2)
		
		self.collectionView!.reloadData()
	}
	
	
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return quests.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! QuestCollectionViewCell
		cell.backgroundColor = UIColor.whiteColor()
		cell.imageView.image = images[indexPath.row]
		cell.name.text = quests[indexPath.row].name
		cell.text.text = quests[indexPath.row].questDescription
		
        // Configure the cell
//		cell.backgroundColor = UIColor.blackColor()
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}

extension QuestCollectionViewController: UICollectionViewDelegateFlowLayout {
//	func collectionView(collectionView: UICollectionView,
//		layout collectionViewLayout: UICollectionViewLayout,
//		insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//			return sectionInsets
//	}
}
