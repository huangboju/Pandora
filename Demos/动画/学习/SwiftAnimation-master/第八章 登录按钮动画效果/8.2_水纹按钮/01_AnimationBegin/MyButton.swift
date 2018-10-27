//
//  MyButton.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/18.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class MyButton: UIButton {

    var viewRadius:CGFloat = 0
    var countNum:Int = 0
    var timer:Timer?
    var circleCenterX:CGFloat = 0
    var circleCenterY:CGFloat = 0
    var targetAnimColor:UIColor = UIColor(red: 216.0 / 255.0, green: 114.0 / 255.0, blue: 213.0 / 255.0, alpha: 0.8)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 50/255.0, green: 185/255.0, blue: 170/255.0, alpha: 1.0)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func StartButtonAnimatin(_ msenderBt:UIButton,mevent:UIEvent){
        
        self.isUserInteractionEnabled = false
        let button:UIView = msenderBt as UIView
        let touchSet:NSSet = mevent.touches(for: button)! as NSSet
        var touchArray:[AnyObject] = touchSet.allObjects as [AnyObject]
        
        let touch1:UITouch = touchArray[0] as! UITouch
        let point1:CGPoint = touch1.location(in: button)
        
        self.circleCenterX = point1.x
        self.circleCenterY = point1.y
        
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(MyButton.timeaction), userInfo: nil, repeats: true);
        
        RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        
    }
    
    func timeaction(){
        countNum += 1
        
        let dismissTime:DispatchTime = DispatchTime.now() + Double(Int64(0*NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dismissTime, execute: {() in
            self.viewRadius += 5
            self.setNeedsDisplay()
            
        })
        if(countNum>50){
            countNum = 0
            viewRadius = 0
            timer?.invalidate()
            DispatchQueue.main.asyncAfter(deadline: dismissTime, execute: {() in
                self.viewRadius = 0
                self.setNeedsDisplay()
                
            })
            self.isUserInteractionEnabled = true
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let ctx:CGContext = UIGraphicsGetCurrentContext()!
        let endangle:CGFloat = CGFloat(M_PI*2)
        ctx.addArc(center:CGPoint(x:circleCenterX,y:circleCenterY),radius:viewRadius,startAngle:0,endAngle:endangle,clockwise:false)
        let stockColor:UIColor = targetAnimColor
        stockColor.setStroke()
        stockColor.setFill()
        ctx.fillPath()
    }

}
