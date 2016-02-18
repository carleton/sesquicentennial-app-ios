//
//  MemoryUploadView.swift
//  Carleton150

class MemoryUploadView: UIViewController,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UITextViewDelegate,
                        UITextFieldDelegate {
    
    var parentView: TimelineViewController!
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        nameField.resignFirstResponder()
        titleField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        // set delegates
        imagePicker.delegate = self
        nameField.delegate = self
        titleField.delegate = self
        descriptionTextView.delegate = self
        
        // set tags for keyboard
        nameField.tag = 0
        titleField.tag = 1
    }
    
    @IBAction func dismissView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true) {}
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1
        
        if let nextResponder: UIResponder! = textField.superview!.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            descriptionTextView.becomeFirstResponder()
        }
        return false
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