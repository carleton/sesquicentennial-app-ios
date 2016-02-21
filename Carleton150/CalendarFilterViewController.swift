//
//  CalendarFilterViewController.swift
//  Carleton150

class CalendarFilterViewController: UIViewController {
    
    var calendar: [Dictionary<String, String>] = []
    
    /**
        Initializes this view and sets up the 
        observer for the calendar data.
     */
    required init?(coder decoder : NSCoder) {
        super.init(coder: decoder)
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: "actOnCalendarUpdate:", name: "carleton150.calendarUpdate", object: nil)
    }
    
    override func viewDidLoad() {
        // set up the navigation bar
        Utils.setUpNavigationBar(self)
    }
    
    /**
        Upon noticing that the calendar has been updated, set
        the calendar data in the class
     
        - Parameters:
            - notification: The notification triggered from the CalendarDataService.
     */
    func actOnCalendarUpdate(notification: NSNotification) {
        if let calendar = CalendarDataService.schedule {
            self.calendar = calendar
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToContainer") {
            let containerViewController = (segue.destinationViewController as! CalendarViewController)
            containerViewController.parentView = self
        }
    }
    
    
}