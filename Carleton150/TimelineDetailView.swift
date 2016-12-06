//
//  TimelineDetailView.swift
//  Carleton150

class TimelineDetailView: UIViewController {
    var parentView: UIViewController!
    var summary: String!
    var eventDescription: String?
    var caption: String!
    var image: UIImage!
    var timestamp: String?
    
    /**
        A convenience method for setting the data as a segue
        is initiated.
     */
    func setData(_ timelineCell: TimelineTableCell) {
        self.summary = timelineCell.cellSummary
        self.eventDescription = timelineCell.cellDescription
                                ?? "No description available for this one..."
        self.caption = timelineCell.cellCaption
        self.timestamp = timelineCell.cellTimestamp
        self.image = timelineCell.cellImage
    }
}
