//
//  InfoViewController.swift
//  Carleton150

import Reachability

class InfoViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
	var reach: Reachability?
	var networkMonitor: Reachability!
    
    override func viewDidLoad() {
        // set up network monitoring
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		self.networkMonitor = appDelegate.networkMonitor
        
        Utils.setUpNavigationBar(self)
        self.loadInfo()
    }
   
    @IBAction func reloadHomePage(sender: UIBarButtonItem) {
       self.loadInfo()
    }
    
    func loadInfo() {
        if self.networkMonitor!.isReachableViaWiFi() || self.networkMonitor!.isReachableViaWWAN() {
            let url = NSURL(string: "https://go.carleton.edu/appinfo")
            let request = NSMutableURLRequest(URL: url!)
            request.setValue("CarletonSesquicentennialApp 1.0", forHTTPHeaderField: "UserAgent")
            webView.loadRequest(request)
        } else {
            let url = NSBundle.mainBundle().pathForResource("no-connection", ofType: "html")
            let requesturl = NSURL(string: url!)
            let request = NSURLRequest(URL: requesturl!)
            webView.loadRequest(request)
        }
    }
}