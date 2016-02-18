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
	var hasImage: Bool = false
	var descText: String = "Good job!"
	var image: UIImage!
	
	@IBOutlet weak var modalView: UIView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var descTextView: UITextView!
	@IBOutlet weak var closeButton: UIButton!
	@IBOutlet weak var imageViewHeightConst: NSLayoutConstraint!
	
    override func viewDidLoad() {
		self.descTextView.text = descText
		// change constraints to make sure description occupies the rest of the space
		if (!hasImage) {
			self.imageView.hidden = true
			imageViewHeightConst.constant = -imageView.superview!.frame.height * imageViewHeightConst.multiplier
		} else {
			self.imageView.hidden = false
			self.imageView.image = image
		}
    }

	/**
	 * Close modal and transition back to the quest playing view
	 **/
	@IBAction func dismissModal(sender: AnyObject) {
		parentView.dismissViewControllerAnimated(true) {}
	}
}
