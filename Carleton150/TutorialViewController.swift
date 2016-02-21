//
//  TutorialViewController.swift
//  Carleton150

class TutorialViewController: UIViewController {
    
    var parent: HistoricalViewController!
   
    /**
        Dismisses the tutorial from view on tap. 
        
        - Parameters: 
            - sender: The X in the top right corner of the tutorial.
     */
    @IBAction func dismissTutorial(sender: AnyObject) {
        parent.dismissViewControllerAnimated(true, completion: nil)
    }
   
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
}
