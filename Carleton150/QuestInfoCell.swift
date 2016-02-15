//
//  QuestInformationCell.swift
//  Carleton150
//

import Foundation

class QuestInfoCell: UITableViewCell {
	
	var cellHeader: String!
	var cellText: String!
	var cellImage: String!
	
}

class QuestInfoCellText: QuestInfoCell {
    
	@IBOutlet weak var header: UILabel!
	@IBOutlet weak var clueHint: UILabel!
	@IBOutlet weak var show: UIButton!
	
	func setCellProperties() {
		// cells are no longer selectable
		self.selectionStyle = UITableViewCellSelectionStyle.None
	}
	
	override var cellHeader: String? {
		didSet {
			if let cellHeader = cellHeader {
				self.header.text = cellHeader
			} else {
				self.header.text = ""
			}
		}
	}
	
	override var cellText: String? {
		didSet {
			if let cellText = cellText {
				self.clueHint.text = cellText
				self.clueHint.sizeToFit()
			} else {
				self.clueHint.text = ""
			}
		}
	}
	
}

class QuestInfoCellImage: QuestInfoCell {

	@IBOutlet weak var header: UILabel!
	@IBOutlet weak var clueHint: UITextView!
	@IBOutlet weak var show: UIButton!
	@IBOutlet weak var imgView: UIImageView!
	
	func setCellProperties() {
		// cells are no longer selectable
		self.selectionStyle = UITableViewCellSelectionStyle.None
	}
	
	override var cellHeader: String? {
		didSet {
			if let cellHeader = cellHeader {
				self.header.text = cellHeader
			} else {
				self.header.text = ""
			}
		}
	}
	
	override var cellText: String? {
		didSet {
			if let cellText = cellText {
				self.clueHint.text = cellText
				self.clueHint.sizeToFit()
				self.clueHint.selectable = false
				self.clueHint.editable = false
				self.clueHint.textContainer.exclusionPaths = [UIBezierPath(rect: self.imgView.bounds)]
			} else {
				self.clueHint.text = ""
			}
		}
	}
	
	override var cellImage: String? {
		didSet {
			if let cellImage = cellImage {
				let imgData = NSData(base64EncodedString: cellImage, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters) 
				self.imgView.image = UIImage(data: imgData!)
			} else {
				
			}
		}
	}
    
}