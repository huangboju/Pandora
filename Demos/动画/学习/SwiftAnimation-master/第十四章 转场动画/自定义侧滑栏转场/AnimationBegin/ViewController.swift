//
//  ViewController.swift
//  AnimationBegin
//
//  Created by jones on 5/5/16.
//  Copyright © 2016 jones. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var pushSliderVC:Bool = true
    var sliderVC:SliderViewController = SliderViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView:UIImageView = UIImageView(frame:CGRect(x: 0, y: 0, width: DEVICE_SCREEN_WIDTH, height: DEVICE_SCREEN_HEIGHT))
        imageView.image = UIImage(named: "login.png")
        self.view.addSubview(imageView)
        
        let loginButton:UIButton = UIButton(frame: CGRect(x: 20, y: 230, width: self.view.frame.width-20*2,height: 50))
        loginButton.backgroundColor = UIColor(red: 50/255.0, green: 185/255.0, blue: 170/255.0, alpha: 1.0)
        loginButton.setTitle("登陆", for: UIControlState())
        self.view.addSubview(loginButton)
        
        
        sliderVC.view.frame = CGRect(x: 0, y: 0, width: DEVICE_SCREEN_WIDTH, height: DEVICE_SCREEN_HEIGHT)
        sliderVC.view.isHidden=true
        self.view.addSubview(sliderVC.view)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pushSliderVC {
            sliderVC.view.isHidden = false
            sliderVC.sliderLeftViewAnimStart()
        }else{
            sliderVC.view.isHidden = true
            sliderVC.sliderVCDismiss()
        }
        pushSliderVC = !pushSliderVC
    }


}

