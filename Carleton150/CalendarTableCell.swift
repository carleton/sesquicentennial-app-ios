//
//  calendarTableCell.swift
//  Carleton150

import Foundation

class CalendarTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var summary: String?
    
    var title: String? {
        didSet {
            self.titleLabel.text = self.title ?? "No Title"
        }
    }
    
    var time: String? {
        didSet {
            self.timeLabel.text = self.time ?? "No Time Available"
        }
    }
    
    var location: String? {
        didSet {
            self.locationLabel.text = self.location ?? "No Location Available"
        }
    }
}