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
        
        let view:UIView = UIView()
        view.backgroundColor = UIColor.red
        view.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
        self.view.addSubview(view)
        
        
        
        let animation:CAKeyframeAnimation = CAKeyframeAnimation()
        animation.duration = 10.0
        animation.keyPath = "opacity"
        let valuesArray:[NSNumber] = [NSNumber(value: 0.95 as Float),
                                      NSNumber(value: 0.90 as Float),
                                      NSNumber(value: 0.88 as Float),
                                      NSNumber(value: 0.85 as Float),
                                      NSNumber(value: 0.35 as Float),
                                      NSNumber(value: 0.05 as Float),
                                      NSNumber(value: 0.0 as Float)]
        animation.values = valuesArray
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        view.layer.add(animation, forKey: nil)
    }
}

