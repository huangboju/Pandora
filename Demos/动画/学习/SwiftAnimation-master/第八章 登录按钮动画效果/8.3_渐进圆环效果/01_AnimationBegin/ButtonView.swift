//
//  ButtonView.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/20.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ButtonView: UIView,CircleDelegate,CAAnimationDelegate {

    let FreshBlue:UIColor = UIColor(red: 25.0 / 255.0, green: 155.0 / 255.0, blue: 200.0 / 255.0, alpha: 1.0)
    let FreshGreen:UIColor = UIColor(red: 150.0 / 255.0, green: 203.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    var view:UIView?
    var viewborder:UIView?
    var button_x:CGFloat = 0
    var button_y:CGFloat = 0
    var button_w:CGFloat = 0
    var button_h:CGFloat = 0
    var label:UILabel?
    var circleView:CircleView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        button_x = frame.origin.x;
        button_y = frame.origin.y;
        button_w = frame.size.width;
        button_h = frame.size.height;
        view = UIView(frame:CGRect(x: 0, y: 0, width: button_w, height: button_h))
        view!.backgroundColor = FreshBlue;
        viewborder = UIView(frame:CGRect(x: 0, y: 0, width: button_w, height: button_h))
        viewborder!.backgroundColor = UIColor.clear
        viewborder!.layer.borderColor = FreshBlue.cgColor;
        viewborder!.layer.borderWidth = 3.0;
        self.addSubview(view!)
        self.addSubview(viewborder!)
        
        circleView = CircleView(frame:CGRect(x: 0, y: 0, width: button_w, height: button_h))
        circleView!.delegate = self as CircleDelegate
        self.addSubview(circleView!)
        
        label = UILabel(frame:CGRect(x: 0, y: 0, width: button_w, height: button_h))
        label!.text = "UpLoad"
        label!.textAlignment = NSTextAlignment.center
        label!.textColor = UIColor.white
        label!.font = UIFont.systemFont(ofSize: 20.0)
        self .addSubview(label!)
    }
    func startAnimation(){
        
        label?.removeFromSuperview()
        let animMakeBigger:CABasicAnimation = CABasicAnimation()
        animMakeBigger.keyPath = "cornerRadius"
        animMakeBigger.fromValue=5.0
        animMakeBigger.toValue=button_h/2.0
        let animBounds:CABasicAnimation = CABasicAnimation()
        animBounds.keyPath = "bounds"
        animBounds.toValue = NSValue(cgRect:CGRect(x: button_x+(button_w-button_h)/2, y: button_h, width: button_h, height: button_h))
        let animAlpha:CABasicAnimation = CABasicAnimation()
        animAlpha.keyPath = "opacity"
        animAlpha.toValue = 0
        let animGroup:CAAnimationGroup = CAAnimationGroup()
        animGroup.duration = 1
        animGroup.repeatCount = 1
        animGroup.isRemovedOnCompletion = false
        animGroup.fillMode=kCAFillModeForwards
        animGroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animGroup.animations = [animMakeBigger,animBounds,animAlpha]
        let animborder:CABasicAnimation = CABasicAnimation()
        animborder.keyPath = "borderColor"
        animborder.toValue = UIColor(red: 224.0/255, green: 224.0/255, blue: 224.0/255, alpha: 1.0).cgColor
        let animGroupAll:CAAnimationGroup = CAAnimationGroup()
        animGroupAll.duration = 1
        animGroupAll.repeatCount = 1
        animGroupAll.isRemovedOnCompletion = false
        animGroupAll.fillMode=kCAFillModeForwards ;
        animGroupAll.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        animGroupAll.animations = [animMakeBigger,animBounds,animborder]
        animGroupAll.delegate = self
        animGroupAll.setValue("allMyAnimationsBoard", forKey: "groupborderkey")
        CATransaction.begin()
        view?.layer.add(animGroup, forKey: "allMyAnimation")
        viewborder?.layer.add(animGroupAll, forKey: "allMyAnimationsBoard")
        CATransaction.commit()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if(flag){
            let animType = anim.value(forKey: "groupborderkey")
            let animType1 = anim.value(forKey: "groupborderkey1")
            if(animType != nil){
                if ((animType as! NSString).isEqual(to: "allMyAnimationsBoard")){
                    circleView?.strokeChart()
                }
            }else if(animType1 != nil){
                if((animType1 as! NSString).isEqual(to: "allMyAnimationsBoardspread1")){
                    label = UILabel(frame:CGRect(x: 0, y: 0, width: button_w, height: button_h))
                    label!.text = "Complete"
                    label!.textAlignment = NSTextAlignment.center
                    label!.textColor = UIColor.white
                    label!.font = UIFont.systemFont(ofSize: 20)
                    self.addSubview(label!)
                }
            }
        }
    }
    func startAnimationSpread(){
        let animMakeBigger:CABasicAnimation = CABasicAnimation()
        animMakeBigger.keyPath = "cornerRadius"
        animMakeBigger.fromValue=button_h/2.0
        animMakeBigger.toValue=0
        let animBounds:CABasicAnimation = CABasicAnimation()
        animBounds.keyPath = "bounds"
        animBounds.fromValue = NSValue(cgRect:CGRect(x: button_x+(button_w-button_h)/2, y: button_h, width: button_h, height: button_h))
        animBounds.toValue = NSValue(cgRect:CGRect(x: 0, y: 0, width: button_w, height: button_h))
        let animAlpha:CABasicAnimation = CABasicAnimation()
        animAlpha.keyPath = "opacity";
        animAlpha.toValue = 1.0
        let animBackground:CABasicAnimation = CABasicAnimation()
        animBackground.keyPath = "backgroundColor"
        animBackground.toValue = FreshGreen.cgColor
        let group:CAAnimationGroup = CAAnimationGroup()
        group.duration = 1
        group.repeatCount = 1
        group.isRemovedOnCompletion = false
        group.fillMode=kCAFillModeForwards
        group.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        group.animations = [animMakeBigger,animBounds,animAlpha,animBackground]
        let animBorder:CABasicAnimation = CABasicAnimation()
        animBorder.keyPath = "borderColor"
        animBorder.toValue = FreshGreen.cgColor
        let allGroup:CAAnimationGroup = CAAnimationGroup()
        allGroup.duration = 1
        allGroup.repeatCount = 1
        allGroup.isRemovedOnCompletion = false
        allGroup.fillMode=kCAFillModeForwards
        allGroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        allGroup.animations = [animMakeBigger,animBounds,animAlpha,animBorder]
        CATransaction.begin()
        view?.layer.add(group, forKey: "allMyAnimationspread1")
        allGroup.setValue("allMyAnimationsBoardspread1", forKey: "groupborderkey1")
        allGroup.delegate = self
        viewborder?.layer.add(allGroup, forKey: "allMyAnimationsBoardspread1")
        CATransaction.commit()
    }
    func circleAnimationStop(){
        circleView?.removeFromSuperview()
        self.startAnimationSpread()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
