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
        
        loginButton = UIButton(frame: CGRect(x: 20, y: 210, width: self.view.frame.width-20*2, height: 50))
        loginButton!.backgroundColor = UIColor(colorLiteralRed: 50/255.0, green: 185/255.0, blue: 170/255.0, alpha: 1.0)
        loginButton!.setTitle("登录", for: UIControlState.normal)
        loginButton!.layer.cornerRadius = 3
        loginButton!.addTarget(self, action: #selector(loginAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(loginButton!)
    }
    
    // 实现点击事件
    func loginAction() {
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(2)
        let angel:CGFloat = CGFloat(M_PI)
        loginButton!.transform = CGAffineTransform(rotationAngle: angel)
        loginButton!.frame = CGRect(x: 400, y: 0, width: loginButton!.frame.width*0.1, height: loginButton!.frame.height*0.1)
        loginButton!.alpha = 0
        UIView.commitAnimations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

