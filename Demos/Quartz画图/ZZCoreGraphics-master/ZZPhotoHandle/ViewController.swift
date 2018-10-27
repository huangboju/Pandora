//
//  ViewController.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

// http://www.jianshu.com/p/491b50cb19cb
// http://www.cocoachina.com/industry/20140115/7703.html

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CoreGraphics Demo"

//        let mtLable = MTLabel1(frame: CGRect(x: 0,y: 44,width: 160,height: 110))
//        view.addSubview(mtLable)
        


        // Do any additional setup after loading the view, typically from a nib.
        let cgView = CGView(frame:CGRect(x: 0, y: 44,width: 160,height: 110) )
        cgView.backgroundColor = UIColor.white
//        self.view.addSubview(cgView)
        
        let cgView2 = CGView2(frame:CGRect(x: 160, y: 64,width: 160,height: 110))
        cgView2.backgroundColor = UIColor.white
        self.view.addSubview(cgView2)

        let cgView3 = CGView3(frame:CGRect(x: 0,y: 164,width: view.frame.width,height: self.view.frame.size.height - 110))
        cgView3.backgroundColor = UIColor.white
//        self.view.addSubview(cgView3)
        
//        drawByUIKit()

        drawByCoreGraphics()
        
//        translate() // 平移
        
//        zoom() // 缩放
        
//        clip() // 裁剪
        
//        split() // 拆分
        
        fix()
    }
    
    func drawByUIKit() {
        /*
            size: 创建的图片的尺寸
            opaque: 指定所生成图片的背景是否为不透明
            scale: 指定生成图片的缩放因子，这个缩放因子与UIImage的scale属性所指的含义是一致的
            传入0则表示让图片的缩放因子根据屏幕的分辨率而变化
        */
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))

        UIColor.green.setFill()

        path.fill()
        
        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: img)
        view.addSubview(imageView)
    }
    
    func drawByCoreGraphics() {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 100, height: 100), false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.addEllipse(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        context.setFillColor(UIColor.orange.cgColor)
        context.fillPath()

        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: img)
        view.addSubview(imageView)
    }

    
    func translate() {
        guard let mars = UIImage(named: "mars") else { return }

        let sz = mars.size

        UIGraphicsBeginImageContextWithOptions(CGSize(width: sz.width * 2, height: sz.height), false, 0)
        
        mars.draw(at: .zero)
        
        mars.draw(at: CGPoint(x:sz.width, y: 0))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: img)
        imageView.center = view.center
        view.addSubview(imageView)
    }
    
    func zoom() {
        guard let mars = UIImage(named: "mars") else { return }
        
        let sz = mars.size
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: sz.width * 2, height: sz.height * 2), false, 0)
        
        mars.draw(in: CGRect(origin: .zero, size: CGSize(width: sz.width*2, height: sz.height*2)))
        

        mars.draw(in: CGRect(x: sz.width/2.0, y: sz.height / 2.0, width: sz.width, height: sz.height), blendMode: .multiply, alpha: 1)

        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: img)
        imageView.center = view.center
        view.addSubview(imageView)
    }
    
    func clip() {
        guard let mars = UIImage(named: "mars") else { return }
        
        let sz = mars.size
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: sz.width/2.0, height: sz.height), false, 0)

        mars.draw(at: CGPoint(x: -sz.width/2.0, y: 0))

        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: img)
        imageView.center = view.center
        view.addSubview(imageView)
    }
    
    
    func split() {
        guard let mars = UIImage(named: "mars") else { return }
        
        // 抽取图片的左右半边
        
        let sz = mars.size
        
        guard let marsLeft = flip(mars.cgImage!).cropping(to: CGRect(x: 0, y: 0, width: sz.width/2.0, height: sz.height)) else { return }

        guard let marsRight = flip(mars.cgImage!).cropping(to: CGRect(x: sz.width/2.0, y: 0, width: sz.width/2.0, height: sz.height)) else { return }

        // 将每一个CGImage绘制到图形上下文中
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: sz.width*1.5, height: sz.height), false, 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.draw(marsLeft, in: CGRect(x: 0, y: 0, width: sz.width/2.0, height: sz.height))

        context?.draw(marsRight, in: CGRect(x: sz.width, y: 0, width: sz.width/2.0, height: sz.height))

        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()

        let imageView = UIImageView(image: img)
        imageView.center = view.center
        view.addSubview(imageView)
    }
    
    func flip(_ img: CGImage) -> CGImage {
        
        let sz = CGSize(width: img.width, height: img.height)
        
        UIGraphicsBeginImageContextWithOptions(sz, false, 0)
        
        UIGraphicsGetCurrentContext()?.draw(img, in: CGRect(x: 0, y: 0, width: sz.width, height: sz.height))

        let result = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
    
        UIGraphicsEndImageContext()
        
        return result ?? img
        
    }
    
    func fix() {
        guard let mars = UIImage(named: "mars") else { return }
        
        let sz = mars.size
        
        guard let marsCG = mars.cgImage else { return }
        
        let szCG = CGSize(width: marsCG.width, height: marsCG.height)
        
        let marsLeft = marsCG.cropping(to: CGRect(x: 0, y: 0, width: szCG.width/2.0, height: szCG.height))
        
        let marsRight = marsCG.cropping(to: CGRect(x: szCG.width/2.0, y: 0, width: szCG.width/2.0, height: szCG.height))
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: sz.width * 1.5, height: sz.height), false, 0)
        
        UIImage(cgImage: marsLeft!, scale: mars.scale, orientation: .up).draw(at: .zero)

        UIImage(cgImage: marsRight!, scale: mars.scale, orientation: .up).draw(at: CGPoint(x: sz.width, y: 0))

        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: img)
        imageView.center = view.center
        view.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

