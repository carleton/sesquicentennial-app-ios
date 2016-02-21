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
        print("here")
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: "actOnCalendarUpdate:", name: "carleton150.calendarUpdate", object: nil)
    }
    
    /**
        Upon noticing that the calendar has been updated, set
        the calendar data in the class
     
        - Parameters:
            - notification: The notification triggered from the CalendarDataService.
     */
    func actOnCalendarUpdate(notification: NSNotification) {
        print("checking data")
        if let calendar = CalendarDataService.schedule {
            print("got the data")
            self.calendar = calendar
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToContainer") {
            print("Doing the container segue")
            let containerViewController = (segue.destinationViewController as! CalendarViewController)
            containerViewController.parentView = self
        }
    }
    
    
}