//
//  UpdateFailureViewController.swift
//  Carleton150

import Foundation

class UpdateFailureViewController: UIViewController {
    
    @IBAction func reloadCalendar() {
        CalendarDataService.getEvents()
    }
    
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
}