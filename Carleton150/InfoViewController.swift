//
//  InfoViewController.swift
//  Carleton150

import Reachability



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
    
    @objc func setReload() {
        shouldReload = true
    }
   
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        guard let url = request.url, navigationType == .linkClicked else { return true }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        return false
    }


    func loadInfo() {
        UserDefaults.standard.register(defaults: ["UserAgent": "ReunionApp"])
        switch self.networkMonitor.connection {
            case .wifi:
                fallthrough
            case .cellular:
                let url = NSURL(string: "https://go.carleton.edu/apphome2")
                let request = NSMutableURLRequest(url: url! as URL)
                request.setValue(Utils.getUserAgent(), forHTTPHeaderField: "UserAgent")
                webView.loadRequest(request as URLRequest)
                break
            default:
                let url = Bundle.main.path(forResource: "no-connection", ofType: "html")
                let requesturl = NSURL(string: url!)
                let request = NSURLRequest(url: requesturl! as URL)
                webView.loadRequest(request as URLRequest)
        }
    }
}
