//
//  CalendarDetailViewController.swift
//  Carleton150

import Foundation

class CalendarDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventSummaryText: UITextView!
    
    var eventTitle: String!
    var eventTime: String!
    var eventLocation: String!
    var eventSummary: String!
    
    override func viewDidLoad() {
        
        // set the text fields for the event
        self.titleLabel.text = self.eventTitle
        self.timeLabel.text = self.eventTime
        self.locationLabel.text = self.eventLocation
        self.eventSummaryText.text = self.eventSummary
        
        // stops the text view from being edited
        self.eventSummaryText.editable = false

    }
    
    func setData(calendarCell: CalendarTableCell) {
        self.eventTitle = calendarCell.title
        self.eventTime = calendarCell.time
        self.eventLocation = calendarCell.location
        self.eventSummary = calendarCell.summary
    }
}