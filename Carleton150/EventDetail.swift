//
//  EventDetail.swift
//  
//
//  Created by Sherry Gu on 1/20/16.
//
//

import Foundation
class EventDetail: UIViewController{
    
    
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Date: UILabel!
    
    @IBOutlet weak var information: UILabel!
    
    var eventName = String()
    var startDate = String()
    var info = String()
    override func viewWillAppear(animated: Bool) {
        
        Name.text = eventName
        Date.text = startDate
        information.text = info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}