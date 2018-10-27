//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var singleTap1:UITapGestureRecognizer?
    var singleTap2:UITapGestureRecognizer?
    var singleTap3:UITapGestureRecognizer?
    var buttonview1:ButtonView?
    var buttonview2:ButtonView?
    var buttonview3:ButtonView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonview1 = ButtonView(frame:CGRect(x: 100, y: 150, width: 210, height: 70))
        buttonview2 = ButtonView(frame:CGRect(x: 100, y: 275, width: 210, height: 70))
        buttonview3 = ButtonView(frame:CGRect(x: 100, y: 400, width: 210, height: 70))
        
        singleTap1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewAction1))
        singleTap2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewAction2))
        singleTap3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.viewAction3))
        
        buttonview1?.addGestureRecognizer(singleTap1!)
        buttonview2?.addGestureRecognizer(singleTap2!)
        buttonview3?.addGestureRecognizer(singleTap3!)
        
        self.view.addSubview(buttonview1!)
        self.view.addSubview(buttonview2!)
        self.view.addSubview(buttonview3!)
    }
    func viewAction1(){
        buttonview1?.startAnimation()
    }
    func viewAction2(){
        buttonview2?.startAnimation()
    }
    func viewAction3(){
        buttonview3?.startAnimation()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

