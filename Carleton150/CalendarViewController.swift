//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBAction func goToYesterday(sender: UIBarButtonItem) {}
    @IBAction func goToTomorrow(sender: UIBarButtonItem) {}
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self,
             selector: #selector(self.actOnCalendarUpdate(_:)),
             name: "carleton150.calendarUpdate", object: nil)
        CalendarDataService.getEvents()
    }
    
    
    func actOnCalendarUpdate(notification: NSNotification) {
        
    }
    
    
    /**
        Determines the number of cells in the table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - section: The current section of the table view.
     
        - Returns: The number of calendar events.
     */
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
	}
    
    
    /**
        Adds data to each of the cells in the calendar table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - indexPath: The current cell index of the table view.
     
        - Returns: The modified table view cell.
     */
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
