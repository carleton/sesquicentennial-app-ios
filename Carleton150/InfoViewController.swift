//
//  InfoViewController.swift
//  Carleton150

import Reachability

class InfoViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
	var reach: Reachability?
	var networkMonitor: Reachability!
    var timer: NSTimer!
    var shouldReload: Bool = false
    
    @IBAction func reload(sender: AnyObject) {
        loadInfo()
    }
    
    override func viewDidLoad() {
        // set up network monitoring
		let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
		self.networkMonitor = appDelegate.networkMonitor
        
        webView.delegate = self
        
        Utils.setUpNavigationBar(self)
        self.loadInfo()
   
        // triggers page to reload every 5 minutes
        timer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: #selector(InfoViewController.setReload), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        if shouldReload {
            loadInfo()
        }
    }
    
    func setReload() {
        shouldReload = true
    }
   
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
    }

    func loadInfo() {
        if self.networkMonitor!.isReachableViaWiFi() || self.networkMonitor!.isReachableViaWWAN() {
            let url = NSURL(string: "https://go.carleton.edu/apphome")
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
