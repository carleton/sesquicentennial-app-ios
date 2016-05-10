//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBAction func goToYesterday(sender: UIBarButtonItem) {}
    @IBAction func goToTomorrow(sender: UIBarButtonItem) {}
    
    var calendar: [Dictionary<String, AnyObject?>]?

    override func viewDidLoad() {
        
        // set the current date
        currentDateLabel.text = chosenDate(NSDate())
        
        // set the dataSource and delegate for the calendar table view
		calendarTableView.dataSource = self
		calendarTableView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self,
             selector: #selector(self.actOnCalendarUpdate(_:)),
             name: "carleton150.calendarUpdate", object: nil)
        CalendarDataService.getEvents()
    }
    
    
    func actOnCalendarUpdate(notification: NSNotification) {
        self.calendar = CalendarDataService.schedule
        calendarTableView.reloadData()
    }
    
    
    /**
        Determines the number of cells in the table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - section: The current section of the table view.
     
        - Returns: The number of calendar events.
     */
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = self.calendar?.count {
            return count
        } else {
            return 0
        }
	}
    
    
    /**
        Adds data to each of the cells in the calendar table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - indexPath: The current cell index of the table view.
     
        - Returns: The modified table view cell.
     */
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let calendarEntry = calendar?[indexPath.row] {
            let cell: calendarTableCell =
                tableView.dequeueReusableCellWithIdentifier("calendarTableCell",
                forIndexPath: indexPath) as! calendarTableCell
            
            cell.title = calendarEntry["title"] as? String ?? "No Title"
            
            if let time: NSDate = calendarEntry["startTime"] as? NSDate {
                cell.time = parseDate(time)
            } else {
                cell.time = "No Time Available"
            }
            return cell
        } else {
            let cell: calendarTableCell =
                tableView.dequeueReusableCellWithIdentifier("calendarTableCell",
                forIndexPath: indexPath) as! calendarTableCell
            return cell
        }
    }
    
    private func chosenDate(date: NSDate) -> String {
        let outFormatter = NSDateFormatter()
        outFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        outFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        return outFormatter.stringFromDate(date)
    }
    
    /**
         A convenience function to turn the NSDate objects returned
         from the data service into human readable strings for presentation.
         
         - Parameters:
            - date: A date to be turned into a nice stringified version of itself.
     */
    private func parseDate(date: NSDate) -> String {
        let outFormatter = NSDateFormatter()
        outFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        outFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        return outFormatter.stringFromDate(date)
    }

}
