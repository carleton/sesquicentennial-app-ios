//
//  QuestModalViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 2/17/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class QuestModalViewController: UIViewController {
	
	var parentView: UIViewController!
	var titleText: String!
	var isCorrect: Bool!
	var isComplete: Bool!
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
		
		if (descText == nil) {
			if (isCorrect!) {
				if (isComplete!) {
					descText = "Congratulations on finishing the quest!"
				} else {
					descText = "You figured it out! Let's see if you can get this next one"
				}
			} else {
				descText = "Not quite there yet. Keep trying and don't forget to check the hint!"
			}
		}
		
		if (titleText == nil) {
			if (isCorrect!) {
				if (isComplete!) {
					titleText = "Quest Completed!"
				} else {
					titleText = "Correct!"
				}
			} else {
				titleText = "Incorrect!"
			}
		}
		
		if (image == nil) {
			if (isCorrect!) {
				if (isComplete!) {
					image = UIImage(named: "quest_modal_complete_default")
				} else {
					image = UIImage(named: "quest_modal_correct_default")
				}
			} else {
				image = UIImage(named: "quest_modal_incorrect_default")
			}
		}
		
		descTextView.text = descText
		titleLabel.text = titleText
		imageView.image = image
		
    }

	/**
	 * Close modal and transition back to the quest playing view
	 **/
	@IBAction func dismissModal(sender: AnyObject) {
		parentView.dismissViewControllerAnimated(true) {}
	}
}
