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
    var eventURL: String!
    
    override func viewDidLoad() {
        // set the text fields for the event
        self.titleLabel.text = self.eventTitle
        self.timeLabel.text = self.eventTime
        self.locationLabel.text = self.eventLocation

        let attributedText = NSMutableAttributedString(string: self.eventSummary + "\n\n")
        if self.eventURL.count > 0 {
            let link = NSAttributedString(string: "More details on Carleton's website...", attributes: [NSAttributedString.Key.link: self.eventURL])
            attributedText.append(link)
        }
        attributedText.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0)], range: NSRange(location: 0, length: attributedText.length))
        self.eventSummaryText.attributedText = attributedText

        // stops the text view from being edited
        self.eventSummaryText.isEditable = false

    }
    
    func setData(_ calendarCell: CalendarTableCell) {
        self.eventTitle = calendarCell.title
        self.eventTime = calendarCell.time
        self.eventLocation = calendarCell.location
        self.eventSummary = calendarCell.summary
        self.eventURL = calendarCell.url
    }
}
