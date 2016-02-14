//
//  TimelineTitleView.swift
//  Carleton150

import Foundation

extension UIView {
    
    /**
        Adds a bottom border to a UIView of the specified color and stroke width. 
        
        - Parameters: 
            - color: The color you want for the border. 
            
            - width: The stroke width of the bottom border.
     */
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.CGColor
        border.frame = CGRectMake(0, self.frame.size.height - width, self.frame.size.width, width)
        self.layer.addSublayer(border)
    }
}
