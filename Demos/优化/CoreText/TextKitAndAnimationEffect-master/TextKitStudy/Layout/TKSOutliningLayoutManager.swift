//
//  TKSOutliningLayoutManager.swift
//  TextKitStudy
//
//  Created by steven on 2/17/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSOutliningLayoutManager: NSLayoutManager {
    
    var count:Int = 0;
    
    override func drawGlyphsForGlyphRange(glyphsToShow: NSRange, atPoint origin: CGPoint) {
        super.drawGlyphsForGlyphRange(glyphsToShow, atPoint: origin)
    }
    
    override func drawUnderlineForGlyphRange(glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
        super.drawUnderlineForGlyphRange(glyphRange, underlineType: underlineVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
        
        //Left border (== position) of first underlined graphly
        let firstPosition:CGFloat = self.locationForGlyphAtIndex(glyphRange.location).x
        var lastPosition:CGFloat;
        if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)
        {
            lastPosition = self.locationForGlyphAtIndex(NSMaxRange(glyphRange)).x
        }else
        {
            lastPosition = self.lineFragmentUsedRectForGlyphAtIndex(NSMaxRange(glyphRange)-1, effectiveRange: nil).size.width
        }
        //计算被调用次数
        count += 1
        print("\(self.count)")
        
        var lineFragmentRect = lineRect
        print("containerOrigin:\(containerOrigin)")
        print("前lineFragmentRect:\(lineFragmentRect)")
        
        lineFragmentRect.origin.x += firstPosition
        lineFragmentRect.size.width = lastPosition - firstPosition
        
//
        lineFragmentRect.origin.x += containerOrigin.x
        lineFragmentRect.origin.y += containerOrigin.y
        
        print("后lineFragmentRect:\(lineFragmentRect)")
        lineFragmentRect = CGRectInset(CGRectIntegral(lineFragmentRect), 0.5, 0.5);

        
        UIColor.redColor().set()
        UIBezierPath(rect: lineFragmentRect).stroke()

        
        
        
        
    }
    
    
    override func setLineFragmentRect(fragmentRect: CGRect, forGlyphRange glyphRange: NSRange, usedRect: CGRect) {
        super.setLineFragmentRect(fragmentRect, forGlyphRange: glyphRange, usedRect: usedRect)
//        var lineFragmentRect = fragmentRect
//        lineFragmentRect = CGRectInset(CGRectIntegral(lineFragmentRect), 0.5, 0.5)
        
        
        //        UIColor.yellowColor().set()
        //        UIGraphicsBeginImageContext(fragmentRect.size)
        //        let context = UIGraphicsGetCurrentContext()
        //        UIGraphicsPushContext(context!)
//        UIColor.yellowColor().set()
        //        CGContextSaveGState(context)
        //        CGContextSetLineWidth(context, 1.0)
        //        CGContextSetLineJoin(context, CGLineJoin.Round)
//        UIBezierPath(rect: lineFragmentRect).stroke()
        
        //        let path = UIBezierPath(rect: lineFragmentRect)
        //        CGContextAddPath(context, path.CGPath)
        //        CGContextStrokePath(context)
        //        CGContextSetStrokeColorWithColor(context, UIColor.yellowColor().CGColor)
        //        CGContextRestoreGState(context)
        //        UIGraphicsPopContext()
        //        UIGraphicsEndImageContext()
        
    }
    
}


