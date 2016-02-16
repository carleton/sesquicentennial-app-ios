//
//  QuestPlayingViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 2/15/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit




class QuestPlayingViewController: UIViewController {

	
	var quest: Quest!
	var currentWayPointIndex: Int = 0 // @todo: Load this up from Core Data 
	
	var clueHintImg: UIImageView!
	var clueHintTxt: UITextView!

	@IBOutlet weak var questMapView: UIView!
	@IBOutlet weak var clueHintView: UIView!
	
	@IBOutlet weak var questName: UILabel!
	@IBOutlet weak var toggleHintClue: UIButton!
	@IBOutlet weak var clueHintImageTextConst: NSLayoutConstraint!
	@IBOutlet weak var clueHintImageLeadConst: NSLayoutConstraint!
	
	//	@IBOutlet weak var clueHintImg: UIImageView!
	//	@IBOutlet weak var clueHintTxt: UITextView!
	
	@IBAction func CompButton(sender: AnyObject) {

//		print("MEOW")
//		self.clueHintImg.hidden = !self.clueHintImg.hidden
//		if (self.clueHintImg.hidden) {
//			self.clueHintImg.removeFromSuperview()
//			clueHintImageTextConst = NSLayoutConstraint(item: clueHintTxt, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: clueHintImg, attribute: NSLayoutAttribute.Width, multiplier: 0.80, constant: 0)
//			clueHintImageLeadConst = NSLayoutConstraint(item: clueHintTxt, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem:clueHintView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant:8.0)
//		
////		} else {
////			clueHintImageTextConst = true
//		}
	}
	
	@IBAction func switchHintClue(sender: AnyObject) {
		self.questName.text = "SOMETHING REALLY REALLY REALLY REALLY REALLY REALLY REALLY REALLY FUCKING LONG"
	}
	
	func addClueHintText() {
		clueHintTxt = UITextView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) // nonsense values
		clueHintTxt.text = quest.description
		var constArray = [NSLayoutConstraint()]
		// leading edge
		constArray.append(NSLayoutConstraint(item: clueHintTxt, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: clueHintView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 8))
		// trailing edge
		constArray.append(NSLayoutConstraint(item: clueHintTxt, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: clueHintView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 8))
		// top 
		constArray.append(NSLayoutConstraint(item: clueHintTxt, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: questName, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8))
		// bottom
		constArray.append(NSLayoutConstraint(item: clueHintTxt, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: compl, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 8))
	}
	
	func setHintClueUI() {
		self.questName.text = quest.name
	}
	
    override func viewDidLoad() {
		setHintClueUI()
    }

	
	
}
