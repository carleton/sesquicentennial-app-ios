//
//  QuestInformationCell.swift
//  Carleton150
//
//  Created by Chet Aldrich on 1/31/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import Foundation

class QuestInformationCell: UITableViewCell {
    
    @IBOutlet weak var ClueText: UILabel!
    @IBOutlet weak var showHint: UIButton!
    @IBOutlet weak var Header: UILabel!
}

class QuestInfoPicCell: UITableViewCell {
    @IBOutlet weak var ClueText: UILabel!
    @IBOutlet weak var showHint: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var Header: UILabel!
}