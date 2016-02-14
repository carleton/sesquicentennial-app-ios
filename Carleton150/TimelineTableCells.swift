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

/**
    The timeline cell prototype if the event
    only has text. Will expand to accommodate the
    text as necessary.
 */
class TimelineTableCellTextOnly: TimelineTableCell {
	
    @IBOutlet weak var summary: UILabel!
    
	@IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    func setCellViewTraits() {
        self.cellView.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.cellView.layer.borderWidth = 0.5
        self.cellView.layer.cornerRadius = 10;
    }
    
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
            self.timestamp.text = cellTimestamp ?? ""
        }
    }
}

/**
    The timeline cell prototype if the event has an image.
 */
class TimelineTableCellImageOnly: TimelineTableCell {
    
	@IBOutlet weak var imgView: UIImageView!
	
	@IBOutlet weak var caption: UILabel!
	
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    
    func setCellViewTraits() {
        self.cellView.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.cellView.layer.borderWidth = 0.5
        self.cellView.layer.cornerRadius = 10;
    }
    
    override var cellCaption: String? {
        didSet {
           self.caption.text = cellCaption ?? ""
        }
    }
    
    override var cellTimestamp: String? {
        didSet {
            self.timestamp.text = cellTimestamp ?? ""
        }
    }
    
    override var cellImage: UIImage? {
        didSet {
            if let cellImage = cellImage {
                self.imgView.image = cellImage
            }
        }
    }
}