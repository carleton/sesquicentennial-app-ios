//
//  calendarTableCell.swift
//  Carleton150

import Foundation

class calendarTableCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
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
    
}