//
//  MemoryUploadView.swift
//  Carleton150

class MemoryUploadView: UIViewController {
    
    var parentView: TimelineViewController!
    
    @IBAction func dismissView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }

    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
    }
}