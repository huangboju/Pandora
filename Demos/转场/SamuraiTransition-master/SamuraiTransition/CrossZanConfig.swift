//
//  CrossZanConfig.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/12/11.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class CrossZanConfig: ZanLineProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let oneCrossLayer = self.zanLineLayer(from: CGPoint(x: self.zanPoint.x, y: self.containerFrame.minY), end: CGPoint(x: self.zanPoint.x, y: self.containerFrame.maxY), width: self.lineWidth, color: self.lineColor)
        let otherCrossLayer = self.zanLineLayer(from: CGPoint(x: self.containerFrame.minX, y: self.zanPoint.y), end: CGPoint(x: self.containerFrame.maxX, y: self.zanPoint.y), width: self.lineWidth, color: self.lineColor)
        return [oneCrossLayer, otherCrossLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        
        let leftTopRect = CGRect(x: self.containerFrame.minX, y: self.containerFrame.minY, width: self.zanPoint.x, height: self.zanPoint.y)
        let rightTopRect = CGRect(x: leftTopRect.width, y: self.containerFrame.minY, width: self.containerFrame.width - leftTopRect.width, height: leftTopRect.height)
        let leftBottomRect = CGRect(x: leftTopRect.minX, y: leftTopRect.maxY, width: leftTopRect.width, height: self.containerFrame.height - leftTopRect.height)
        let rightBottomRect = CGRect(x: leftTopRect.maxX, y: rightTopRect.maxY, width: rightTopRect.width, height: leftBottomRect.height)
        
        let leftTopConfig = ZanViewConfig(inSideFrame: leftTopRect, outSideFrame: leftTopRect.offsetBy(dx: -leftTopRect.width, dy: -leftTopRect.height))
        let rightTopConfig = ZanViewConfig(inSideFrame: rightTopRect, outSideFrame: rightTopRect.offsetBy(dx: rightTopRect.width, dy: -rightTopRect.height))
        let leftBottomConfig = ZanViewConfig(inSideFrame: leftBottomRect, outSideFrame: leftBottomRect.offsetBy(dx: -leftBottomRect.width, dy: leftBottomRect.height))
        let rightBottomConfig = ZanViewConfig(inSideFrame: rightBottomRect, outSideFrame: rightBottomRect.offsetBy(dx: rightBottomRect.width, dy: rightBottomRect.height))
        
        return [leftTopConfig, rightTopConfig, leftBottomConfig, rightBottomConfig]
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
    
}
