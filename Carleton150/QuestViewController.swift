//
//  QuestViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 1/20/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class QuestViewController: UIViewController {

	var questIndex: Int = 0
	var quests: [Quest] = []
	
	@IBOutlet weak var questName: UILabel!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getQuests()
    }
	
	func getQuests() {
		DataService.requestQuest("", limit: 5, completion: { (success, result) -> Void in
			if let quests = result {
				self.quests = quests
				self.questName.text = quests[self.questIndex].name
				print(self.questName.text)
			}
		});
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
