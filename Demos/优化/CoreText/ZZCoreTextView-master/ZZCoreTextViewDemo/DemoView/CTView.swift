//
//  CTView.swift
//  ZZCoreTextDemo
//
//  Created by duzhe on 16/1/29.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

// http://www.jianshu.com/p/e52a38e60e7c

class CTView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // 1
        guard let context = UIGraphicsGetCurrentContext() else { return }

        // 2
        context.textMatrix = .identity
        context.translateBy(x: 0, y: bounds.height)
        context.scaleBy(x: 1.0, y: -1.0)

        // 3
        //        let path = CGMutablePath()
        //
        //        path.addRect(bounds)
        //
        let path1 = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width / 2)

        // 4
        let attrString = "Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!Hello CoreText!"

        let mutableAttrStr = NSMutableAttributedString(string: attrString)
        mutableAttrStr.addAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20),
            NSAttributedString.Key.foregroundColor: UIColor.red,
        ], range: NSMakeRange(0, 20))

        mutableAttrStr.addAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.underlineStyle: 1,
        ], range: NSMakeRange(20, 18))

        // 通过CFAttributedString(NSAttributeString 也可以无缝桥接)进行初始化
        let framesetter = CTFramesetterCreateWithAttributedString(mutableAttrStr)

        // 它作为CTFrame对象的生产工厂，负责根据path生产对应的CTFrame, CTFrame是指整个该UIView子控件的绘制区域
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, mutableAttrStr.length), path1.cgPath, nil)

        // 5
        CTFrameDraw(frame, context)
    }
}
