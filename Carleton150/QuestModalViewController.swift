//
//  QuestModalViewController.swift
//  Carleton150
//

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
					image = UIImage(named: "quest_modal_complete_default")
				} else {
					image = UIImage(named: "quest_modal_correct_default")
				}
			} else {
				image = UIImage(named: "quest_modal_incorrect_default")
			}
		}
		
		// set properies to view outlets
		descTextView.text = descText
		titleLabel.text = titleText
		imageView.image = image
		
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
