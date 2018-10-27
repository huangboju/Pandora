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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Img = UIImageView()
        Img?.frame = UIScreen.main.bounds
        Img?.image = UIImage(named: "turntable.png")
        Img?.contentMode = UIViewContentMode.scaleAspectFit
        self.view.addSubview(Img!)
        
        animationCircle()
        
    }
    
    func animationCircle() {
        
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {() in
          
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/4, animations: {() in
                self.index += 1
                let angle:CGFloat = CGFloat(M_PI_2)*CGFloat(self.index)
                self.Img?.transform = CGAffineTransform(rotationAngle: angle)
            })
            UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4, animations: {() in
                self.index += 1
                let angle:CGFloat = CGFloat(M_PI_2)*CGFloat(self.index)
                self.Img?.transform = CGAffineTransform(rotationAngle: angle)
            })
            UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4, animations: {() in
                self.index += 1
                let angle:CGFloat = CGFloat(M_PI_2)*CGFloat(self.index)
                self.Img?.transform = CGAffineTransform(rotationAngle: angle)
            })
            UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4, animations: {() in
                self.index += 1
                let angle:CGFloat = CGFloat(M_PI_2)*CGFloat(self.index)
                self.Img?.transform = CGAffineTransform(rotationAngle: angle)
            })
        }, completion:{(finish) in
            self.animationCircle()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

