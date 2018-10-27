//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageView:UIImageView?
    var animBtn:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView()
        imageView?.frame = CGRect(x: 0, y: 0, width: 300, height: 400)
        imageView?.center = self.view.center
        imageView?.image = UIImage(named: "1.jpg")
        imageView?.contentMode = .scaleAspectFit
        view.addSubview(imageView!)
        
        animBtn = UIButton()
        animBtn?.frame = CGRect(x: 20, y: 30, width: 80, height: 44)
        animBtn?.backgroundColor = UIColor.red
        animBtn?.setTitle("AnimBtn", for: UIControlState.normal)
        animBtn?.setTitleColor(UIColor.white, for: UIControlState.normal)
        animBtn?.addTarget(self, action: #selector(animBtnClick), for: UIControlEvents.touchUpInside)
        view.addSubview(animBtn!)
        
    }
    
    func animBtnClick() {
        
        imageView?.image = UIImage(named: "2.jpg")
        let animation = CATransition()
        animation.duration = 2;
//        animation.type = "oglFlip" // 翻转效果
//        animation.type = "cube" // 立方体效果
//        animation.type = "stuckEffect" // 收缩效果
        animation.type = "rippleEffect" // 水滴波纹效果
//        animation.type = "pageUnCurl"  // 向下翻页
//        animation.type = "pageCurl" // 向上翻页
//        animation.type = "cameraIrisHollowOpen" // 相机打开
//        animation.type = "cameraIrisHollowClose" // 相机关闭
//        animation.type = kCATransitionFade // 淡入淡出
//        animation.type = kCATransitionPush // 推送效果
//        animation.type = kCATransitionReveal // 揭开效果
//        animation.type = kCATransitionMoveIn // 移动效果
//        animation.subtype = kCATransitionFromRight
        view.layer.add(animation, forKey: nil)
    }
    
    
}
