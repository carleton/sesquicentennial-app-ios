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
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: Int(self.frame.size.height - width), width: Int(self.frame.size.height), height: Int(width))
        self.layer.addSublayer(border)
    }
}
