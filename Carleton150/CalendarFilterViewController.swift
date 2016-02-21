//
//  CalendarFilterViewController.swift
//  Carleton150

class CalendarFilterViewController: UIViewController {
    
    var calendar: [Dictionary<String, AnyObject?>] = []
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func filterByDate(sender: AnyObject) {
       
        let userInfo: [NSObject : AnyObject]? = ["date" : datePicker.date]
        
        NSNotificationCenter
            .defaultCenter()
            .postNotificationName("carleton150.filterUpdate", object: nil, userInfo: userInfo)
    }
    
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
        self.datePicker.setValue(UIColor(red: 1, green: 1, blue: 1, alpha: 1.0), forKey: "textColor")
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

class ColoredDatePicker: UIDatePicker {
    var changed = false
    override func addSubview(view: UIView) {
        if !changed {
            changed = true
            self.setValue(UIColor(white: 1, alpha: 1), forKey: "textColor")
        }
        super.addSubview(view)
    }
}
