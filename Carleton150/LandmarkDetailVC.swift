//
//  LandmarkDetailVC.swift
//  Carleton150

import Foundation

import UIKit

class LandmarkDetailVC: UIViewController{
    var nameText: String = "name"
    var descriptionText: String = "description"
    
    @IBOutlet var Button: UIView!
    @IBOutlet weak var landmarkName: UILabel!
    @IBOutlet weak var landmarkDescription: UILabel!
    

    
    func setTextFields() {
        self.landmarkDescription.text = nameText
        self.landmarkName.text = descriptionText
        
    }
    
    @IBAction func triggerMap(sender: AnyObject) {
        self.performSegueWithIdentifier("mapView", sender: nil)
    }
    override func viewDidLoad() {
        self.setTextFields()
    }
    
    }