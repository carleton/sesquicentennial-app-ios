//
//  TimelineViewController.swift
//  Carleton150

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var geofenceName: UILabel!
    @IBOutlet weak var titleView: UIView!
    
	var mapCtrl: UIViewController!

    override func viewDidLoad() {
        // add bottom border to the timeline title
        titleView.addBottomBorderWithColor(UIColor(white: 0.9, alpha: 1.0), width: 1.5)
       
        // set the dataSource and delegate for the timeline table
		tableView.dataSource = self
		tableView.delegate = self
	
        // set the title
		geofenceName.text = selectedGeofence
        
        tableView.estimatedRowHeight = 160.0
	}
	
    /**
        Upon clicking outside the timeline view or on the X button, 
        dismiss the view.
     
        - Parameters: 
            - sender: The UI element that triggered the action.
     */
	@IBAction func exitTimeline(sender: AnyObject) {
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
		return landmarksInfo![selectedGeofence]!.count
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
            cell.cellDescription = landmarksInfo?[selectedGeofence]?[indexPath.row]?["desc"]
            cell.cellTimestamp = landmarksInfo?[selectedGeofence]?[indexPath.row]?["year"]
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        return cell
	}
}

extension UIView {
    
    /**
        Adds a bottom border to a UIView of the specified color and stroke width. 
        
        - Parameters: 
            - color: The color you want for the border. 
            
            - width: The stroke width of the bottom border.
     */
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
}
