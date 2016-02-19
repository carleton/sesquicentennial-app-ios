//
//  MemoryUploadView.swift
//  Carleton150

import Alamofire
import SwiftyJSON
import SwiftOverlays

class MemoryUploadView: UIViewController,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UITextViewDelegate,
                        UITextFieldDelegate {
    
    var parentView: TimelineViewController!
    let imagePicker = UIImagePickerController()
    var image: UIImage?
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var imageSubmitted: UIImageView!
    
    
    /**
        If the keyboard is currently active, this allows 
        the user to press anywhere on the view that is not
        a text field to exit from the keyboard.
     */
    @IBAction func dismissKeyboard(sender: AnyObject) {
        nameField.resignFirstResponder()
        titleField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        // forces background to darken
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
        
        // hide checkmark that signifies whether an image has been added
        self.imageSubmitted.hidden = true
        
        // set delegates
        imagePicker.delegate = self
        nameField.delegate = self
        titleField.delegate = self
        descriptionTextView.delegate = self
        
        // set tags for keyboard
        nameField.tag = 0
        titleField.tag = 1
    }
   
    /**
        Dismiss the view if the X button in the corner is pressed.
     */
    @IBAction func dismissView(sender: AnyObject) {
        parentView.dismissViewControllerAnimated(true, completion: nil)
    }
  
    /**
        Handles transitions between the text fields when pressing return. 
        Starting with the name field, it goes on to the title field and then
        the description field.
        
        - Parameters: 
            - textField: the current active text field when 
                         return is pressed on the keyboard.
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let nextTag: NSInteger = textField.tag + 1
        
        if let nextResponder: UIResponder! = textField.superview!.viewWithTag(nextTag){
            nextResponder.becomeFirstResponder()
        } else {
            descriptionTextView.becomeFirstResponder()
        }
        return false
    }
 
    /**
        Handles closing the keyboard when pressing done on
        the description text view.
     */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    /**
        Launches the image picker over the current form view 
        when the "upload an image" button is pressed.
     
        - Parameters: 
            - sender: The "upload an image" button in this case.
     */
    @IBAction func selectImage(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
   
    /**
        Launches the camera, and lets the user take a photo to upload 
        to the memories server.
     */
    @IBAction func takePicture(sender: AnyObject) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.cameraCaptureMode = .Photo
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            issueNoCameraAlert()
        }
    }
   
    /**
        In the case that there is no camera, alerts the user.
     */
    func issueNoCameraAlert() {
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    /**
        Once an image is selected, this method handles giving back the image
        to be saved in the view so it can be uploaded.
     */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.image = chosenImage
        self.imageSubmitted.hidden = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
        In the event that the user cancels selection or doesn't take a picture, 
        dismiss the image picker view.
     */
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
   
    /**
        Upon pressing the "submit" button, attempt to upload the image, but
        validate the user input first.
     
        - Parameters:
            - sender: The "submit" button.
     */
    @IBAction func uploadMemory(sender: AnyObject) {
        if let title = titleField.text,
               desc = descriptionTextView.text,
               uploader = nameField.text,
               image = self.image {
                
            // start wait screen
            SwiftOverlays.showBlockingWaitOverlayWithText("Uploading your image...")
                
            var emptyFields: [String] = []
            
            if title == "" {
                emptyFields.append("Title")
            }
                
            if desc == "" {
                emptyFields.append("Description")
            }
                
            if uploader == "" {
                emptyFields.append("Name")
            }
                
            if emptyFields.count != 0 {
                issueValidationAlert(emptyFields)
                return
            }
                
            let location = self.parentView.mapCtrl.locationManager.location!.coordinate
            let memory: Memory = Memory(title: title, desc: desc, timestamp: NSDate(), uploader: uploader, location: location, image: image)
                
            
            HistoricalDataService.uploadMemory(memory) { success in
                // stop wait screen
                SwiftOverlays.removeAllBlockingOverlays()
                if success {
                    self.alertUserOfUploadAttempt(memory, success: success)
                } else {
                    self.alertUserOfUploadAttempt(memory, success: success)
                }
            }
        } else {
            // image is not there
            let alert = UIAlertController(title: "No image selected", message: "Select an image for your memory!", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) {
                (UIAlertAction) -> Void in
                // do nothing
            }
            alert.addAction(alertAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
   
    /**
        If one of the fields is empty, issue an alert detailing the fields
        that the user needs to fill out.
        
        - Parameters:
            - emptyFields: the names of the empty fields.
     */
    func issueValidationAlert(emptyFields: [String]) {
        let fields = emptyFields.joinWithSeparator(", ")
        let message = "The following fields are empty: \n \(fields)"
        let alert = UIAlertController(title: "Missing Fields", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) {
            (UIAlertAction) -> Void in
            // do nothing
        }
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    /**
        Alert the user on whether the memory was successfully uploaded.
        
        - Parameters: 
            - memory: The memory to be uploaded, just in case it needs
                      another attempt.
        
            - success: Whether the upload succeeded. Display different
                       messages depending on the result.
     */
    func alertUserOfUploadAttempt(memory: Memory, success: Bool) {
        if success {
            let alert = UIAlertController(title: "Upload Succeeded", message: "Thanks for sharing a memory!", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) {
                (UIAlertAction) -> Void in
                self.parentView.dismissViewControllerAnimated(true, completion: nil)
            }
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Upload Failed", message: "We seemed to have trouble uploading your memory. Try again?", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction1 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) {
                (UIAlertAction) -> Void in
                self.parentView.dismissViewControllerAnimated(true, completion: nil)
            }
            let alertAction2 = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default) {
                (UIAlertAction) -> Void in
                self.uploadMemory(memory)
            }
            alert.addAction(alertAction1)
            alert.addAction(alertAction2)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}