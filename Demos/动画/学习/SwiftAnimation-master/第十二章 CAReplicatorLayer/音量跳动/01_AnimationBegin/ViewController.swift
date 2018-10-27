//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let replicatorLayer:CAReplicatorLayer = CAReplicatorLayer()
        
        self.view.backgroundColor = UIColor.black
        replicatorLayer.frame = CGRect(x: 0, y: 0, width: 414, height: 200)
        replicatorLayer.instanceCount = 20;
        replicatorLayer.instanceTransform = CATransform3DMakeTranslation(20, 0, 0)
        replicatorLayer.instanceDelay = 0.2
        replicatorLayer.masksToBounds = true
        replicatorLayer.backgroundColor = UIColor.black.cgColor;
        
        let layer = CALayer()
        layer.frame = CGRect(x: 14, y: 200, width: 10, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        
        replicatorLayer.addSublayer(layer)
        self.view.layer.addSublayer(replicatorLayer)
        
        let animation:CABasicAnimation = CABasicAnimation()
        animation.keyPath = "position.y"
        animation.duration = 0.5
        animation.fromValue = 200
        animation.toValue = 180
        animation.autoreverses = true
        animation.repeatCount = MAXFLOAT
        layer.add(animation, forKey: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


