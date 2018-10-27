//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var loginButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton = UIButton(frame: CGRect(x: 20, y: 230, width: self.view.frame.width-20*2,height: 50))
        loginButton!.backgroundColor = UIColor(red: 50/255.0, green: 185/255.0, blue: 170/255.0, alpha: 1.0)
        loginButton!.setTitle("登陆", for: UIControlState())
        self.view.addSubview(loginButton!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
         //位置
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "position"
////         let BtnX:CGFloat = loginButton!.frame.origin.x+0.5*loginButton!.frame.size.width;
////         let BtnY:CGFloat = loginButton!.frame.origin.y+0.5*loginButton!.frame.size.height+100;
//         animation.byValue = NSValue(cgPoint:CGPoint(x:-20,y:100))
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)
        
         
         //位置
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "transform.scale.x"
//         animation.fromValue = 1.0
//         animation.toValue = 0.8
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)

         // transform除了scale缩放属性之外还有rotation旋转属性
         //旋转
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "transform.rotation"
//         animation.toValue = 3.14/2
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)
        
         
         //位置
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "transform.translation.y"
//         animation.toValue = 100
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)
        
         //圆角
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "cornerRadius"
//         animation.toValue = 15
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)
        
         //边框
//         loginButton?.layer.borderColor = UIColor.gray.cgColor
//         loginButton?.layer.cornerRadius = 10.0
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "borderWidth"
//         animation.toValue = 10
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)
        
         //颜色
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "backgroundColor"
//         animation.fromValue = UIColor.green.cgColor
//         animation.toValue = UIColor.red.cgColor
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)
        
         //颜色
//         loginButton?.layer.borderWidth = 5
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "borderColor"
//         animation.fromValue = UIColor.green.cgColor
//         animation.toValue = UIColor.cyan.cgColor
//         animation.duration = 10.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)
        
         //淡入
//         let animation:CABasicAnimation = CABasicAnimation()
//         animation.keyPath = "opacity"
//         animation.fromValue = UIColor.green.cgColor
//         animation.toValue = 1.0
//         animation.duration = 2.0
//         animation.fillMode = kCAFillModeForwards
//         animation.isRemovedOnCompletion = false
//         loginButton?.layer.add(animation, forKey: nil)

        //阴影渐变
        loginButton?.layer.shadowColor = UIColor.red.cgColor
        loginButton?.layer.shadowOpacity = 0.5
        //        loginButton?.layer.shadowPath = shadowPath.CGPath
        let animation:CABasicAnimation = CABasicAnimation()
        animation.keyPath = "shadowOffset"
        animation.toValue = NSValue(cgSize: CGSize(width: 10, height: 10))
        animation.duration = 2.0
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        loginButton?.layer.add(animation, forKey: nil)
    }
}

