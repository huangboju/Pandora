//
//  CGView8.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CGView8: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext()
        drawImage(context!)
    }
    /**
     平移旋转缩放
     
     - parameter context: 上下文对象
     */
    func drawImage(_ context: CGContext){
        //保存初始状态
        context.saveGState()

        //形变第一步：图形上下文向右平移100
        context.translateBy(x: 100, y: 0)

        //形变第二步：缩放0.8
        context.scaleBy(x: 0.8, y: 0.8)

        //形变第三步：旋转
        context.rotate(by: CGFloat(M_PI_4) / 4)
        let img = UIImage(named: "ddla")

        //从某一点开始绘制
        img?.draw(at: CGPoint(x: 0, y: 100))
        
    }
}
