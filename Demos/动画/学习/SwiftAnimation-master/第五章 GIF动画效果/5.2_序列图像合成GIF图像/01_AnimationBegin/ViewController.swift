//
//  ViewController.swift
//  01_AnimationBegin
//
//  Created by 张丁豪 on 2017/3/1.
//  Copyright © 2017年 张丁豪. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

class ViewController: UIViewController {

    /*
     1、加载待处理的67张原始数据源
     2、在 Document 目录下构建 GIF 文件
     3、设置 GiF 文件属性，利用 ImageIO 编码 GIF 文件
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // part1：读取 67 张 PNG 图片并添加到数组
        let images:NSMutableArray = NSMutableArray()
        
        for i in 0...66 {
            
            let imagePath = "\(i).png"
            let image:UIImage = UIImage(named: imagePath)!
            images.add(image)
        }
        
        // part2：在 Document 目录创建 GIF 文件
        var docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = docs[0] as String
        let gifPath = documentsDirectory+"/plane.gif"
        print("\(gifPath)")
        
        let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, gifPath as CFString!, CFURLPathStyle.cfurlposixPathStyle, false)
        let destion = CGImageDestinationCreateWithURL(url!, kUTTypeGIF, images.count, nil)
        
        // part3:设置 gif 图片属性，利用67张 png 图片构建 gif
        let cgimagePropertiesDic = [kCGImagePropertyGIFDelayTime as String:0.1] // 设置每帧之间播放时间
        let cgimagePropertiesDestDic = [kCGImagePropertyGIFDictionary as String:cgimagePropertiesDic];
        for cgimage in images{
            CGImageDestinationAddImage(destion!, (cgimage as AnyObject).cgImage!!,cgimagePropertiesDestDic as CFDictionary?);
        } // 依次为 gif 图像对象添加每一帧元素
        
        let gifPropertiesDic:NSMutableDictionary = NSMutableDictionary()
        gifPropertiesDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String) // 设置图像的彩色空间格式
        gifPropertiesDic.setValue(16, forKey: kCGImagePropertyDepth as String) // 设置图像的颜色深度
        gifPropertiesDic.setValue(1, forKey: kCGImagePropertyGIFLoopCount as String) // 设置Gif执行次数
        let gifDictionaryDestDic = [kCGImagePropertyGIFDictionary as String:gifPropertiesDic]
        CGImageDestinationSetProperties(destion!,gifDictionaryDestDic as CFDictionary?) //为gif图像设置属性
    }
}

