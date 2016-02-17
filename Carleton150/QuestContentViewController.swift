//
//  QuestContentViewController.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 2/17/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class QuestContentViewController: UIViewController {

	var pageIndex: Int!
	var titleText: String!
	var image: String!
	var descText: String!
	var buttonText: String!
	
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var descTextView: UITextView!
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var imageView: UIImageView!
	
    override func viewDidLoad() {
    }

	@IBAction func startAction(sender: AnyObject) {
	}
	
}
