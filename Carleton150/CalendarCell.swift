//
//  CalendarCell.swift
//  Carleton150

import UIKit

class CalendarCell: UICollectionViewCell {
    
    @IBOutlet weak var EventImageView: UIImageView!
    @IBOutlet weak var imageCoverView: UIView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var currentImage: UIImage? {
        didSet {
            if let currentImage = currentImage {
                EventImageView.image = currentImage
            }
        }
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        let standardHeight = CalendarLayoutConstants.Cell.standardHeight
        let featuredHeight = CalendarLayoutConstants.Cell.featuredHeight
        
        let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
        
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.65
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
       
        // scale the title as the cell scales
        let scale = max(delta, 0.75)
        eventTitle.transform = CGAffineTransformMakeScale(scale, scale)
       
        // set time and location to fade in as the cell scales
        locationLabel.alpha = delta
        timeLabel.alpha = delta
    }
}