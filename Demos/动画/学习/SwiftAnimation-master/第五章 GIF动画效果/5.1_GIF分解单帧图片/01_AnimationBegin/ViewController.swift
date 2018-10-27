//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit
import ImageIO

class ViewController: UIViewController {

    /*
     5个模块，4个过程
     1、本地读取GIF图片，将其转换为 NSData 数据类型
     2、将 NSData 作为 ImageIO 模块的输入
     3、获取 ImageIO 的输出数据：UIImage
     4、将获取到的 UIImage 数据存储为 JPG 或者 PNG 格式保存到本地
     
     */
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gifPath:NSString = Bundle.main.path(forResource: "plane", ofType: "gif")! as NSString
        let gifData:Data = try!Data(contentsOf: URL(fileURLWithPath: (gifPath as NSString) as String))
        let gifDataSource:CGImageSource = CGImageSourceCreateWithData(gifData as CFData, nil)!
        let gifImageCount:Int = CGImageSourceGetCount(gifDataSource)
        
        for i in 0...gifImageCount-1 {
            
//            let imageref:CGImage? = CGImageSourceCreateImageAtIndex(gifDataSource,i,nil)
//            let image:UIImage = UIImage(cgImage: imageref!, scale: UIScreen.main.scale, orientation: UIImageOrientation.up)
            
            let imageref:CGImage? = CGImageSourceCreateImageAtIndex(gifDataSource, i, nil)
            let image:UIImage = UIImage(cgImage: imageref!, scale:UIScreen.main.scale, orientation:UIImageOrientation.up )
            let imageData:Data = UIImagePNGRepresentation(image)!
            var docs=NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let documentsDirectory = docs[0] as String
            let imagePath = documentsDirectory+"/\(i)"+".png"
            try? imageData .write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
            print("\(imagePath)")
            
        }
    }
    


}

