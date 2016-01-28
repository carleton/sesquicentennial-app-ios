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
	var landmarkData = ["type":"","data":""]

    override func viewDidLoad() {

		tableView.dataSource = self
		tableView.delegate = self
		
		geofenceName.text = selectedGeofence
		
		HistoricalDataService.requestContent(selectedGeofence) { (success, result) -> Void in
			self.landmarkData = result!
			self.tableView.reloadData()
		}
    }
	
	@IBAction func exitTimeline(sender: AnyObject) {
		mapCtrl.dismissViewControllerAnimated(true) { () -> Void in
			print("Dismissed")
		}
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return 2
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
		
		cell.title.text = landmarkData["type"]!
		cell.desc.text = landmarkData["data"]!
		cell.timestamp.text = "2015"
		// Configure the cell...
		
		return cell
	}

}