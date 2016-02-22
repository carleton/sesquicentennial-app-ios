//
//  QuestModalViewController.swift
//  Carleton150

import UIKit

class QuestModalViewController: UIViewController {
	
	var parentVC: QuestPlayingViewController!
	var titleText: String!
	var isCorrect: Bool = false
	var isComplete: Bool = false
	var descText: String!
	var image: UIImage!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var descTextView: UITextView!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var imageViewHeightConst: NSLayoutConstraint!
	
    override func viewDidLoad() {
		
		// forces background to darken
		self.view.backgroundColor = UIColor(white: 0, alpha: 0.6)
		
		// set up the main body of text
		if (descText == nil) {
			if (isCorrect) {
				if (isComplete) {
					descText = "Congratulations on finishing the quest!"
				} else {
					descText = "You figured it out! Let's see if you can get this next one"
				}
			} else {
				descText = "Not quite there yet. Keep trying and don't forget to check the hint!"
			}
		}
		
		// set up title for modal
		if (titleText == nil) {
			if (isCorrect) {
				if (isComplete) {
					titleText = "Quest Completed!"
				} else {
					titleText = "Correct!"
				}
			} else {
				titleText = "Incorrect!"
			}
		}
		
		// set up image for modal
		if (image == nil) {
			if (isCorrect) {
				if (isComplete) {
                    imageView.animationImages = [
                        UIImage(named: "s1")!,
                        UIImage(named: "s2")!,
                        UIImage(named: "s3")!,
                        UIImage(named: "s4")!,
                        UIImage(named: "s5")!,
                        UIImage(named: "s6")!,
                        UIImage(named: "s7")!,
                        UIImage(named: "s8")!,
                        UIImage(named: "s9")!,
                        UIImage(named: "s10")!
                    ]
                    imageView.animationDuration = 10
                    imageView.startAnimating()
				} else {
                    imageView.animationImages = [
                        UIImage(named: "found1")!,
                        UIImage(named: "found2")!,
                        UIImage(named: "found3")!
                    ]
                    
                    imageView.animationDuration = 3
                    imageView.startAnimating()
				}
			} else {
                imageView.animationImages = [
                    UIImage(named: "t1")!,
                    UIImage(named: "t2")!
                ]
                
                imageView.animationDuration = 2
                imageView.startAnimating()
			}
        } else {
            imageView.image = image
        }
		
		// set properies to view outlets
		descTextView.text = descText
		titleLabel.text = titleText
    }

	/**
		Upon clicking okay or X returns to the previous view
		
		- Parameters:
			- sender: The UI element that triggered the action.
	*/
	@IBAction func dismissModal(sender: AnyObject) {
		parentVC.setupUI()
		parentVC.dismissViewControllerAnimated(true) {}
	}
}
