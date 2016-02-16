//
//  CalendarCell.swift
//  Carleton150

import UIKit

class CalendarCell: UICollectionViewCell {
   
    /**
        The background view for the calendar cell
     */
    @IBOutlet weak var EventImageView: UIImageView!
    
    /**
        The view providing a darkening filter as the 
        cell goes out of focus.
     */
    @IBOutlet weak var imageCoverView: UIView!
    
    /**
        The title of the event.
     */
    @IBOutlet weak var eventTitle: UILabel!
    
    /**
        The location of the event.
     */
    @IBOutlet weak var locationLabel: UILabel!
    
    /**
        The starting time of the event.
     */
    @IBOutlet weak var timeLabel: UILabel!
   
    /**
        Sets the EventImageView to reflect the image
        set when setting the currentImage property.
     */
    var currentImage: UIImage? {
        didSet {
            if let currentImage = currentImage {
                EventImageView.image = currentImage
            }
        }
    }
    
    var eventDescription: String!
   
    /**
        Whenever the layout gets updated (which occurs as the user scrolls and invalidates
        the current layout), updates to each individual cell occur here.
     */
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
       
        // set constants for the standard vs. featured height to determine the delta for 
        // the continuous animated transition.
        let standardHeight = CalendarLayoutConstants.Cell.standardHeight
        let featuredHeight = CalendarLayoutConstants.Cell.featuredHeight
        
        let delta = 1 - ((featuredHeight - CGRectGetHeight(frame)) / (featuredHeight - standardHeight))
       
        // Set the amount of fade for the darkening view on top of each cell.
        let minAlpha: CGFloat = 0.3
        let maxAlpha: CGFloat = 0.65
        imageCoverView.alpha = maxAlpha - (delta * (maxAlpha - minAlpha))
       
        // Scale the title as the cell scales
        let scale = max(delta, 0.75)
        eventTitle.transform = CGAffineTransformMakeScale(scale, scale)
       
        // Set time and location to fade in as the cell scales
        locationLabel.alpha = delta
        timeLabel.alpha = delta
    }
}