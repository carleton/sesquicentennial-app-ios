//
//  TimelineImageDetailView.swift
//  Carleton150

class TimelineImageDetailView: TimelineDetailView {
  
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    
    /**
        Loads the view, darkens the background, and then sets the 
        data inside the view.
     */
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
       
        // sets the current date and description
        self.dateLabel.text = self.timestamp ?? ""
        self.descriptionText.text = self.eventDescription
        self.detailImage.image = self.image
        
        // stops the text view from being edited
        self.descriptionText.isEditable = false
    }
   
    /**
        Once the subviews are placed, the description text
        needs to be set so that the text doesn't start at the bottom.
     */
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.descriptionText.setContentOffset(CGPoint(x:0,y:0), animated: false)
    }
    
    
    /**
        When the X is pressed on the detail view, the 
        view is dismissed.
     */
    @IBAction func dismissDetailView(_ sender: AnyObject) {
        parentView.dismiss(animated: true) {}
    }
}
