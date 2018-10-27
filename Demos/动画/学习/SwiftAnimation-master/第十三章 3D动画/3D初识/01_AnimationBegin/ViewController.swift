//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        imageView?.frame = CGRect(x: 0, y: 0, width: 400, height: 300)
        imageView?.center = self.view.center
        imageView?.image = UIImage(named: "image.jpg")
        imageView?.contentMode = UIViewContentMode.scaleAspectFit
        imageView!.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.view.addSubview(imageView!)
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(4)
        var transform:CATransform3D = CATransform3DIdentity
        transform.m22 = 0.5
        imageView!.layer.transform = CATransform3DScale(transform, 1, 1, 1)
        //        imageView!.layer.transform = CATransform3DMakeRotation(CGFloat(M_PI/2.0), 1, 1, 1);
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
