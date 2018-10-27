//
//  CGView4.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CGView4: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //文字绘制
        drawText(context)
        //图像绘制
        drawImage(context)
    }

    
    /**
     文字绘制
     
     - parameter context: 上下文对象
     */
    func drawText(_ context: CGContext){
        let str = "使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制使用CoreGraphics进行文字绘制"
        let rect = CGRect(x: 20, y: 20, width: 280, height: 200)
        let font = UIFont.systemFont(ofSize: 16)
        let color = UIColor.red
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        (str as NSString).draw(in: rect, withAttributes: [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: color,
            NSParagraphStyleAttributeName: style
            ])
        
    }
    
    /**
     图像绘制
     
     - parameter context: 上下文对象
     */
    func drawImage(_ context: CGContext){
    
        let img = UIImage(named: "ddla")
        //绘制到指定的矩形中，注意如果大小不合适会会进行拉伸
        img?.draw(in: CGRect(x: 0, y: 200, width: 100, height: 80))
        //从某一点开始绘制
        img?.draw(at: CGPoint(x: 0, y: 320))
        
    }
}
