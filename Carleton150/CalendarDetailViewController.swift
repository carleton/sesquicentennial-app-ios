//
//  CalendarDetailViewController.swift
//  Carleton150

import Foundation

class CalendarDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var eventTitle: String!
    var eventTime: String!
    var eventLocation: String!
    
    override func viewDidLoad() {
        self.titleLabel.text = self.eventTitle
        self.timeLabel.text = self.eventTime
        self.locationLabel.text = self.eventLocation
    }
    
    func setData(calendarCell: CalendarTableCell) {
        self.eventTitle = calendarCell.title
        self.eventTime = calendarCell.time
        self.eventLocation = calendarCell.location
    }
}