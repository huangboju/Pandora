//
//  CGView2.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CGView2: UIView {

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        
//        drawCicleByBezier()
        
        guard let context = UIGraphicsGetCurrentContext() else { return }

//        drawCicleByCoreGraphics(context)
        
//        drawArrow(context)
        
//        drawArrowByBezier()
        
//        drawRender(context)
//        drawArrowByBezier(context)
        
        drawGradientArrowByBezier(context)

//        // 1、 获取上下文对象
//        let context = UIGraphicsGetCurrentContext()
//        
//        // 2、 绘制路径（相当于前面创建路径并添加路径到图形上下文两步操作）
//        context?.move(to: CGPoint(x: 10, y: 30))
//        context?.addLine(to: CGPoint(x: 10, y: 100))
//        context?.addLine(to: CGPoint(x: 150, y: 100))
//
//        //封闭路径:直接调用路径封闭方法
//        context?.closePath()
//        
//        // 3、 设置图形上下文属性
//        UIColor.red.setStroke()
//        UIColor.yellow.setFill()
//        
//        // 4、 绘制路径
//        context?.drawPath(using: .fillStroke)
    }
    
    func drawCicleByBezier() {
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        UIColor.blue.setFill()
        
        path.fill()
    }
    
    func drawCicleByCoreGraphics(_ context: CGContext) {
        
        context.addEllipse(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
    }
    
    func drawArrow(_ context: CGContext) {

        // 绘制一个黑色的垂直黑色线，作为箭头的杆子
        
        context.move(to: CGPoint(x: 100, y: 100))
        context.addLine(to: CGPoint(x: 100, y: 19))

        context.setLineWidth(20)
        
        context.strokePath()

        
        // 绘制一个红色三角形箭头

        context.setFillColor(UIColor.red.cgColor)
        
        context.move(to: CGPoint(x: 80, y: 25))
        
        context.addLine(to: CGPoint(x: 100, y: 0))
        
        context.addLine(to: CGPoint(x: 120, y: 25))
        
        context.fillPath()

        // 从箭头杆子上裁掉一个三角形，使用清除混合模式

        context.move(to: CGPoint(x: 90, y: 101))

        context.addLine(to: CGPoint(x: 100, y: 90))

        context.addLine(to: CGPoint(x: 110, y: 101))

        context.setBlendMode(.clear)

        context.fillPath()
    }
    
    func drawArrowByBezier() {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 100, y: 100))
        
        path.addLine(to: CGPoint(x: 100, y: 19))
        
        path.lineWidth = 20
        
        path.stroke()

        UIColor.red.set()
        
        path.removeAllPoints()
        
        path.move(to: CGPoint(x: 80, y: 25))

        path.addLine(to: CGPoint(x: 100, y: 0))
        
        path.addLine(to: CGPoint(x: 120, y: 25))
        
        path.fill()
        
        path.removeAllPoints()
        
        path.move(to: CGPoint(x: 90, y: 101))
        
        path.addLine(to: CGPoint(x: 100, y: 90))
        
        path.addLine(to: CGPoint(x: 110, y: 101))

        path.fill(with: .clear, alpha: 1)
    }
    
    
    func drawArrowByBezier(_ context: CGContext) {
        
        // 在上下文裁剪区域中挖一个三角形状的孔
        context.move(to: CGPoint(x: 90, y: 100))
        
        context.addLine(to: CGPoint(x: 100, y: 90))
        
        context.addLine(to: CGPoint(x: 110, y: 100))

        context.closePath()

        context.addRect(context.boundingBoxOfClipPath)
        
        // 使用奇偶规则，裁剪区域为矩形减去三角形区域

        context.clip()
        
        // 绘制垂线
        
        context.move(to: CGPoint(x: 100, y: 100))

        context.addLine(to: CGPoint(x: 100, y: 19))
        
        context.setLineWidth(20);
        
        context.strokePath()
    
        // 画红色箭头
        context.setFillColor(UIColor.red.cgColor)
        
        context.move(to: CGPoint(x: 80, y: 25))
        
        context.addLine(to: CGPoint(x: 100, y: 0))

        context.addLine(to: CGPoint(x: 120, y: 25))

        context.fillPath()
    }

    func drawGradientArrowByBezier(_ context: CGContext) {
        context.saveGState()

        // 在上下文裁剪区域挖一个三角形孔
        context.move(to: CGPoint(x: 90, y: 100))
        
        context.addLine(to: CGPoint(x: 100, y: 90))
        
        context.addLine(to: CGPoint(x: 110, y: 100))
        
        context.closePath()

        context.addRect(context.boundingBoxOfClipPath)

        context.clip()
        
        //绘制一个垂线，让它的轮廓形状成为裁剪区域
        
        context.move(to: CGPoint(x: 100, y: 100))

        context.addLine(to: CGPoint(x: 100, y: 19))

        context.setLineWidth(20)
        
        // 使用路径的描边版本替换图形上下文的路径
        
        context.replacePathWithStrokedPath()
        
        // 对路径的描边版本实施裁剪

        context.clip()

        // 绘制渐变

        let locs: [CGFloat] = [0.0, 0.5, 1.0]

        let colors: [CGFloat]  = [
            
            0.3,0.3,0.3,0.8, // 开始颜色，透明灰
            
            0.0,0.0,0.0,1.0, // 中间颜色，黑色
            
            0.3,0.3,0.3,0.8 // 末尾颜色，透明灰
            
        ]

        let sp = CGColorSpaceCreateDeviceGray()

        let grad = CGGradient(colorSpace: sp, colorComponents: colors, locations: locs, count: 3)

        context.drawLinearGradient(grad!, start: CGPoint(x: 89, y: 0), end: CGPoint(x: 111, y: 0), options: [])

        context.restoreGState() // 完成裁剪

        // 绘制红色箭头 
        context.setFillColor(UIColor.red.cgColor)

        context.move(to: CGPoint(x: 80, y: 25))

        context.addLine(to: CGPoint(x: 100, y: 0))

        context.addLine(to: CGPoint(x: 120, y: 25))

        context.fillPath()
        
//        let sp2 = CGColorSpace(patternBaseSpace: nil)
//
//        context.setFillColorSpace(sp2!)
//
//        
//        let callback = CGPatternCallbacks(version: 0, drawPattern: &drawStripes, releaseInfo: nil)
//
//        let tr = CGAffineTransform.identity
//
//        let patt = CGPatternCreate(nil, CGRectMake(0,0,4,4), tr, 4, 4, .constantSpacingMinimalDistortion, true, callback)
//        
//        var alph: CGFloat = 1.0
//        
//        context.setFillPattern(patt, colorComponents: &alph)
    }

    func drawRender(_ context: CGContext) {
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(3)

        let path =  UIBezierPath(roundedRect: CGRect(x: 10, y: 5, width: 100, height: 100), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10))
        path.stroke()
    }
}



