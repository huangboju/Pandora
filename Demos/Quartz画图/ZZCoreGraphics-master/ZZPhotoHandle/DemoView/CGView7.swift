//
//  CGView7.swift
//  ZZPhotoHandle
//
//  Created by duzhe on 16/2/28.
//  Copyright © 2016年 dz. All rights reserved.
//

import UIKit

class CGView7: UIView {

    //相信大家对比代码和显示效果并不难发现每种叠加的效果。例子中只是使用UIKit的封装方法进行叠加模式设置，更一般的方法当然是使用CGContextSetBlendMode(CGContextRef context, CGBlendMode mode)方法进行设置。
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let rect0 = CGRect(x: 0, y: 130.0, width: 320.0, height: 50.0)
        let rect1 = CGRect(x: 0, y: 390.0, width: 320.0, height: 50.0)
        
        let rect2=CGRect(x: 20, y: 50.0, width: 10.0, height: 250.0)
        let rect3=CGRect(x: 40.0, y: 50.0, width: 10.0, height: 250.0)
        let rect4=CGRect(x: 60.0, y: 50.0, width: 10.0, height: 250.0)
        let rect5=CGRect(x: 80.0, y: 50.0, width: 10.0, height: 250.0)
        let rect6=CGRect(x: 100.0, y: 50.0, width: 10.0, height: 250.0)
        let rect7=CGRect(x: 120.0, y: 50.0, width: 10.0, height: 250.0)
        let rect8=CGRect(x: 140.0, y: 50.0, width: 10.0, height: 250.0)
        let rect9=CGRect(x: 160.0, y: 50.0, width: 10.0, height: 250.0)
        let rect10=CGRect(x: 180.0, y: 50.0, width: 10.0, height: 250.0)
        let rect11=CGRect(x: 200.0, y: 50.0, width: 10.0, height: 250.0)
        let rect12=CGRect(x: 220.0, y: 50.0, width: 10.0, height: 250.0)
        let rect13=CGRect(x: 240.0, y: 50.0, width: 10.0, height: 250.0)
        let rect14=CGRect(x: 260.0, y: 50.0, width: 10.0, height: 250.0)
        let rect15=CGRect(x: 280.0, y: 50.0, width: 10.0, height: 250.0)
        
        let rect16=CGRect(x: 30.0, y: 310.0, width: 10.0, height: 250.0)
        let rect17=CGRect(x: 50.0, y: 310.0, width: 10.0, height: 250.0)
        let rect18=CGRect(x: 70.0, y: 310.0, width: 10.0, height: 250.0)
        let rect19=CGRect(x: 90.0, y: 310.0, width: 10.0, height: 250.0)
        let rect20=CGRect(x: 110.0, y: 310.0, width: 10.0, height: 250.0)
        let rect21=CGRect(x: 130.0, y: 310.0, width: 10.0, height: 250.0)
        let rect22=CGRect(x: 150.0, y: 310.0, width: 10.0, height: 250.0)
        let rect23=CGRect(x: 170.0, y: 310.0, width: 10.0, height: 250.0)
        let rect24=CGRect(x: 190.0, y: 310.0, width: 10.0, height: 250.0)
        let rect25=CGRect(x: 210.0, y: 310.0, width: 10.0, height: 250.0)
        let rect26=CGRect(x: 230.0, y: 310.0, width: 10.0, height: 250.0)
        let rect27=CGRect(x: 250.0, y: 310.0, width: 10.0, height: 250.0)
        let rect28=CGRect(x: 270.0, y: 310.0, width: 10.0, height: 250.0)
        let rect29=CGRect(x: 290.0, y: 310.0, width: 10.0, height: 250.0)
        
        UIColor.yellow.set()
        UIRectFill(rect0)
        UIColor.green.set()
        UIRectFill(rect1)
        UIColor.red.set()
        UIRectFillUsingBlendMode(rect2, .clear )
        UIRectFillUsingBlendMode(rect3, .color )
        UIRectFillUsingBlendMode(rect4, .colorBurn)
        UIRectFillUsingBlendMode(rect5, .colorDodge)
        UIRectFillUsingBlendMode(rect6, .copy)
        UIRectFillUsingBlendMode(rect7, .darken)
        UIRectFillUsingBlendMode(rect8, .destinationAtop)
        UIRectFillUsingBlendMode(rect9, .destinationIn)
        UIRectFillUsingBlendMode(rect10, .destinationOut)
        UIRectFillUsingBlendMode(rect11, .destinationOver)
        UIRectFillUsingBlendMode(rect12, .difference)
        UIRectFillUsingBlendMode(rect13, .exclusion)
        UIRectFillUsingBlendMode(rect14, .hardLight)
        UIRectFillUsingBlendMode(rect15, .hue)
        UIRectFillUsingBlendMode(rect16, .lighten)
        
        UIRectFillUsingBlendMode(rect17, .luminosity)
        UIRectFillUsingBlendMode(rect18, .multiply)
        UIRectFillUsingBlendMode(rect19, .normal)
        UIRectFillUsingBlendMode(rect20, .overlay)
        UIRectFillUsingBlendMode(rect21, .plusDarker)
        UIRectFillUsingBlendMode(rect22, .plusLighter)
        UIRectFillUsingBlendMode(rect23, .saturation)
        UIRectFillUsingBlendMode(rect24, .screen)
        UIRectFillUsingBlendMode(rect25, .softLight)
        UIRectFillUsingBlendMode(rect26, .sourceAtop)
        UIRectFillUsingBlendMode(rect27, .sourceIn)
        UIRectFillUsingBlendMode(rect28, .sourceOut)
        UIRectFillUsingBlendMode(rect29, .xor)
        
    }
}
