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
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        nameField.resignFirstResponder()
        titleField.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    
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
        parentView.dismissViewControllerAnimated(true, completion: nil)
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
        if text == "\n" {
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
        let memory: Memory = Memory(title: titleField.text!, desc: descriptionTextView.text!, timestamp: NSDate(), uploader: nameField.text!, location: self.parentView.mapCtrl.locationManager.location!.coordinate, image: self.image!)
        
        // start wait screen
        SwiftOverlays.showBlockingWaitOverlayWithText("Uploading your image...")
        
        HistoricalDataService.uploadMemory(memory) { success in
            // stop wait screen
            SwiftOverlays.removeAllBlockingOverlays()
            if success {
                self.alertUserOfUploadAttempt(memory, success: success)
            } else {
                self.alertUserOfUploadAttempt(memory, success: success)
            }
        }
    }
    
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