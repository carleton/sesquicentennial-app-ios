//
//  TimelineViewController.swift
//  Carleton150

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var geofenceName: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var uploadButton: UIButton!
    
	var mapCtrl: HistoricalViewController!
    var timeline: [Dictionary<String, String>?] = []
    var memories: [Dictionary<String, String>?] = []
    var showMemories: Bool = false

    override func viewDidLoad() {
        // add bottom border to the timeline title
        titleView.addBottomBorderWithColor(UIColor(white: 0.9, alpha: 0.95), width: 1.5)
       
        // set the dataSource and delegate for the timeline table
		tableView.dataSource = self
		tableView.delegate = self
	
        // set the title
		geofenceName.text = selectedGeofence
      
        // set a default row height
        tableView.estimatedRowHeight = 160.0
       
        if !showMemories {
            // sort the event timeline by date
            if let unsortedTimeline = landmarksInfo?[selectedGeofence] {
                timeline = unsortedTimeline.sort() {
                    event1, event2 in
                    return event1!["year"] > event2!["year"]
                }
            }
            // hide the upload button if in timeline
            self.uploadButton.hidden = true
            
        } else {
            // start loading animation while getting memories
            loadingView.startAnimating()
        }
	}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "showTimelineDetail") {
			let detailViewController = (segue.destinationViewController as! TimelineDetailView)
			detailViewController.parentView = self
            detailViewController.setData(sender as! TimelineTableCell)
        } else if segue.identifier == "showUploadView" {
			let detailViewController = (segue.destinationViewController as! MemoryUploadView)
			detailViewController.parentView = self
        }
    }
    
    func requestMemories() {
        if let location: CLLocation = self.mapCtrl.locationManager.location {
            let currentLocation: CLLocationCoordinate2D = location.coordinate
            HistoricalDataService.requestMemoriesContent(currentLocation) { success, result in
                if (success) {
                    self.memories = result.sort() { memory1, memory2 in
                        return memory1!["year"] > memory2!["year"]
                    }
                    self.tableView.reloadData()
                    self.loadingView.stopAnimating()
                } else {
                    print("Failed to get info")
                }
            }
        } else {
            print("Request failed because we didn't have location")
        }
    }
	
    /**
        Upon clicking outside the timeline view or on the X button, 
        dismiss the view.
     
        - Parameters: 
            - sender: The UI element that triggered the action.
     */
	@IBAction func exitTimeline(sender: AnyObject) {
        mapCtrl.momentButton.hidden = false
		mapCtrl.dismissViewControllerAnimated(true) { () -> Void in }
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
        return showMemories ? self.memories.count : timeline.count
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
        if showMemories {
            let cell: TimelineTableCellImageOnly = tableView.dequeueReusableCellWithIdentifier("timelineTableCellImageOnly", forIndexPath: indexPath) as! TimelineTableCellImageOnly
            if let image = memories[indexPath.row]?["data"],
                   data = NSData(base64EncodedString: image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) {
                cell.cellImage = UIImage(data: data)
            }
            cell.setCellViewTraits()
            cell.cellCaption = memories[indexPath.row]?["caption"]
            cell.cellSummary = memories[indexPath.row]?["uploader"]
            cell.cellTimestamp = memories[indexPath.row]?["year"]
            cell.cellDescription = memories[indexPath.row]?["desc"]
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        } else {
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
        }
        return tableView.dequeueReusableCellWithIdentifier("timelineTableCellTextOnly", forIndexPath: indexPath) as! TimelineTableCellTextOnly
    }
}
