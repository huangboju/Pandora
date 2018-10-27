//
//  CGView.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CGView: UIView {

    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        // 1、 获取上下文对象
        let context = UIGraphicsGetCurrentContext()
        
        // 2、 创建路径对象
        let path = CGMutablePath()
        
        path.move(to: CGPoint(x: 10, y: 30))
        path.addLine(to: CGPoint(x: 10, y: 100))
        path.addLine(to: CGPoint(x: 150, y: 100))
        
        // 3、 添加路径到图形上下文 
        context?.addPath(path)
        
        // 4、 设置图形上下文状态属性
        context?.setStrokeColor(red: 1, green: 0, blue: 1, alpha: 1) //设置笔触颜色
        context?.setFillColor(red: 1, green: 1, blue: 0, alpha: 1)   //设置填充色
        
        context?.setLineWidth(5)   //设置线条宽度
        context?.setLineCap(.round) // 设置顶点样式
        context?.setLineJoin(.round) //设置连接点样式
        /*设置线段样式
        phase:虚线开始的位置  这里设置为0
        lengths: 虚线长度间隔
        */
        let lengths: [CGFloat] = [5, 7] //长度间隔
        context?.setLineDash(phase: 0, lengths: lengths)

        let color = UIColor.gray.cgColor //颜色转化，由于Quartz 2D跨平台，所以其中不能使用UIKit中的对象，但是UIkit提供了转化方法
        /*设置阴影
        context:图形上下文
        offset:偏移量
        blur:模糊度
        color:阴影颜色
        */
        context?.setShadow(offset: CGSize(width: 2, height: 2), blur: 0.8, color: color)
        
        // 5、 绘制图像到指定图形上下文
        /*
        CGPathDrawingMode是填充方式,枚举类型
        Fill:只有填充（非零缠绕数填充），不绘制边框
        EOFill:奇偶规则填充（多条路径交叉时，奇数交叉填充，偶交叉不填充）
        Stroke:只有边框
        FillStroke：既有边框又有填充
        EOFillStroke：奇偶填充并绘制边框
        */
        context?.drawPath(using: .fillStroke) //最后一个参数是填充类型
    }
}
