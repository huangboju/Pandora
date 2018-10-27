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
        // Do any additional setup after loading the view, typically from a nib.
        
        // 第一阶段:初始化登录按钮
        loginButton = UIButton(frame: CGRect(x: -394, y: 210, width: self.view.frame.width-20*2, height: 50))
        loginButton!.backgroundColor = UIColor(colorLiteralRed: 50/255.0, green: 185/255.0, blue: 170/255.0, alpha: 1.0)
        loginButton!.setTitle("登录", for: UIControlState.normal)
        loginButton!.layer.cornerRadius = 3
        self.view.addSubview(loginButton!)
    }
    
    // 第二阶段:移动Btn
    override func viewWillAppear(_ animated: Bool) {
        
//        // 方法一:闭包
//        UIView.animate(withDuration: 1) { 
//            self.loginButton!.frame = CGRect(x: 20, y: self.loginButton!.frame.origin.y, width: self.loginButton!.frame.width, height: self.loginButton!.frame.height)
//        }
        
        // 方法二:方法形式
        UIView.beginAnimations(nil, context: nil)// 动画开始
        UIView.setAnimationDuration(1)// 动画时间设置
        loginButton!.frame = CGRect(x: 20, y: self.loginButton!.frame.origin.y, width: self.loginButton!.frame.width, height: self.loginButton!.frame.height)// 按钮位置变化
        UIView.commitAnimations()// 提交动画
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

