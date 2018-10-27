//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CAAnimationDelegate {

    var Img:UIImageView?
    var index:Int = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Img = UIImageView()
        Img?.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
        Img?.center = self.view.center
        Img?.image = UIImage(named: "turntable.png")
        Img?.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(Img!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //      CGAffineTransform:旋转
        UIView.beginAnimations(nil, context: nil)// 动画开始
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(ViewController.animationEnd))
        UIView.setAnimationDuration(0.01)// 动画周期设置
        let angle:CGFloat = CGFloat(M_PI_2);
        Img!.transform = CGAffineTransform(rotationAngle: angle)// 3.14
        UIView.commitAnimations()// 动画提交
        
    }
    
    func animationEnd() {
        
        UIView.beginAnimations(nil, context: nil)// 动画开始
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDidStop(#selector(ViewController.animationEnd))
        UIView.setAnimationDuration(0.01)// 动画周期设置
        let angleStart:CGFloat = CGFloat(M_PI_2)
        index += 1
        let angle:CGFloat = CGFloat(index)*angleStart
        Img!.transform = CGAffineTransform(rotationAngle: angle)
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

