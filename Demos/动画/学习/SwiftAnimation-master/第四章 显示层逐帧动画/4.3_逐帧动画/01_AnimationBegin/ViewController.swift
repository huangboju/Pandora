//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var Img:UIImageView?
    var index:Int = 0
    var displaylink:CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Img = UIImageView()
        Img?.frame = UIScreen.main.bounds
        Img?.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(Img!)
        
        index = 0
        displaylink = CADisplayLink.init(target: self, selector: #selector(ViewController.refushImage))
        displaylink?.preferredFramesPerSecond = 60
        displaylink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func refushImage() {
        
        Img?.image = UIImage(named: "\(index).png")
        index += 1
        if(index == 67){
            
            index = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

