//
//  BlankStaff.swift
//  scrollingNotationv4
//
//  Created by brendan woods on 2016-02-10.
//  Copyright © 2016 brendan woods. All rights reserved.
//

import UIKit

class BlankStaff: UIView {
    let spaceBetweenStaffLines: CGFloat = 20
    let staffLineStartX: CGFloat = 0.0
    var staffLineEndX: CGFloat = 0.0 // detetermined and assigned at runtime
    let topLineY: CGFloat = 100.0
    
    
    override func drawRect(rect: CGRect) {
        
        
        //Draw the grand staff lines in the background
        
        
        //get width of frame set set global variable
        staffLineEndX = self.frame.size.width
        
        //context is the object used for drawing
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 3.0)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        
        //make top note line
        CGContextMoveToPoint(context,staffLineStartX, topLineY)
        CGContextAddLineToPoint(context, staffLineEndX, topLineY)
        
        //make the remainder of the treble clef
        for var i :CGFloat = 1; i <= 4; i++ {
            CGContextMoveToPoint(context,staffLineStartX, topLineY + spaceBetweenStaffLines * i)
            CGContextAddLineToPoint(context, staffLineEndX, topLineY + spaceBetweenStaffLines * i)
        }
        CGContextStrokePath(context)
        
        //make middle C line
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.grayColor().CGColor)
        
        CGContextMoveToPoint(context, staffLineStartX, topLineY + (spaceBetweenStaffLines * 5))
        CGContextAddLineToPoint(context, staffLineEndX, topLineY + (spaceBetweenStaffLines * 5))
        
        CGContextStrokePath(context)
        
        // make bass clef
        CGContextSetLineWidth(context, 3.0)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        
        for var i:CGFloat = 6; i <= 10; i++ {
            CGContextMoveToPoint(context,staffLineStartX, topLineY + spaceBetweenStaffLines * i)
            CGContextAddLineToPoint(context, staffLineEndX, topLineY + spaceBetweenStaffLines * i)
        }
        
        CGContextStrokePath(context)
        
    }
    
    
}
