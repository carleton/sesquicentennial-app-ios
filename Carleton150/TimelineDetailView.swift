//
//  TimelineDetailView.swift
//  Carleton150

import Foundation

class TimelineDetailView: UIViewController {
    
    var parentView: UIViewController!
    
    override func viewDidLoad() {
        // forces background to be transparent
        self.view.backgroundColor = UIColor(white: 1, alpha: 0)
        
    }
    
    @IBAction func dismissDetailView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }
}
