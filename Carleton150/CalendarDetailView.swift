//
//  CalendarDetailView.swift
//  Carleton150
//
//  Created by Chet Aldrich on 2/16/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import Foundation

class CalendarDetailView: UIViewController {

    var parentView: UIViewController!
    var date: String!
    var eventDescription: String!
    
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
        
        // stops the text view from being edited
        self.eventDescriptionText.editable = false
    }
    
    
    /**
        A convenience method for setting the data as a segue
        is initiated.
     */
    func setData(calendarCell: CalendarCell) {
        self.date = calendarCell.timeLabel.text
        self.eventDescription = calendarCell.eventDescription
    }
    
}