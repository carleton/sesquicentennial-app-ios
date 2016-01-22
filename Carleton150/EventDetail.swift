//
//  EventDetail.swift
//  Carleton150

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
        showLogo()
    }
    
    func showLogo() {
        let logo = UIImage(named: "carleton_logo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
}