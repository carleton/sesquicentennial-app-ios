//
//  TimelineTableCell.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 1/27/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class TimelineTableCellTextOnly: UITableViewCell {
	
	@IBOutlet weak var title: UILabel!
	
	@IBOutlet weak var desc: UILabel!
	
	@IBOutlet weak var timestamp: UILabel!

}

class TimelineTableCellImageOnly: UITableViewCell {
	@IBOutlet weak var title: UILabel!
	
	@IBOutlet weak var imgView: UIImageView!
	
	@IBOutlet weak var caption: UILabel!
	
	@IBOutlet weak var timestamp: UILabel!
}