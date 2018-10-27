//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //var loginButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton:MyButton = MyButton(frame: CGRect(x: 20, y: 230, width: self.view.frame.width-20*2,height: 50))
        loginButton.layer.cornerRadius = 3
        loginButton.layer.masksToBounds = true
        loginButton.setTitle("登陆", for: UIControlState())
        loginButton.addTarget(self, action: #selector(ViewController.loginAction(_:event:)), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginButton)
    }
    
    func loginAction(_ sender:UIButton,event:UIEvent) {
        let bt:MyButton = sender as! MyButton
        bt.StartButtonAnimatin(sender, mevent: event)
    }
}

