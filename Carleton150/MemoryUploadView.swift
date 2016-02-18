//
//  MemoryUploadView.swift
//  Carleton150

class MemoryUploadView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var parentView: TimelineViewController!
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        imagePicker.delegate = self
        descriptionTextView.delegate = self
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    @IBAction func selectImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadMemory(sender: AnyObject) {
        
    }
}