//
//  TimelineTableCell.swift
//  Carleton150
//
//  Created by Ibrahim Rabbani on 1/27/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import UIKit

class TimelineTableCell: UITableViewCell {
    var cellTitle: String!
    var cellDescription: String!
    var cellCaption: String!
    var cellTimestamp: String!
    var cellImage: UIImage!
}

class TimelineTableCellTextOnly: TimelineTableCell {
	
	@IBOutlet weak var title: UILabel!
	
	@IBOutlet weak var desc: UILabel!
	
	@IBOutlet weak var timestamp: UILabel!
    
    override var cellTitle: String? {
        didSet {
            if let cellTitle = cellTitle {
                self.title.text = cellTitle
            } else {
                self.title.text = ""
            }
        }
    }

    override var cellDescription: String? {
        didSet {
            if let cellDescription = cellDescription {
                self.desc.text = cellDescription
            } else {
                self.desc.text = ""
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
    
	@IBOutlet weak var title: UILabel!
	
	@IBOutlet weak var imgView: UIImageView!
	
	@IBOutlet weak var caption: UILabel!
	
	@IBOutlet weak var timestamp: UILabel!
    
    override var cellTitle: String? {
        didSet {
            if let cellTitle = cellTitle {
                self.title.text = cellTitle
            } else {
                self.title.text = ""
            }
        }
    }

    override var cellDescription: String? {
        didSet {
            if let cellDescription = cellDescription {
                self.caption.text = cellDescription
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