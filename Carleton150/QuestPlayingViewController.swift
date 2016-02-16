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
	
	@IBOutlet weak var questMapView: UIView!
	@IBOutlet weak var clueHintView: UIView!
	
	@IBOutlet weak var questName: UILabel!
	@IBOutlet weak var clueHintImg: UIImageView!
	@IBOutlet weak var clueHintTxt: UITextView!
	@IBOutlet weak var toggleHintClue: UIButton!
	
	@IBAction func CompButton(sender: AnyObject) {
		print("MEOW")
		self.clueHintImg.hidden = !self.clueHintImg.hidden
		if (self.clueHintImg.hidden) {
			
		}
	}
	
	@IBAction func switchHintClue(sender: AnyObject) {
		self.questName.text = "SOMETHING REALLY REALLY REALLY REALLY REALLY REALLY REALLY REALLY FUCKING LONG"
	}
	
	func setHintClueUI() {
		self.questName.text = quest.name
	}
	
    override func viewDidLoad() {
		setHintClueUI()
    }

	
	
}
