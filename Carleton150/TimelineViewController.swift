//
//  TimelineViewController.swift
//  Carleton150

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var geofenceName: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
	var parentVC: HistoricalViewController!
	var selectedGeofence: String!
    var timeline: [Dictionary<String, String>?]!
	
    override func viewDidLoad() {
        // add bottom border to the timeline title
        titleView.addBottomBorderWithColor(UIColor(white: 0.9, alpha: 0.95), width: 1.5)
       
        // set the dataSource and delegate for the timeline table
		tableView.dataSource = self
		tableView.delegate = self
	
        // set the title
		if let selectedGeofence = selectedGeofence {
			geofenceName.text = selectedGeofence
		} else {
			geofenceName.text = ""
		}
      
        // set a default row height
        tableView.estimatedRowHeight = 160.0
       
        if let timeline = timeline {
            // sort the event timeline by date
            self.timeline = timeline.sort() {
                event1, event2 in
                return event1!["year"] > event2!["year"]
            }
        } else {
            self.timeline  = []
        }
	}
	
	
	/**
		Called just before segue is performed. Segue can be to the either a detail popover or
        an upload view for the memories.
		
		Parameters
			- sender: this will be either an image view or a button
	 */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "showTimelineDetail") {
			let detailViewController = (segue.destinationViewController as! TimelineDetailView)
			detailViewController.parentView = self
            detailViewController.setData(sender as! TimelineTableCell)
        }
    }
	
    
    /**
        Upon clicking outside the timeline view or on the X button, 
        dismiss the view.
     
        - Parameters: 
            - sender: The UI element that triggered the action.
     */
	@IBAction func exitTimeline(sender: AnyObject) {
        parentVC.dismissViewControllerAnimated(true, completion: nil)
	}

    /**
        Determines the number of sections in the table view.
     
        - Parameters:
            - tableView: The table view being used for the timeline.
     
        - Returns: 1. Nothing exciting here.
     */
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
    /**
        Determines the number of cells in the table view.
     
        - Parameters:
            - tableView: The table view being used for the timeline.
     
            - section: The current section of the table view.
     
        - Returns: The number of historical events for the triggered geofence.
     */
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline.count
	}
    
    /**
        Determines the of each of the cells in the table view by 
        using autolayout to determine the cell height.
     
        - Parameters:
            - tableView: The table view being used for the timeline.
     
            - indexPath: The current cell index of the table view.
    
        - Returns: The calculated height of the table view cell.
     */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
	
    /**
        Adds data to each of the cells in the timeline view.
     
        - Parameters:
            - tableView: The table view being used for the timeline.
     
            - indexPath: The current cell index of the table view.
     
        - Returns: The modified table view cell.
     */
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let selectedEntry = timeline[indexPath.row],
               dataType = selectedEntry["type"] {
            if dataType == "text" {
                let cell: TimelineTableCellTextOnly = tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
                cell.setCellViewTraits()
                cell.cellSummary = timeline[indexPath.row]?["summary"]
                cell.cellDescription = timeline[indexPath.row]?["desc"]
                cell.cellTimestamp = timeline[indexPath.row]?["year"]
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
                
            } else if dataType == "image" {
                let cell: TimelineTableCellImageOnly = tableView.dequeueReusableCellWithIdentifier("timelineTableCellImageOnly", forIndexPath: indexPath) as! TimelineTableCellImageOnly
                if let image = timeline[indexPath.row]?["data"],
                       data = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                    cell.cellImage = UIImage(data: data)
                }
                cell.setCellViewTraits()
                cell.cellCaption = timeline[indexPath.row]?["caption"]
                cell.cellSummary = timeline[indexPath.row]?["summary"]
                cell.cellTimestamp = timeline[indexPath.row]?["year"]
                cell.cellDescription = timeline[indexPath.row]?["desc"]
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
                cell.setCellViewTraits()
                cell.cellSummary = timeline[indexPath.row]?["summary"]
                cell.cellDescription = timeline[indexPath.row]?["desc"]
                cell.cellTimestamp = timeline[indexPath.row]?["year"]
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                return cell
            }
        }
        return tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
    }
}
