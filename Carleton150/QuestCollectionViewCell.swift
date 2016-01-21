//
//  QuestCollectionViewCell.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 1/20/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class QuestCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var name: UILabel!
	@IBOutlet weak var text: UITextView!
    @IBOutlet weak var information: UILabel!
	var questIndex = 0
	
}
