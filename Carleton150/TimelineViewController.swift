//
//  TimelineViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 1/27/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var geofenceName: UILabel!
	
	var mapCtrl:UIViewController!

    override func viewDidLoad() {

		tableView.dataSource = self
		tableView.delegate = self
		
		geofenceName.text = selectedGeofence
		
	}
	
	@IBAction func exitTimeline(sender: AnyObject) {
		mapCtrl.dismissViewControllerAnimated(true) { () -> Void in
			print("Dismissed")
		}
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return landmarksInfo![selectedGeofence]!.count
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
		
		cell.title.text = landmarksInfo![selectedGeofence]![indexPath.row]!["type"]!
		cell.desc.text = landmarksInfo![selectedGeofence]![indexPath.row]!["data"]!
		cell.timestamp.text = "2015"
		
		return cell
	}

}