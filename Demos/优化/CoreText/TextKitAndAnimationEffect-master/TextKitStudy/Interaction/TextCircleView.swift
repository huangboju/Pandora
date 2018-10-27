//
//  TextCircleView.swift
//  TextKitStudy
//
//  Created by steven on 3/7/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

@IBDesignable
class TextCircleView: UIView {

//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        self.tintColor.setFill()
        UIBezierPath(ovalInRect: self.bounds).fill()
        ("move" as NSString).drawInRect(CGRectMake(rect.size.width/2.9, rect.size.height/3, rect.size.width, rect.size.height), withAttributes: [NSForegroundColorAttributeName:UIColor.redColor(),NSFontAttributeName:UIFont.systemFontOfSize(18)])

    }


}
