//
//  CalendarFilterViewController.swift
//  Carleton150

class CalendarFilterViewController: UIViewController {
    
    var calendarViewController: CalendarViewController!
    
    var calendar: [Dictionary<String, AnyObject?>] = [] {
        didSet {
            NSNotificationCenter
                .defaultCenter()
                .postNotificationName("carleton150.filterCalendarUpdate", object: self)
        }
    }
    
    @IBOutlet weak var currentDay: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
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
       
        // set the text color
        self.datePicker.minimumDate = NSDate()
        self.datePicker.setValue(UIColor(red: 1, green: 1, blue: 1, alpha: 1.0), forKey: "textColor")
        
        self.datePicker.datePickerMode = UIDatePickerMode.Date
        // add target for the trigger update function to change the weekday date is changed
        self.datePicker.addTarget(self, action: Selector("triggerDayUpdate:"), forControlEvents: UIControlEvents.ValueChanged)
        self.currentDay.text = self.datePicker.date.weekday
    }
   
    /**
        If the date picker has been updated, update the weekday accordingly.
     */
    @IBAction func triggerDayUpdate(sender: AnyObject) {
        self.currentDay.text = self.datePicker.date.weekday
    }
    
    /**
        Once the button is pressed, grab the date in the date picker
        at the moment and then send a notification to the calendar view.
     
        - Parameters: 
            - sender: The checkmark that triggers a calendar date change.
     */
    @IBAction func filterByDate(sender: AnyObject) {
        
        // depending on the current state of the calendar data, change the button text
        if self.calendarViewController.calendar.count == 0 {
            self.calendarViewController.noDataButton.setTitle("Seems like we didn't get data for some reason. Try again?", forState: UIControlState.Normal)
        } else {
            self.calendarViewController.noDataButton.setTitle("Seems like there isn't data for this date. Go back?", forState: UIControlState.Normal)
        }
        
        let userInfo: [NSObject : AnyObject]? = ["date" : datePicker.date]
        
        NSNotificationCenter
            .defaultCenter()
            .postNotificationName("carleton150.filterUpdate", object: nil, userInfo: userInfo)
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
    
   
    /**
        Provides information about the parent view to the calendar view so that 
        it can get calendar data.
     */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToContainer") {
            let containerViewController = (segue.destinationViewController as! CalendarViewController)
            containerViewController.parentView = self
            self.calendarViewController = containerViewController
        }
    }
}

class ColoredDatePicker: UIDatePicker {
    
    var changed = false
    
    /**
        Overrides the default addSubview functionality to provide
        white text, since it is not currently customizable in the 
        Interface Builder.
     */
    override func addSubview(view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor(white: 1, alpha: 1), forKey: "textColor")
        }
        super.addSubview(view)
    }
}

extension NSDate {
    // returns weekday name (Sunday-Saturday) as String
    var weekday: String {
        let formatter = NSDateFormatter(); formatter.dateFormat = "EEEE"
        return formatter.stringFromDate(self)
    }
}
