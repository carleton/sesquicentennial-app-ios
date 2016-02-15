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
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
   
    /**
        A convenience method for setting the data as a segue
        is initiated.
     */
    func setData(timelineCell: TimelineTableCell) {
        self.summary = timelineCell.cellSummary
        self.eventDescription = timelineCell.cellDescription
                                ?? "No description available for this one..."
        self.caption = timelineCell.cellCaption
        self.timestamp = timelineCell.cellTimestamp
        self.image = timelineCell.cellImage
    }
   
    /**
        Loads the view, darkens the background, and then sets the 
        data inside the view.
     */
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
       
        // sets the current date and description
        self.dateLabel.text = self.timestamp ?? ""
        self.descriptionText.text = self.eventDescription
        
        // stops the text view from being edited
        self.descriptionText.editable = false
    }
   
    /**
        Once the subviews are placed, the description text
        needs to be set so that the text doesn't start at the bottom.
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.descriptionText.setContentOffset(CGPointZero, animated: false)
    }
    
    @IBAction func dismissDetailView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }
}
