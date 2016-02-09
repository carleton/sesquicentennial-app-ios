//
//  TimelineTableCell.swift
//  Carleton150

import UIKit

class TimelineTableCell: UITableViewCell {
    var cellSummary: String!
    var cellDescription: String!
    var cellCaption: String!
    var cellTimestamp: String!
    var cellImage: UIImage!
}

class TimelineTableCellTextOnly: TimelineTableCell {
	
    @IBOutlet weak var summary: UILabel!
    
	@IBOutlet weak var timestamp: UILabel!
    
    override var cellSummary: String? {
        didSet {
            if let cellSummary = cellSummary {
                self.summary.text = cellSummary
                self.summary.sizeToFit()
            } else {
                self.summary.text = ""
            }
        }
    }
    
    override var cellTimestamp: String? {
        didSet {
            if let cellTimestamp = cellTimestamp {
                self.timestamp.text = cellTimestamp
            } else {
                self.timestamp.text = ""
            }
        }
    }
}

class TimelineTableCellImageOnly: TimelineTableCell {
    
	@IBOutlet weak var imgView: UIImageView!
	
	@IBOutlet weak var caption: UILabel!
	
    @IBOutlet weak var timestamp: UILabel!
    
    override var cellCaption: String? {
        didSet {
            if let cellCaption = cellCaption {
                self.caption.text = cellCaption
            } else {
                self.caption.text = ""
            }
        }
    }
    
    override var cellTimestamp: String? {
        didSet {
            if let cellTimestamp = cellTimestamp {
                self.timestamp.text = cellTimestamp
            } else {
                self.timestamp.text = ""
            }
        }
    }
    
    override var cellImage: UIImage? {
        didSet {
            if let cellImage = cellImage {
                self.imgView.image = cellImage
            } else {
                self.imgView.image = nil
            }
        }
    }
}