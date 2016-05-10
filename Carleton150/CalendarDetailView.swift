//
//  CalendarDetailView.swift
//  Carleton150

import Foundation

class CalendarDetailView: UIViewController {

    var parentView: UIViewController!
    var date: String!
    var eventDescription: String!
    var eventLocation: String!
    var eventTitle: String!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBAction func dismissDetailView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }
    
    /**
        Loads the view, darkens the background, and then sets the 
        data inside the view.
     */
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
       
        // sets the current date and description
        self.dateLabel.text = self.date
        self.eventDescriptionText.text = self.eventDescription
        self.eventTitleLabel.text = self.eventTitle
        self.locationLabel.text = self.eventLocation
        
        // stops the text view from being edited
        self.eventDescriptionText.editable = false
    }
    
    /**
        Once the subviews are placed, the description text
        needs to be set so that the text doesn't start at the bottom.
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.eventDescriptionText.setContentOffset(CGPointZero, animated: false)
    }
    
    /**
        A convenience method for setting the data as a segue
        is initiated.
     */
//    func setData(calendarCell: CalendarCell) {
//        self.date = calendarCell.timeLabel.text
//        self.eventDescription = calendarCell.eventDescription
//        self.eventTitle = calendarCell.eventTitle.text
//        self.eventLocation = calendarCell.locationLabel.text
//    }
}