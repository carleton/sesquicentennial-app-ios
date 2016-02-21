//
//  TutorialViewController.swift
//  Carleton150

class TutorialViewController: UIViewController {
    
    var parent: HistoricalViewController!
   
    @IBAction func dismissTutorial(sender: AnyObject) {
        parent.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
}
