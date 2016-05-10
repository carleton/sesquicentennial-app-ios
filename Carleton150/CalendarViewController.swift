//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    var calendar: [Dictionary<String, AnyObject?>]?
    var currentDate: NSDate? {
        didSet {
            if let date = currentDate {
                currentDateLabel.text = chosenDate(date)
            }
        }
    }

    override func viewDidLoad() {
        
        // set the current date
        self.currentDate = NSDate()
        
        // set the dataSource and delegate for the calendar table view
		calendarTableView.dataSource = self
		calendarTableView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self,
             selector: #selector(self.actOnCalendarUpdate(_:)),
             name: "carleton150.calendarUpdate", object: nil)
        CalendarDataService.getEvents()
    }
    
    
    @IBAction func goToYesterday(sender: UIBarButtonItem) {
        if let date = self.currentDate {
            let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
                NSCalendarUnit.Day, value: -1, toDate: date, options: NSCalendarOptions(rawValue: 0))
            self.currentDate = newDate
            self.goToDate(self.roundDownToNearestDay(newDate!))
        }
    }
    
    
    @IBAction func goToTomorrow(sender: UIBarButtonItem) {
        if let date = self.currentDate {
            let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
                NSCalendarUnit.Day, value: 1, toDate: date, options: NSCalendarOptions(rawValue: 0))
            self.currentDate = newDate
            self.goToDate(self.roundDownToNearestDay(newDate!))
        }
    }
   
    /**
        Goes to the specified date in the calendar table view.
     
        - Parameters:
            - date: The date to go to (rounds down on time)
     */
    func goToDate(inputDate: NSDate?) {
        if let calendarLength = calendar?.count, date = inputDate {
            for i in 0 ..< calendarLength {
                if let eventDate: NSDate = calendar?[i]["startTime"] as? NSDate {
                    if eventDate.isGreaterThanDate(date) {
                        calendarTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                        break
                    }
                }
            }
        }
    }
    
    
    func roundDownToNearestDay(date: NSDate) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = NSDateComponents()
        components.second = -calendar.components(NSCalendarUnit.Second, fromDate: date).second
        components.minute = -calendar.components(NSCalendarUnit.Minute, fromDate: date).minute
        components.hour = -calendar.components(NSCalendarUnit.Hour, fromDate: date).hour
        return calendar.dateByAddingComponents(
            components, toDate: date, options: NSCalendarOptions(rawValue: 0))!
    }
    
    
    func actOnCalendarUpdate(notification: NSNotification) {
        self.calendar = CalendarDataService.schedule
        calendarTableView.reloadData()
    }
    

    /**
         Prepares for segues from the calendar to its detail modals by passing
         the data required for the modal along to the modal instance.
         
         - Parameters:
             - segue: The triggered segue.
             
             - sender: The collecton view cell that triggered the segue.
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showCalendarDetail") {
            let detailViewController = (segue.destinationViewController as! CalendarDetailViewController)
            detailViewController.setData(sender as! CalendarTableCell)
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let visibleCellIndex = calendarTableView.indexPathsForVisibleRows![0].row
        if let topDate = calendar?[visibleCellIndex]["startTime"] as? NSDate {
            self.currentDate = topDate
        }
    }
    
    
    /**
        Determines the number of cells in the table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - section: The current section of the table view.
     
        - Returns: The number of calendar events.
     */
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendar?.count ?? 0
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
            let cell: CalendarTableCell =
                tableView.dequeueReusableCellWithIdentifier("CalendarTableCell",
                forIndexPath: indexPath) as! CalendarTableCell
            
            cell.title = calendarEntry["title"] as? String ?? "No Title"
            cell.location = calendarEntry["location"] as? String ?? "No Location Available"
            cell.summary = calendarEntry["description"] as? String ?? "No Description Available"
            
            if let time: NSDate = calendarEntry["startTime"] as? NSDate {
                cell.time = parseDate(time)
            } else {
                cell.time = "No Time Available"
            }
            
            return cell
        } else {
            let cell: CalendarTableCell =
                tableView.dequeueReusableCellWithIdentifier("CalendarTableCell",
                forIndexPath: indexPath) as! CalendarTableCell
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
