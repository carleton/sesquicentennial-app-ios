//
//  QuestContentViewController.swift
//  Carleton150

import UIKit
import AlamofireImage
import Alamofire

class QuestContentViewController: UIViewController {

	var pageIndex: Int!
	var titleText: String!
	var difficultyRating : Int!
	var imageURL: String!
	var descText: String!
	var buttonText: String!
	var quest: Quest!
	
	@IBOutlet weak var difficultyLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descTextView: UITextView!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	
	/**
        Prepares for a segue to the detail view for a particular point of
        interest on the map.
	
        Parameters:
            - segue:  The segue that was triggered by user. If this is not the
                      segue to the landmarkDetail view, then don't perform the
                      segue.
	
            - sender: The sender, in our case, will be one of the Google Maps markers
                      that was pressed, which will in turn have data associated with
                      it that will given to the landmark detail view.
	*/
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "questStartSegue" {
			let nextCtrl = (segue.destination as! QuestPlayingViewController)
			nextCtrl.quest = self.quest
		}
	}

    override func viewDidLoad() {

		// Quest Name
		if let titleText = titleText {
			self.nameLabel.text = titleText
		} else {
			self.nameLabel.text = ""
		}
		// Quest Difficulty
		if let difficultyRating = difficultyRating {
			if difficultyRating == 0 {
				self.difficultyLabel.text = "Easy"
				self.difficultyLabel.textColor = UIColor(
                   red: 79/255,
                   green: 138/255,
                   blue: 16/255,
                   alpha: 1.0
				)
			} else if difficultyRating == 1 {
				self.difficultyLabel.text = "Medium"
				self.difficultyLabel.textColor = UIColor(
                    red: 159/255,
                    green: 96/255,
					blue: 0/255,
					alpha: 1.0
				)
			} else if difficultyRating == 2 {
				self.difficultyLabel.text = "Hard"
				self.difficultyLabel.textColor = UIColor(
					red: 216/255,
					green: 0/255,
					blue: 12/255,
					alpha: 1.0
				)
			}
		}
		// Quest Description
		if let descText = descText {
			self.descTextView.text = descText
		} else {
			self.descTextView.text = ""
		}
		self.descTextView.isEditable = false
		// Quest Image
		if let imageURL = self.imageURL {
            Alamofire.request(imageURL).responseImage { response in
                if let image = response.result.value {
                    self.imageView.image = image
                }
            }
		}
    }

    
	override func viewWillAppear(_ animated: Bool) {
		// Data Persistance
		if let startedQuests = UserDefaults.standard.object(forKey: "startedQuests") as! NSDictionary! {
			if let curQuestWaypoint = startedQuests[titleText] as! Int! {
				let percentageCompleted = Int((Float(curQuestWaypoint) / Float(quest.wayPoints.count))*100)
				if (percentageCompleted == 100) {
					self.startButton.setTitle("Quest Completed", for: UIControlState())
				} else {
					self.startButton.setTitle("Continue: \(percentageCompleted)% Completed", for: UIControlState())
				}
				self.startButton.backgroundColor = UIColor(red: 230/255, green: 159/255, blue: 19/255, alpha: 1)
			}
		}
	}
    
    
	/**
        Prepares for a segue to the detail view for a particular point of
        interest on the map.
	
        Parameters:
            - segue:  The segue that was triggered by user. If this is not the
                      segue to the landmarkDetail view, then don't perform the
                      segue.
     
            - sender: The sender, in our case, will be one of the Google Maps markers
                      that was pressed, which will in turn have data associated with
                      it that will given to the landmark detail view.
	*/
	@IBAction func startAction(_ sender: AnyObject) {
		if var startedQuests = UserDefaults.standard.object(forKey: "startedQuests") as! Dictionary<String,Int>! {
			if (startedQuests[quest.name] == nil) {
				startedQuests[quest.name] = 0
				UserDefaults.standard.set(startedQuests,forKey: "startedQuests")
			}
		}
	}
	
}
