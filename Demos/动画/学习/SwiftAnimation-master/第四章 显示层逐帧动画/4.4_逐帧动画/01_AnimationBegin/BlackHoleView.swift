//
//  BlackHoleView.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/9.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class BlackHoleView: UIView {
    
    var blackHoleRadius:Float = 0
    func blackHoleIncrease(_ radius: Float){
        blackHoleRadius = radius
        self.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        ctx.addArc(center: CGPoint(x:self.center.x,y:self.center.y), radius: CGFloat(blackHoleRadius), startAngle: 0, endAngle: CGFloat(M_PI * 2), clockwise: false)
        ctx.fillPath()
    }
}
