//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageViewArray:NSMutableArray?
    let imageView1:UIImageView = UIImageView(frame:CGRect(x: 100, y: 100, width: 200, height: 250))
    let imageView2:UIImageView = UIImageView(frame:CGRect(x: 100, y: 100, width: 200, height: 250))
    let imageView3:UIImageView = UIImageView(frame:CGRect(x: 100, y: 150, width: 300, height: 200))
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        imageViewArray = [imageView1,imageView2,imageView3]
        for i in 0...(imageViewArray?.count)!-1{
            let imageView:UIImageView = imageViewArray?.object(at: i) as! UIImageView
            let imageName:String = "\(i).jpg"
            imageView.image = UIImage(named: imageName)
            imageView.layer.anchorPoint.y = 0.0
            view.addSubview(imageView)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        for i in 0...(imageViewArray?.count)!-1{
            
            var imageTransform = CATransform3DIdentity
            imageTransform.m34 = -0.005;
            imageTransform = CATransform3DTranslate(
                imageTransform, 0.0, 50.0, 0.0)
            imageTransform = CATransform3DScale(
                imageTransform, 0.95, 0.6, 1.0)
            
            if i==0 {
                imageTransform = CATransform3DRotate(
                    imageTransform, CGFloat(M_PI_4/2), 0.0, 1.0, 0.0)
            }else if i==1{
                imageTransform = CATransform3DRotate(
                    imageTransform, CGFloat(-M_PI_4/2), 0.0, 1.0, 0.0)
            }
            
            let imageView:UIImageView = imageViewArray?.object(at: i) as! UIImageView
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = NSValue(caTransform3D:
                imageView.layer.transform)
            animation.toValue = NSValue(caTransform3D: imageTransform)
            animation.duration = 3
            
            
            let animBounds:CABasicAnimation = CABasicAnimation()
            animBounds.keyPath = "position"
            animBounds.duration = 3
            if i==0 {
                animBounds.toValue = NSValue(cgPoint:CGPoint(x: 100, y: 10))
            }else if i==1{
                animBounds.toValue = NSValue(cgPoint:CGPoint(x: 300, y: 10))
            }else{
                animBounds.toValue = NSValue(cgPoint:CGPoint(x: 200, y: 20))
            }
            
            let animGroup:CAAnimationGroup = CAAnimationGroup()
            animGroup.duration = 3
            animGroup.repeatCount = 1
            animGroup.isRemovedOnCompletion = false
            animGroup.fillMode=kCAFillModeForwards
            animGroup.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
            animGroup.animations = [animation,animBounds]
            imageView.layer.add(animGroup, forKey: "\(i)")
        }
    }
}


