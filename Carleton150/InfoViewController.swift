//
//  InfoViewController.swift
//  Carleton150

import Foundation

class InfoViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        Utils.setUpNavigationBar(self)
        self.loadInfo()
        let button = UIButton()
        button.setTitle("Home", forState: .Normal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Home",
                                                           style: .Plain,
                                                           target: self,
                                                           action: #selector(self.loadInfo)
        )
    }
   
    func loadInfo() {
        let url = NSURL(string: "https://go.carleton.edu/appinfo")
        let request = NSMutableURLRequest(URL: url!)
        request.setValue("CarletonSesquicentennialApp 1.0", forHTTPHeaderField: "UserAgent")
        webView.loadRequest(request)
    }
}