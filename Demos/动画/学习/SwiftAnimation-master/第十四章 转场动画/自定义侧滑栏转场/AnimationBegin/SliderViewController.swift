//
//  SliderViewController.swift
//  AnimationBegin
//
//  Created by jones on 8/25/16.
//  Copyright © 2016 jones. All rights reserved.
//

import UIKit
import Accelerate
let DEVICE_SCREEN_HEIGHT = UIScreen.main.bounds.height
let DEVICE_SCREEN_WIDTH = UIScreen.main.bounds.width
class SliderViewController: UIViewController {
    internal var blurView:UIView?
    internal var contentView:UIView?
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView = UIView(frame: CGRect(x: 0, y: 0, width: DEVICE_SCREEN_WIDTH, height: DEVICE_SCREEN_HEIGHT))
        self.view.addSubview(blurView!)
        contentView = UIView(frame: CGRect(x: -DEVICE_SCREEN_WIDTH*0.60, y: 0, width: DEVICE_SCREEN_WIDTH*0.60, height: DEVICE_SCREEN_HEIGHT))
        contentView!.backgroundColor = UIColor(red: 255.0 / 255.0, green: 127.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
        self.view.addSubview(contentView!)
    }

    
    func sliderVCDismiss(){
        UIView.animate(withDuration: 0.5, animations: {()->Void in
            self.contentView!.frame = CGRect(x: -DEVICE_SCREEN_WIDTH*0.6, y: 0, width: DEVICE_SCREEN_WIDTH*0.6, height: DEVICE_SCREEN_HEIGHT)
            self.contentView!.alpha = 0.9
            }, completion: {(finished:Bool)->Void in
                self.view.alpha=0.0
        })
    }

    func sliderLeftViewAnimStart(){

        var windowview:UIView = UIView()
        windowview = UIApplication.shared.keyWindow!.rootViewController!.view
        
        blurView?.layer.contents = blurimageFromImage(imageFromUIView(windowview)).cgImage
        self.view.alpha=1.0
        UIView.animate(withDuration: 0.5, animations: {()->Void in
            self.contentView!.frame = CGRect(x: 0, y: 0, width: DEVICE_SCREEN_WIDTH*0.6, height: DEVICE_SCREEN_HEIGHT)
            self.contentView!.alpha = 0.9
            }, completion: {(finished:Bool)->Void in
        })
        
    }

    
    func imageFromUIView(_ view:UIView)->UIImage{
        UIGraphicsBeginImageContext(view.frame.size)
        let content:CGContext = UIGraphicsGetCurrentContext()!
        view.layer.render(in: content)
        let imagenew:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return imagenew
    }
    func blurimageFromImage(_ image:UIImage)->UIImage{
        let blurRadix:UInt32 = 7
        let img:CGImage = image.cgImage!
        let inProvider:CGDataProvider = img.dataProvider!
        let bitmapdata:CFData = inProvider.data!
        
        var inputBuffer:vImage_Buffer = vImage_Buffer()
        inputBuffer.data=(UnsafeMutableRawPointer)(mutating: CFDataGetBytePtr(bitmapdata))
        inputBuffer.width=(vImagePixelCount)(img.width)
        inputBuffer.height=(vImagePixelCount)(img.height)
        inputBuffer.rowBytes=img.bytesPerRow;
        
        let pixelBuffer:UnsafeMutableRawPointer = malloc(img.bytesPerRow * img.height);
        
        var outputBuffer:vImage_Buffer = vImage_Buffer()
        outputBuffer.data=pixelBuffer
        outputBuffer.width=(vImagePixelCount)(img.width)
        outputBuffer.height=(vImagePixelCount)(img.height)
        outputBuffer.rowBytes=img.bytesPerRow;
        
        vImageBoxConvolve_ARGB8888(&inputBuffer, &outputBuffer, nil, 0, 0, blurRadix, blurRadix, nil, UInt32(kvImageEdgeExtend))

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let w:Int=(Int)(outputBuffer.width)
        let h:Int=(Int)(outputBuffer.height)
        
        let ctx:CGContext = CGContext(data: outputBuffer.data, width: w, height: h, bitsPerComponent: 8, bytesPerRow: outputBuffer.rowBytes, space: colorSpace, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)!
        
        let imageRef:CGImage = ctx.makeImage ()!
        let imagenew:UIImage = UIImage(cgImage:imageRef)
        
        free(pixelBuffer)
        
        return imagenew;
    }
    

}
