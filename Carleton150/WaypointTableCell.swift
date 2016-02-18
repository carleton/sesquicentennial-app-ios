//
//  WaypointTableCells.swift
//  Carleton150
//

import UIKit

class WaypointTableCell: UITableViewCell {

	var titleText: String!
	var descText: String!
	
}

class WaypointTableImageCell : WaypointTableCell {
	
	var cellImage: UIImage!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	
	@IBOutlet weak var cellImageView: UIImageView!
	
}

class WaypointTableTextCell : WaypointTableCell {
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descLabel: UILabel!
	
}