//
//  QuestContentViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 2/17/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class QuestContentViewController: UIViewController {

	var pageIndex: Int!
	
	var titleText: String!
	var image: String!
	var descText: String!
	var buttonText: String!
	var quest: Quest!
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descTextView: UITextView!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	
	/**
	Prepares for a segue to the detail view for a particular point of
	interest on the map.
	
	Parameters:
	- segue:  The segue that was triggered by user. If this is not the
	segue to the landmarkDetail view, then don't perform the
	segue.
	
	- sender: The sender, in our case, will be one of the Google Maps markers
	that was pressed, which will in turn have data associated with
	it that will given to the landmark detail view.
	
	*/
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "questStartSegue" {
			let nextCtrl = (segue.destinationViewController as! QuestPlayingViewController)
			nextCtrl.quest = self.quest
		}
	}
	
	/**
	Prepares for a segue to the detail view for a particular point of
	interest on the map.
	
	Parameters:
	- segue:  The segue that was triggered by user. If this is not the
	segue to the landmarkDetail view, then don't perform the
	segue.
	
	- sender: The sender, in our case, will be one of the Google Maps markers
	that was pressed, which will in turn have data associated with
	it that will given to the landmark detail view.
	
	*/
    override func viewDidLoad() {
		// Quest Name
		if let titleText = titleText {
			self.nameLabel.text = titleText
		} else {
			self.nameLabel.text = ""
		}
		// Quest Description
		if let descText = descText {
			self.descTextView.text = descText
		} else {
			self.descTextView.text = ""
		}
		self.descTextView.editable = false
		// Quest Image
		if let image = self.image {
			self.imageView.image = UIImage(data: NSData(base64EncodedString: image, options: .IgnoreUnknownCharacters)!)
		} else {
			// this will do something
		}
		
    }

	override func viewWillAppear(animated: Bool) {
		// Data Persistance
		if let startedQuests = NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") as! NSDictionary! {
			if let curQuestWaypoint = startedQuests[titleText] as! Int! {
				let percentageCompleted = Int((Float(curQuestWaypoint + 1) / Float(quest.wayPoints.count))*100)
				self.startButton.setTitle("Continue: \(percentageCompleted)% Completed", forState: .Normal)
				self.startButton.backgroundColor = UIColor(red: 230/255, green: 159/255, blue: 19/255, alpha: 1)
			}
		}
	}
	
	/**
	Prepares for a segue to the detail view for a particular point of
	interest on the map.
	
	Parameters:
	- segue:  The segue that was triggered by user. If this is not the
	segue to the landmarkDetail view, then don't perform the
	segue.
	
	- sender: The sender, in our case, will be one of the Google Maps markers
	that was pressed, which will in turn have data associated with
	it that will given to the landmark detail view.
	
	*/
	@IBAction func startAction(sender: AnyObject) {
		if var startedQuests = NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") as! Dictionary<String,Int>! {
			if (startedQuests[quest.name] == nil) {
				startedQuests[quest.name] = 0
				NSUserDefaults.standardUserDefaults().setObject(startedQuests,forKey: "startedQuests")
			}
		}
	}
	
}
