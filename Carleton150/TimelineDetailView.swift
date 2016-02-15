//
//  TimelineDetailView.swift
//  Carleton150

import Foundation

class TimelineDetailView: UIViewController {
    
    var parentView: UIViewController!
    var summary: String!
    var eventDescription: String?
    var caption: String!
    var image: UIImage!
    var timestamp: String?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setData(timelineCell: TimelineTableCell) {
        self.summary = timelineCell.cellSummary
        self.eventDescription = timelineCell.cellDescription
                                ?? "No description available for this one..."
        self.caption = timelineCell.cellCaption
        self.timestamp = timelineCell.cellTimestamp
        self.image = timelineCell.cellImage
    }
    
    override func viewDidLoad() {
        // forces background to be transparent
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        self.dateLabel.text = self.timestamp ?? ""
        self.descriptionLabel.text = self.eventDescription
    }
    
    @IBAction func dismissDetailView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }
}
