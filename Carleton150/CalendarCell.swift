//
//  CalendarCell.swift
//  Carleton150

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var EventImageView: UIImageView!
  
    var currentImage: UIImage? {
        didSet {
            if let currentImage = currentImage {
                EventImageView.image = currentImage
            }
        }
    }
}