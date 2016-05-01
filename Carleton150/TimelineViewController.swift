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
    
	var parentVC: HistoricalViewController!
	var selectedGeofence: String!
    var timeline: [Dictionary<String, String>?]!
    var memories: [Memory] = []
    var showMemories: Bool = false
	var lastRequestLocation: CLLocation!
	var requestThreshold: Double = 25
	
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
       
        if !showMemories {
			if let timeline = timeline {
				// sort the event timeline by date
				self.timeline = timeline.sort() {
					event1, event2 in
					return event1!["year"] > event2!["year"]
				}
			} else {
				self.timeline  = []
			}

            // hide the upload button if in timeline
            self.uploadButton.hidden = true
            
        } else {
			// start loading animation while getting memories
            loadingView.startAnimating()
			// update memories
			if let curLocation = self.parentVC.locationManager.location {
				self.updateMemories(curLocation)
			}
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
        } else if segue.identifier == "showUploadView" {
			let detailViewController = (segue.destinationViewController as! MemoryUploadView)
			detailViewController.parentView = self
        }
    }
	
	/**
		Checks to see if the current location is far enough away from the last place memories
		were returned for.
		
		Parameters:
			- curLocation: current location of user
	
		Returns:
			- true if distance far enough or if last location not set. false otherwise
	
	 */
	func shouldRequestMemories(curLocation: CLLocation) -> Bool {
		if (self.lastRequestLocation == nil) {
			self.lastRequestLocation = curLocation
			return true
		} else if (Utils.getDistance(self.lastRequestLocation.coordinate, point2: curLocation.coordinate) >= self.requestThreshold) {
				self.lastRequestLocation = curLocation
				return true
		}
		return false
	}
	
	/**
		Makes call to the server to get data for nearby memories. If no memories found sets
		sets current list of memories to []
	 */
    func requestMemories() {
        if let location: CLLocation = self.parentVC.locationManager.location {
            let currentLocation: CLLocationCoordinate2D = location.coordinate
            HistoricalDataService.requestMemoriesContent(currentLocation) { success, result in
                if (success) {
                    if result.count == 0 {
                        
                        // if we are successful, but get zero images, use an alert box to ask if we want to reload or not
                        let alert = UIAlertController(title: "No Memories Found!", message: "We couldn't find any memories near you. Try again?", preferredStyle: UIAlertControllerStyle.Alert)
                        let alertAction1 = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
                            (UIAlertAction) -> Void in
                            self.requestMemories()
                        }
                        let alertAction2 = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) {
                            (UIAlertAction) -> Void in
                            self.exitTimeline(self.geofenceName)
                        }
                        alert.addAction(alertAction1)
                        alert.addAction(alertAction2)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    } else {
                        // if we are successful and get some memories, display them
                        self.memories = result.sort() { memory1, memory2 in
                            return memory1.timestamp.isGreaterThanDate(memory2.timestamp)
                        }
                        self.tableView.reloadData()
                        self.loadingView.stopAnimating()
                    }
                } else {
                    print("Failed to get info")
					self.loadingView.stopAnimating()
					self.memories = []
                }
            }
        } else {
            print("Request failed because we didn't have location")
        }
    }
	
	/**
		Checks to see if distance from last request is large enough and fetches new memories
		if true
	 */
	func updateMemories (curLocation: CLLocation) {
		if (shouldRequestMemories(curLocation)) {
			self.requestMemories()
		} else {
			self.loadingView.stopAnimating()
		}
	}
	
    /**
        Upon clicking outside the timeline view or on the X button, 
        dismiss the view.
     
        - Parameters: 
            - sender: The UI element that triggered the action.
     */
	@IBAction func exitTimeline(sender: AnyObject) {
        if self.memories.count > 0 {
            parentVC.loadedMemories = self.memories
        }
        
		if let lastLoc = self.lastRequestLocation {
			parentVC.lastMemReqLocation = lastLoc
		}
        parentVC.momentButton.hidden = parentVC.hideMemoriesFeature
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
            cell.setCellViewTraits()
            cell.cellImage = memories[indexPath.row].image
            cell.cellCaption = memories[indexPath.row].title
            cell.cellSummary = memories[indexPath.row].uploader
            cell.cellTimestamp = Memory.buildReadableDate(memories[indexPath.row].timestamp)
            cell.cellDescription = memories[indexPath.row].desc
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
