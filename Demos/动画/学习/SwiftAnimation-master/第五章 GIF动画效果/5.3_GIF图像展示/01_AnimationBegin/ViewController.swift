//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var images:[UIImage] = []
        for i in 0...66{// 遍历本地67张图片
            let imagePath = "\(i).png" // 构建图片名称
            let image:UIImage = UIImage(named: imagePath)!//构建UIImage
            images.append(image)// 将图片添加到数组中
        }
        
        let imageView = UIImageView()
        imageView.frame = self.view.bounds
        imageView.contentMode = UIViewContentMode.center
        self.view.addSubview(imageView)
        
        imageView.animationImages = images
        imageView.animationDuration = 5
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
    }
}

