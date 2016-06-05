//
//  WaypointTableCells.swift
//  Carleton150

import UIKit

/**
	Generic table cell that the two modal table
	that all table cells will inherit from
*/
class WaypointTableCell: UITableViewCell {
	var titleText: String!
	var descText: String!
}


/**
	Contains just text
*/
class WaypointTableTextCell : WaypointTableCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	@IBOutlet weak var cellView: UIView!
	
	
	func setCellViewTraits() {
		self.cellView.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
		self.cellView.layer.borderWidth = 0.5
		self.cellView.layer.cornerRadius = 10;
	}
	
	override var titleText: String? {
		didSet {
			if let titleText = titleText {
				self.titleLabel.text = titleText
			}
		}
	}
	
	override var descText: String? {
		didSet {
			if let descText = descText {
				self.descLabel.text = descText
				self.descLabel.sizeToFit()
			}
		}
	}
	
}