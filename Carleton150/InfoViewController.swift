//
//  InfoViewController.swift
//  Carleton150

import ReachabilitySwift

class InfoViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
	var reach: Reachability?
	var networkMonitor: Reachability!
    var timer: Timer!
    var shouldReload: Bool = false
    
    @IBAction func reload(_ sender: AnyObject) {
        loadInfo()
    }
    
    override func viewDidLoad() {
        // set up network monitoring
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		self.networkMonitor = appDelegate.networkMonitor
        
        webView.delegate = self
        
        Utils.setUpNavigationBar(self)
        self.loadInfo()
   
        // triggers page to reload every 5 minutes
        timer = Timer.scheduledTimer(timeInterval: 300, target: self, selector: #selector(InfoViewController.setReload), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if shouldReload {
            loadInfo()
        }
    }
    
    func setReload() {
        shouldReload = true
    }
   
    private func webView(_ webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        return true
    }

    func loadInfo() {
        if self.networkMonitor!.isReachableViaWiFi || self.networkMonitor!.isReachableViaWWAN {
            let url = NSURL(string: "https://go.carleton.edu/apphome")
            let request = NSMutableURLRequest(url: url! as URL)
            request.setValue("CarletonSesquicentennialApp 1.0", forHTTPHeaderField: "UserAgent")
            webView.loadRequest(request as URLRequest)
        } else {
            let url = Bundle.main.path(forResource: "no-connection", ofType: "html")
            let requesturl = NSURL(string: url!)
            let request = NSURLRequest(url: requesturl! as URL)
            webView.loadRequest(request as URLRequest)
        }
    }
}
