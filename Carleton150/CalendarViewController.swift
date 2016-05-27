//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarTableView: UITableView!
    @IBOutlet weak var currentDateLabel: UILabel!
    var calendar: [NSDate : [CalendarEvent]]? {
        didSet {
            let eventsList: [CalendarEvent] = (calendar?.flatMap() {$0.1})!
            self.sortedFlatCalendar = eventsList.sort() { $0.startDate.isLessThanDate($1.startDate) }
        }
    }
    
    var sortedFlatCalendar: [CalendarEvent]!
    
    var currentDate: NSDate? {
        didSet {
            if let date = currentDate {
                currentDateLabel.text = chosenDate(date)
            }
        }
    }

    @IBOutlet weak var noDataView: UIView!
    
    override func viewDidLoad() {
        // set and go to the current date
        self.goToDate(NSDate())
        self.currentDate = NSDate()
        
        // set the dataSource and delegate for the calendar table view
		calendarTableView.dataSource = self
		calendarTableView.delegate = self
       
        // set the observer and pull events
        NSNotificationCenter.defaultCenter().addObserver(self,
             selector: #selector(self.actOnCalendarUpdate(_:)),
             name: "carleton150.calendarUpdate", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
             selector: #selector(self.actOnCalendarUpdateFailure(_:)),
             name: "carleton150.calendarUpdateFailure", object: nil)
        CalendarDataService.getEvents()
    }
    
    
    @IBAction func goToToday(sender: UIBarButtonItem) {
        self.goToDate(NSDate.roundDownToNearestDay(NSDate()))
        self.currentDate = NSDate()
        self.testDate(NSDate.roundDownToNearestDay(NSDate()), message: "Looks like there aren't any events today. We will show you the events that are available instead. Feel free to scroll to see more!")
    }
    
    
    @IBAction func goToYesterday(sender: UIBarButtonItem) {
        if let date = self.currentDate {
            let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
                NSCalendarUnit.Day, value: -1, toDate: date, options: NSCalendarOptions(rawValue: 0))
            self.currentDate = newDate
            let roundedDate = NSDate.roundDownToNearestDay(newDate!)
            self.goToDate(roundedDate)
            self.testDate(roundedDate, message: nil)
        }
    }
    
    
    @IBAction func goToTomorrow(sender: UIBarButtonItem) {
        if let date = self.currentDate {
            let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
                NSCalendarUnit.Day, value: 1, toDate: date, options: NSCalendarOptions(rawValue: 0))
            self.currentDate = newDate
            let roundedDate = NSDate.roundDownToNearestDay(newDate!)
            self.goToDate(roundedDate)
            self.testDate(roundedDate, message: nil)
        }
    }
    
    func testDate(date: NSDate, message: String?) {
        let nextDay = NSCalendar.currentCalendar().dateByAddingUnit(
            NSCalendarUnit.Day, value: 1, toDate: date, options: NSCalendarOptions(rawValue: 0))
        if let events = sortedFlatCalendar {
            let firstEventDate = events[0].startDate
            let lastEventDate = events[events.count - 1].startDate
            if firstEventDate.isGreaterThanDate(nextDay!) ||
               lastEventDate.isLessThanDate(date) {
                var alertMessage = "Looks like there aren't any events on the chosen day. We will show you the events that are available instead. Feel free to scroll to see more!"
                if let passedMessage = message {
                    alertMessage = passedMessage
                }
                let alert = UIAlertController(title: "",
                    message: alertMessage,
                    preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil))
                calendarTableView.setContentOffset(CGPointZero, animated: false)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
    }
   
    /**
        Goes to the specified date in the calendar table view.
     
        - Parameters:
            - date: The date to go to (rounds down on time)
     */
    func goToDate(inputDate: NSDate?) {
        if let calendarLength = sortedFlatCalendar?.count, date = inputDate {
            for i in 0 ..< calendarLength {
                if let eventDate: NSDate = sortedFlatCalendar?[i].startDate {
                    if eventDate.isGreaterThanDate(date) {
                        calendarTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                        break
                    }
                }
            }
        }
    }
    
    
    func actOnCalendarUpdate(notification: NSNotification) {
        self.calendar = CalendarDataService.schedule
        calendarTableView.reloadData()
        self.view.sendSubviewToBack(noDataView)
    }
    
    func actOnCalendarUpdateFailure(notification: NSNotification) {
        self.view.bringSubviewToFront(noDataView)
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
        if let topDate = sortedFlatCalendar?[visibleCellIndex].startDate {
            self.currentDate = topDate
        }
    }
    
    /**
        Returns the number of sections (different dates) in the table view.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.calendar?.count ?? 0
    }
    
    /**
        Determines the number of cells in the table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - section: The current section of the table view.
     
        - Returns: The number of calendar events.
     */
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortedFlatCalendar?.count ?? 0
	}
    
    
    /**
        Adds data to each of the cells in the calendar table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - indexPath: The current cell index of the table view.
     
        - Returns: The modified table view cell.
     */
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let calendarEntry = sortedFlatCalendar?[indexPath.row] {
            let cell: CalendarTableCell =
                tableView.dequeueReusableCellWithIdentifier("CalendarTableCell",
                forIndexPath: indexPath) as! CalendarTableCell
            
            cell.title = calendarEntry.title ?? "No title"
            cell.location = calendarEntry.location ?? "No location"
            cell.summary = calendarEntry.description ?? "No description"
            if let startTime = calendarEntry.startDate {
                cell.time = parseDate(startTime)
            } else {
                cell.time = "No time available"
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


