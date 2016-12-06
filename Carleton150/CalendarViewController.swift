//
//  CalendarViewController.swift
//  Carleton150

import Foundation

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarTableView: UITableView!
    var calendar: [Date : [CalendarEvent]]? {
        didSet {
            if let calendar = calendar {
                // Not using map or $0, $1 notation since I'm not sure it's available in iOS 8.2
                self.dateSectionHeaders = Array(calendar.keys).sorted { (date1, date2) -> Bool in
                    return date1.compare(date2) == ComparisonResult.orderedAscending
                }

                self.nestedCalendar = []
                for date in self.dateSectionHeaders! {
                    self.nestedCalendar?.append(calendar[date]!)
                }
            }
        }
    }

    var dateSectionHeaders: [Date]?
    var nestedCalendar: [[CalendarEvent]]?
    var timer: Timer!
    var shouldReload: Bool = false
    

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var leftArrowBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightArrowBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        // set and go to the current date
        self.goToDate(Date())
        
        // set the dataSource and delegate for the calendar table view
		calendarTableView.dataSource = self
		calendarTableView.delegate = self
       
        // set the observer and pull events
        NotificationCenter.default.addObserver(self,
             selector: #selector(self.actOnCalendarUpdate(_:)),
             name: NSNotification.Name(rawValue: "carleton150.calendarUpdate"), object: nil)
        NotificationCenter.default.addObserver(self,
             selector: #selector(self.actOnCalendarUpdateFailure(_:)),
             name: NSNotification.Name(rawValue: "carleton150.calendarUpdateFailure"), object: nil)
        CalendarDataService.getEvents()
        
        // triggers page to reload every 30 minutes on page appearance
        timer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(self.setReload), userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if shouldReload {
            CalendarDataService.getEvents()
        }
    }
    
    
    @IBAction func goToToday(_ sender: UIBarButtonItem) {
        self.goToDate(NSDate.roundDownToNearestDay(Date()))
        self.testDate(NSDate.roundDownToNearestDay(Date()), message: "There are no events today. We will show you the events that are available instead. Scroll to see more!")
    }
    
    
    @IBAction func goToYesterday(_ sender: UIBarButtonItem) {
        let visibleRows: [IndexPath]? = calendarTableView.indexPathsForVisibleRows
        
        if let date = self.dateSectionHeaders?[(visibleRows?[0].section)!] {
            let newDate = (Calendar.current as NSCalendar).date(
                byAdding: NSCalendar.Unit.day, value: -1, to: date, options: NSCalendar.Options(rawValue: 0))
            let roundedDate = NSDate.roundDownToNearestDay(newDate!)
            if (dateSectionHeaders?.contains(newDate!))! {
                self.goToDate(roundedDate)
            }
        }
    }
    
    
    @IBAction func goToTomorrow(_ sender: UIBarButtonItem) {
        let visibleRows: [IndexPath]? = calendarTableView.indexPathsForVisibleRows
        if let date = self.dateSectionHeaders?[(visibleRows?[0].section)!] {
            let newDate = (Calendar.current as NSCalendar).date(
                byAdding: NSCalendar.Unit.day, value: 1, to: date, options: NSCalendar.Options(rawValue: 0))
            let roundedDate = NSDate.roundDownToNearestDay(newDate!)
            if (self.dateSectionHeaders?.contains(newDate!))! {
                self.goToDate(roundedDate)
            }
        }
    }


    func setReload() {
       shouldReload = true
    }
    
    
    func testDate(_ date: Date, message: String?) {
        if !(dateSectionHeaders?.contains(date))! {
            var alertMessage = "There are no events on the chosen day. We will show you the earliest events available instead. Scroll to see more!"
            if let passedMessage = message {
                alertMessage = passedMessage
            }
            let alert = UIAlertController(title: "",
                message: alertMessage,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler: nil))
            calendarTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
            self.leftArrowBarButtonItem.isEnabled = false
            self.rightArrowBarButtonItem.isEnabled = true
            self.present(alert, animated: true, completion: nil)
        }
    }
   
    /**
        Goes to the specified date in the calendar table view.
     
        - Parameters:
            - date: The date to go to (rounds down on time)
     */
    func goToDate(_ inputDate: Date?) {
        if let section = dateSectionHeaders?.index(of: inputDate!) {
            calendarTableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: false)
            self.leftArrowBarButtonItem.isEnabled = (section != 0)
            self.rightArrowBarButtonItem.isEnabled = (section >= 0 && section + 1 < (self.dateSectionHeaders?.count)!)
        }
    }

    func actOnCalendarUpdate(_ notification: Notification) {
        self.calendar = CalendarDataService.schedule as [Date : [CalendarEvent]]?
        calendarTableView.reloadData()
        self.view.sendSubview(toBack: noDataView)
        self.leftArrowBarButtonItem.isEnabled = false
        self.rightArrowBarButtonItem.isEnabled = true
    }

    func actOnCalendarUpdateFailure(_ notification: Notification) {
        self.view.bringSubview(toFront: noDataView)
    }

    /**
         Prepares for segues from the calendar to its detail modals by passing
         the data required for the modal along to the modal instance.
         
         - Parameters:
             - segue: The triggered segue.
             
             - sender: The collecton view cell that triggered the segue.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showCalendarDetail") {
            let detailViewController = (segue.destination as! CalendarDetailViewController)
            detailViewController.setData(sender as! CalendarTableCell)
        }
    }
    
    
    /**
        Returns the number of sections (different dates) in the table view.
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dateSectionHeaders?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.chosenDate((self.dateSectionHeaders?[section])!)
    }
    
    /**
        Determines the number of cells in the table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - section: The current section of the table view.
     
        - Returns: The number of calendar events.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nestedCalendar?[section].count ?? 0
    }
    
    /**
        Adds data to each of the cells in the calendar table view.
     
        - Parameters:
            - tableView: The table view being used for the calendar.
     
            - indexPath: The current cell index of the table view.
     
        - Returns: The modified table view cell.
     */
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let calendarEntry = nestedCalendar?[indexPath.section][indexPath.row] {
            let cell: CalendarTableCell =
                tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell",
                                              for: indexPath as IndexPath) as! CalendarTableCell
            
            cell.title = calendarEntry.title
            cell.location = calendarEntry.location
            cell.summary = calendarEntry.description
            cell.time = parseDate(calendarEntry.startDate)
            cell.url = calendarEntry.url.absoluteString
            return cell
        } else {
            let cell: CalendarTableCell =
                tableView.dequeueReusableCell(withIdentifier: "CalendarTableCell",
                                              for: indexPath as IndexPath) as! CalendarTableCell
            return cell
        }
    }
    
    fileprivate func chosenDate(_ date: Date) -> String {
        let outFormatter = DateFormatter()
        outFormatter.dateStyle = DateFormatter.Style.medium
        outFormatter.timeStyle = DateFormatter.Style.none
        return outFormatter.string(from: date)
    }
    
    /**
         A convenience function to turn the NSDate objects returned
         from the data service into human readable strings for presentation.
         
         - Parameters:
            - date: A date to be turned into a nice stringified version of itself.
     */
    fileprivate func parseDate(_ date: Date) -> String {
        let outFormatter = DateFormatter()
        outFormatter.dateStyle = DateFormatter.Style.medium
        outFormatter.timeStyle = DateFormatter.Style.short
        return outFormatter.string(from: date)
    }
}


