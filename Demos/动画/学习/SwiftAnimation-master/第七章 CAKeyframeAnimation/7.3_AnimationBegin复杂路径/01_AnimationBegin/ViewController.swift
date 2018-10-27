//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageView:UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = CGRect(x:50,y:50,width:50,height:50)
        imageView.image = UIImage(named: "Plane.png")
        self.view.addSubview(imageView)
        let pathLine:CGMutablePath = CGMutablePath()
        pathLine.move(to: CGPoint(x:50,y:50))
        pathLine.addLine(to: CGPoint(x:300,y:50))
        
        let animation:CAKeyframeAnimation = CAKeyframeAnimation()
        animation.duration = 2.0
        animation.path = pathLine
        animation.keyPath = "position"
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        imageView.layer.add(animation, forKey: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {() in
            self.imageView.frame = CGRect(x: 300, y: 300, width: 50, height: 50)
        }, completion:{(finish) in
            print("done")
        })
    }
}

