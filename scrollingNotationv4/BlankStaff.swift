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
    
    var trebleSymbol = UIImageView()
    var trebleSymbolAspectRatio:CGFloat = 0.35
    var bassSymbol = UIImageView()
    var bassSymbolAspectRatio:CGFloat = 0.87
    
    
    override func drawRect(rect: CGRect) {
        
        //Draw the grand staff lines in the background
        
        //get width of frame 
        staffLineEndX = self.frame.size.width
        
        //context is the object used for drawing
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 3.0)
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        
        //make top note line
        CGContextMoveToPoint(context,staffLineStartX, topLineY)
        CGContextAddLineToPoint(context, staffLineEndX, topLineY)
        
        //make the remainder of the treble clef
        for index in 1...4 {
            let i:CGFloat = CGFloat(index)
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
        
        
        for index in 6...10 {
            let i:CGFloat = CGFloat(index)
            CGContextMoveToPoint(context,staffLineStartX, topLineY + spaceBetweenStaffLines * i)
            CGContextAddLineToPoint(context, staffLineEndX, topLineY + spaceBetweenStaffLines * i)
        }
        
        CGContextStrokePath(context)
        
        let trebleSymbol = UIImageView(image: UIImage(named: "treble"))
        
        trebleSymbol.frame = CGRectMake(2, topLineY - spaceBetweenStaffLines, spaceBetweenStaffLines * 7 * trebleSymbolAspectRatio, spaceBetweenStaffLines * 6.5)
        trebleSymbol.alpha = 0.75
        addSubview(trebleSymbol)
        
        
        let bassSymbol = UIImageView(image: UIImage(named: "bass"))
        
        bassSymbol.frame = CGRectMake(0, topLineY + spaceBetweenStaffLines * 6, bassSymbolAspectRatio * 80, 80)
        bassSymbol.alpha = 0.75
        addSubview(bassSymbol)
        
        //make top line over treble cleff
        CGContextSetLineWidth(context, 1.0)
        CGContextSetStrokeColorWithColor(context, UIColor.lightGrayColor().CGColor)
        
        CGContextMoveToPoint(context, staffLineStartX, topLineY + (spaceBetweenStaffLines * -1))
        CGContextAddLineToPoint(context, staffLineEndX, topLineY + (spaceBetweenStaffLines * -1))
        
        CGContextStrokePath(context)
        
        //make bottom line under bass clef
        CGContextMoveToPoint(context, staffLineStartX, topLineY + (spaceBetweenStaffLines * 11))
        CGContextAddLineToPoint(context, staffLineEndX, topLineY + (spaceBetweenStaffLines * 11))
        
        CGContextStrokePath(context)
        
    }
}
