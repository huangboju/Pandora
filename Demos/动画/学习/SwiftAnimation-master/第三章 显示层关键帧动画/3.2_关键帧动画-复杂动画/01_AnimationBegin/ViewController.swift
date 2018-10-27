//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageViewAirport:UIImageView?
    var imageViewPlane:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        imageViewAirport = UIImageView()
        imageViewAirport?.frame = UIScreen.main.bounds
        imageViewAirport?.image = UIImage(named: "Airport.png")
        imageViewAirport?.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(imageViewAirport!)
        
        imageViewPlane = UIImageView()
        imageViewPlane?.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        imageViewPlane?.image = UIImage(named: "Plane.png")
        imageViewPlane?.contentMode = UIViewContentMode.scaleAspectFit
        imageViewAirport!.addSubview(imageViewPlane!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animateKeyframes(withDuration: 2, delay: 0, options: UIViewKeyframeAnimationOptions.calculationModeCubic, animations: {() in
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2, animations: { 
                self.imageViewPlane?.frame = CGRect(x: 300, y: 100, width: 30, height: 30)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: { 
                self.imageViewPlane?.frame = CGRect(x: 300, y: 300, width: 80, height: 80)
            })
            
        }, completion:{(finish) in
            print("done")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

