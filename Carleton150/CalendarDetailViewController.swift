//
//  CalendarDetailViewController.swift
//  Carleton150

import Foundation

class CalendarDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var eventTitle: String!
    
    override func viewDidLoad() {
        self.titleLabel.text = self.eventTitle
    }
    
    func setData(calendarCell: CalendarTableCell) {
        self.eventTitle = calendarCell.title
    }
}