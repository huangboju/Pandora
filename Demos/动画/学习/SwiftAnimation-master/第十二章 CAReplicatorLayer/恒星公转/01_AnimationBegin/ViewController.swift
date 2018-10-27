//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let UISCREEN_WIDTH = UIScreen.main.bounds.size.width
    let UISCREEN_HEIGHT = UIScreen.main.bounds.size.height
    var replicatorLayer:CAReplicatorLayer = CAReplicatorLayer()
    var iv_earth:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UISCREEN_WIDTH, height: UISCREEN_HEIGHT))
        background.image = UIImage(named: "background.jpg")
        self.view.addSubview(background)
        
        iv_earth = UIImageView(frame: CGRect(x: (UISCREEN_WIDTH-50)/2+150, y: (UISCREEN_HEIGHT-50)/2, width: 50, height: 50))
        iv_earth!.image = UIImage(named: "earth.png")
        
        let iv_sun = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        iv_sun.center = self.view.center
        iv_sun.image = UIImage(named: "sun.png")
        
        replicatorLayer.addSublayer(iv_earth!.layer)
        replicatorLayer.addSublayer(iv_sun.layer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let path:UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: self.view.center.x, y: self.view.center.y), radius: 150, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        path.close()
        let animation:CAKeyframeAnimation = CAKeyframeAnimation(keyPath:"position")
        animation.path = path.cgPath
        animation.duration = 10
        animation.repeatCount = MAXFLOAT
        
        replicatorLayer.instanceCount = 100
        replicatorLayer.instanceDelay = 0.2
        self.view.layer.addSublayer(replicatorLayer)
        
        iv_earth?.layer.add(animation, forKey: nil)
    }
}

