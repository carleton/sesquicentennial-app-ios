//
//  StoriesViewController.swift
//  Carleton150

import Foundation

class StoriesViewController: UIViewController {
    
    @IBOutlet weak var storiesView: UIWebView!
    
    override func viewDidLoad() {
        Utils.setUpNavigationBar(self)
        self.loadInfo()
        let button = UIButton()
        button.setTitle("Home", forState: .Normal)
        navigationItem.rightBarButtonItem =
            UIBarButtonItem(title: "Home",
                            style: .Plain,
                            target: self,
                            action: #selector(self.loadInfo)
        )
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(title: "Back",
                            style: .Plain,
                            target: self,
                            action: #selector(self.leaveStories)
        )
    }
   
    func loadInfo() {
        let url = NSURL(string: "https://go.carleton.edu/appstories")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("CarletonSesquicentennialApp 1.0", forHTTPHeaderField: "UserAgent")
        storiesView.loadRequest(request)
    }
    
    func leaveStories() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
