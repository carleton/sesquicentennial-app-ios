//
//  TutorialViewController.swift
//  Carleton150

class TutorialViewController: UIViewController {
    
    /**
        Dismisses the tutorial from view on tap. 
     */
    @IBAction func exit() {
        self.dismiss(animated: true, completion: nil)
    }
   
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
    }
}
