//
//  CircleView.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/20.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

protocol CircleDelegate{
    func circleAnimationStop()
}

class CircleView: UIView,CAAnimationDelegate {

    var lineWidth:NSNumber = 3.0
    var strokeColor:UIColor = UIColor(red: 25.0 / 255.0, green: 155.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    var circle:CAShapeLayer = CAShapeLayer()
    var delegate:CircleDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let startAngle:CGFloat = -90.0/180.0 * CGFloat(M_PI)
        let endAngle:CGFloat = -90.01/180.0 * CGFloat(M_PI)
        let circlePath:UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2,y: frame.size.height/2), radius: frame.size.height/2-2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circle.path = circlePath.cgPath
        circle.lineCap = kCALineCapRound
        circle.fillColor = UIColor.clear.cgColor
        circle.lineWidth = lineWidth as CGFloat
        
        self.layer.addSublayer(circle)
    }
    func strokeChart(){
        circle.lineWidth = lineWidth as CGFloat
        circle.strokeColor = strokeColor.cgColor
        let pathAnimation:CABasicAnimation = CABasicAnimation()
        pathAnimation.keyPath = "strokeEnd"
        pathAnimation.delegate = self
        pathAnimation.duration = 3.0
        pathAnimation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        pathAnimation .setValue("strokeEndAnimationcircle", forKey: "groupborderkeycircle")
        circle.add(pathAnimation, forKey: "strokeEndAnimationcircle")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        delegate!.circleAnimationStop()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
