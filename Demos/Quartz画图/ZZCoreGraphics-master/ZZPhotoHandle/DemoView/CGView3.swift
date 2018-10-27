//
//  CGView3.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CGView3: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 1、 获取上下文对象
        guard let context = UIGraphicsGetCurrentContext() else { return
        }
        //画矩形
        drawRectWithContext(context)
        //画矩形 用uikit封装的方法
        drawRectByUIKitWithContext(context)
        //画椭圆 宽高一样就是正圆
        drawEllipse(context)
        //画弧形
        drawArc(context)
        //绘制 二次三次贝塞尔曲线
        drawCurve(context)
    }
    
    /**
     画矩形
     
     - parameter context: 上下文对象
     */
    func drawRectWithContext(_ context:CGContext){
        let rect = CGRect(x: 20, y: 0 , width: 280, height: 50)
        context.addRect(rect)
        UIColor.blue.set()
        context.drawPath(using: .fillStroke)
    }

    /**
     画矩形 用uikit封装的方法
     
     - parameter context: 上下文对象
     */
    func drawRectByUIKitWithContext(_ context:CGContext){
        let rect = CGRect(x: 20, y: 60, width: 280.0, height: 50.0)
        let rect2 = CGRect(x: 20, y: 120, width: 280.0, height: 50.0)
        
        UIColor.yellow.set()
        UIRectFill(rect)

        UIColor.red.setFill()
        UIRectFill(rect2)
    }
    
    /**
     画椭圆 宽高一样就是正圆
     
     - parameter context: 上下文对象
     */
    func drawEllipse(_ context:CGContext){
        let rect = CGRect(x: 20, y: 180 ,width: 100,height: 120)
        
        context.addEllipse(in: rect)
        UIColor.purple.set()
        context.drawPath(using: .fill)
    }
    
    /**
     创建弧形
     
     - parameter context: 上下文对象
     */
    func drawArc(_ context:CGContext) {
        /*
        添加弧形对象
        x:中心点x坐标
        y:中心点y坐标
        radius:半径
        startAngle:起始弧度
        endAngle:终止弧度
        closewise:是否逆时针绘制，false则顺时针绘制
        */

        context.addArc(center: CGPoint(x: 200, y: 250), radius: 50, startAngle: 0, endAngle: .pi, clockwise: false)
        UIColor.green.set()
        context.drawPath(using: .fill)
    }
    
    /**
     绘制贝塞尔曲线
     
     - parameter context: 上下文对象
     */
    func drawCurve(_ context:CGContext){
        //绘制曲线
        context.move(to: CGPoint(x: 20, y: 310)) //移动到起始位置
        /*
        绘制二次贝塞尔曲线
        c:图形上下文
        cpx:控制点x坐标
        cpy:控制点y坐标
        x:结束点x坐标
        y:结束点y坐标
        */
        
        context.addQuadCurve(to: CGPoint(x: 100, y: 400), control: CGPoint(x: 220, y: 310))
        
        context.move(to: CGPoint(x: 230, y: 310))
        /*绘制三次贝塞尔曲线
        c:图形上下文
        cp1x:第一个控制点x坐标
        cp1y:第一个控制点y坐标
        cp2x:第二个控制点x坐标
        cp2y:第二个控制点y坐标
        x:结束点x坐标
        y:结束点y坐标
        */

        context.addCurve(to: CGPoint(x: 300, y: 500), control1: CGPoint(x: 100, y: 300), control2: CGPoint(x: 400, y: 410))
        
        UIColor.yellow.setFill()
        UIColor.red.setStroke()
        context.drawPath(using: .fillStroke)
    }
    
}
