//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CAAnimationDelegate {

    var loginButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        loginButton = UIButton(frame: CGRect(x: 20, y: 210, width: self.view.frame.width-20*2, height: 50))
        loginButton!.backgroundColor = UIColor(colorLiteralRed: 50/255.0, green: 185/255.0, blue: 170/255.0, alpha: 1.0)
        loginButton!.setTitle("登录", for: UIControlState.normal)
        loginButton!.layer.cornerRadius = 3
        self.view.addSubview(loginButton!)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 缩放，基于 UIView 的 transform 属性
        UIView.beginAnimations(nil, context: nil)// 动画开始
        UIView.setAnimationDelegate(self)// 设置回调对象
        UIView.setAnimationDuration(1)// 动画时间
        loginButton!.transform = CGAffineTransform(scaleX: 0.7, y: 1.2)// 缩放比，>1为扩大，<1为缩放
        UIView.setAnimationDidStop(#selector(ViewController.animationEnd))
        UIView.commitAnimations()// 动画提交
        
    }
    
    // 1.delegate 回调
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("animation stop!")
    }
    
    // 2.自定义回调
    func animationEnd() {
        print("animationEnd")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

