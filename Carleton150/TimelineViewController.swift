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
		mapCtrl.dismissViewControllerAnimated(true) { () -> Void in }
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		return landmarksInfo![selectedGeofence]!.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: TimelineTableCell!
        
        if let selectedEntry = landmarksInfo?[selectedGeofence]?[indexPath.row],
               dataType = selectedEntry["type"] {
        
            if dataType == "text" {
                cell = tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
            } else if dataType == "image" {
                cell = tableView.dequeueReusableCellWithIdentifier("timelineTableCellImageOnly", forIndexPath: indexPath) as! TimelineTableCellImageOnly
                if let image = landmarksInfo?[selectedGeofence]?[indexPath.row]?["data"],
                       data = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                    cell.cellImage = UIImage(data: data)
                }
                cell.cellCaption = landmarksInfo?[selectedGeofence]?[indexPath.row]?["caption"]
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
            }
           
            cell.cellTitle = landmarksInfo?[selectedGeofence]?[indexPath.row]?["summary"]
            cell.cellDescription = landmarksInfo?[selectedGeofence]?[indexPath.row]?["data"]
            cell.cellTimestamp = landmarksInfo?[selectedGeofence]?[indexPath.row]?["year"]
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell
	}
}