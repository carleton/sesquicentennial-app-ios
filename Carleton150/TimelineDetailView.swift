//
//  TimelineDetailView.swift
//  Carleton150

import Foundation

class TimelineDetailView: UIViewController {
    
    var parentView: UIViewController!
    var summary: String!
    var eventDescription: String!
    var caption: String!
    var image: UIImage!
    var timestamp: String?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    func setData(timelineCell: TimelineTableCell) {
        self.summary = timelineCell.cellSummary
        self.eventDescription = timelineCell.cellDescription
        self.caption = timelineCell.cellCaption
        self.timestamp = timelineCell.cellTimestamp
        self.image = timelineCell.cellImage
    }
    
    override func viewDidLoad() {
        // forces background to be transparent
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.dateLabel.text = self.timestamp ?? ""
    }
    
    @IBAction func dismissDetailView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }
}
