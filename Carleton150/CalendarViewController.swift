//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarTableView: UITableView!
    var calendar: [NSDate : [CalendarEvent]]? {
        didSet {
            if let calendar = calendar {
                // Not using map or $0, $1 notation since I'm not sure it's available in iOS 8.2
                self.dateSectionHeaders = Array(calendar.keys).sort { (date1, date2) -> Bool in
                    return date1.compare(date2) == NSComparisonResult.OrderedAscending
                }

                self.nestedCalendar = []
                for date in self.dateSectionHeaders! {
                    self.nestedCalendar?.append(calendar[date]!)
                }
            }
        }
    }

    var dateSectionHeaders: [NSDate]?
    var nestedCalendar: [[CalendarEvent]]?
    var timer: NSTimer!
    var shouldReload: Bool = false
    

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var leftArrowBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightArrowBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        // set and go to the current date
        self.goToDate(NSDate())
        
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
        
        // triggers page to reload every 30 minutes on page appearance
        timer = NSTimer.scheduledTimerWithTimeInterval(1800, target: self, selector: #selector(self.setReload), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if shouldReload {
            CalendarDataService.getEvents()
        }
    }
    
    
    @IBAction func goToToday(sender: UIBarButtonItem) {
        self.goToDate(NSDate.roundDownToNearestDay(NSDate()))
        self.testDate(NSDate.roundDownToNearestDay(NSDate()), message: "There are no events today. We will show you the events that are available instead. Scroll to see more!")
    }
    
    
    @IBAction func goToYesterday(sender: UIBarButtonItem) {
        let visibleRows: [NSIndexPath]? = calendarTableView.indexPathsForVisibleRows
        
        if let date = self.dateSectionHeaders?[(visibleRows?[0].section)!] {
            let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
                NSCalendarUnit.Day, value: -1, toDate: date, options: NSCalendarOptions(rawValue: 0))
            let roundedDate = NSDate.roundDownToNearestDay(newDate!)
            if (dateSectionHeaders?.contains(newDate!))! {
                self.goToDate(roundedDate)
            }
        }
    }
    
    
    @IBAction func goToTomorrow(sender: UIBarButtonItem) {
        let visibleRows: [NSIndexPath]? = calendarTableView.indexPathsForVisibleRows
        if let date = self.dateSectionHeaders?[(visibleRows?[0].section)!] {
            let newDate = NSCalendar.currentCalendar().dateByAddingUnit(
                NSCalendarUnit.Day, value: 1, toDate: date, options: NSCalendarOptions(rawValue: 0))
            let roundedDate = NSDate.roundDownToNearestDay(newDate!)
            if (self.dateSectionHeaders?.contains(newDate!))! {
                self.goToDate(roundedDate)
            }
        }
    }


    func setReload() {
       shouldReload = true
    }
    
    
    func testDate(date: NSDate, message: String?) {
        if !(dateSectionHeaders?.contains(date))! {
            var alertMessage = "There are no events on the chosen day. We will show you the earliest events available instead. Scroll to see more!"
            if let passedMessage = message {
                alertMessage = passedMessage
            }
            let alert = UIAlertController(title: "",
                message: alertMessage,
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.Default, handler: nil))
            calendarTableView.setContentOffset(CGPointZero, animated: false)
            self.leftArrowBarButtonItem.enabled = false
            self.rightArrowBarButtonItem.enabled = true
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
   
    /**
        Goes to the specified date in the calendar table view.
     
        - Parameters:
            - date: The date to go to (rounds down on time)
     */
    func goToDate(inputDate: NSDate?) {
        if let section = dateSectionHeaders?.indexOf(inputDate!) {
            calendarTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: section), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
            self.leftArrowBarButtonItem.enabled = (section != 0)
            self.rightArrowBarButtonItem.enabled = (section >= 0 && section + 1 < self.dateSectionHeaders?.count)
        }
    }

    func actOnCalendarUpdate(notification: NSNotification) {
        self.calendar = CalendarDataService.schedule
        calendarTableView.reloadData()
        self.view.sendSubviewToBack(noDataView)
        self.leftArrowBarButtonItem.enabled = false
        self.rightArrowBarButtonItem.enabled = true
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
    
    
    /**
        Returns the number of sections (different dates) in the table view.
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dateSectionHeaders?.count ?? 0
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.chosenDate((self.dateSectionHeaders?[section])!)
    }
    
    /**
        Determines the number of cells in the table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - section: The current section of the table view.
     
        - Returns: The number of calendar events.
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nestedCalendar?[section].count ?? 0
    }
    
    /**
        Adds data to each of the cells in the calendar table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - indexPath: The current cell index of the table view.
     
        - Returns: The modified table view cell.
     */
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let calendarEntry = nestedCalendar?[indexPath.section][indexPath.row] {
            let cell: CalendarTableCell =
                tableView.dequeueReusableCellWithIdentifier("CalendarTableCell",
                forIndexPath: indexPath) as! CalendarTableCell
            
            cell.title = calendarEntry.title
            cell.location = calendarEntry.location
            cell.summary = calendarEntry.description
            cell.time = parseDate(calendarEntry.startDate)
            cell.url = calendarEntry.url.URLString
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


