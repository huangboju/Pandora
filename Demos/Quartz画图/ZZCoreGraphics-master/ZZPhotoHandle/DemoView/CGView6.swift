//
//  CGView6.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//
import UIKit

class CGView6: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //绘制径向渐变
        drawRadialGradient(context)
        //绘制了一个矩形填充的渐变
        drawRectWithLinearGradientFill(context)
    }
    
    /**
     径向渐变绘制
     
     - parameter context: 上下文
     */
    func drawRadialGradient(_ context: CGContext){
        
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        /*
        指定渐变色
        space:颜色空间
        components:颜色数组,注意由于指定了RGB颜色空间，那么四个数组元素表示一个颜色（red、green、blue、alpha），
        如果有三个颜色则这个数组有4*3个元素
        locations:颜色所在位置（范围0~1），这个数组的个数不小于components中存放颜色的个数
        count:渐变个数，等于locations的个数
        */
        let compoents:[CGFloat] = [
            248.0/255.0,
            86.0/255.0,
            86.0/255.0,
            1,
            249.0/255.0,
            127.0/255.0,
            127.0/255.0,
            1,
            1.0,
            1.0,
            1.0,
            1.0
        ]
        
        let locations:[CGFloat] = [0, 0.4, 1]
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count)
        /*
        绘制线性渐变
        context:图形上下文
        gradient:渐变色
        startPoint:起始位置
        startRadius:起始半径（通常为0，否则在此半径范围内容无任何填充）
        endCenter:终点位置（通常和起始点相同，否则会有偏移）
        endRadius:终点半径（也就是渐变的扩散长度）
        options:绘制方式,DrawsBeforeStartLocation 开始位置之前就进行绘制，到结束位置之后不再绘制，
        DrawsAfterEndLocation开始位置之前不进行绘制，到结束点之后继续填充
        */
        context.drawRadialGradient(gradient!, startCenter: CGPoint(x: 100,y: 100), startRadius: 0, endCenter: CGPoint(x: 105, y: 105), endRadius: 80, options: CGGradientDrawingOptions.drawsAfterEndLocation)
    }

    /**
     绘制了一个矩形填充的渐变
     
     - parameter context: 上下文对象
     */
    func drawRectWithLinearGradientFill(_ context: CGContext){
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //裁切处一块矩形用于显示，注意必须先裁切再调用渐变
        //CGContextClipToRect(context, CGRectMake(20, 150, 280, 300))
        //裁切还可以使用UIKit中对应的方法
        UIRectClip(CGRect(x: 20, y: 250, width: 300, height: 300))
        
        let compoents:[CGFloat] = [
            248.0/255.0,
            86.0/255.0,
            86.0/255.0,
            1,
            249.0/255.0,
            127.0/255.0,
            127.0/255.0,
            1,
            1.0,
            1.0,
            1.0,
            1.0
        ]
        
        let locations:[CGFloat] = [0,0.4,1]
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents, locations: locations, count: locations.count)
         context.drawLinearGradient(gradient!, start: CGPoint(x: 20, y: 250), end: CGPoint(x: 320, y: 300), options: .drawsAfterEndLocation);
    }
    
    
}
