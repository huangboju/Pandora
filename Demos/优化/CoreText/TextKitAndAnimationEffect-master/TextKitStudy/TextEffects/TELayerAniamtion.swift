//
//  TELayerAniamtion.swift
//  TextKitStudy
//
//  Created by steven on 3/16/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

typealias completionClosure = (finished:Bool)->()

private let textAnimationGroupKey = "textAniamtionGroupKey"

class TELayerAniamtion: NSObject {
    
    var completionBLK:completionClosure? = nil
    var textLayer:CALayer?
    
    class func textLayerAnimation(layer:CALayer, durationTime duration:NSTimeInterval, delayTime delay:NSTimeInterval,animationClosure effectAnimation:effectAnimatableLayerColsure?, completion finishedClosure:completionClosure?) -> Void
    {
        let animationObjc = TELayerAniamtion()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            
            let olderLayer = animationObjc.animatableLayerCopy(layer)
            var newLayer:CALayer?
            var animationGroup:CAAnimationGroup?
            animationObjc.completionBLK = finishedClosure
            if let effectAnimationClosure = effectAnimation {
                //改变Layer的properties，同时关闭implicit animation
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                newLayer = effectAnimationClosure(layer: layer)
                CATransaction.commit()
            }
            animationGroup = animationObjc.groupAnimationWithLayerChanges(old: olderLayer, new: newLayer!)
            
            if let textAniamtionGroup = animationGroup
            {
                animationObjc.textLayer = layer
                textAniamtionGroup.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                textAniamtionGroup.beginTime = CACurrentMediaTime()
                textAniamtionGroup.duration = duration
                textAniamtionGroup.delegate = animationObjc
                layer.addAnimation(textAniamtionGroup, forKey: textAnimationGroupKey)
            }else
            {
                if let completion = finishedClosure
                {
                    completion(finished: true)
                }
            }
        }
        
        
    }
    
    
    func groupAnimationWithLayerChanges(old olderLayer:CALayer, new newLayer:CALayer) -> CAAnimationGroup?
    {
        var animationGroup:CAAnimationGroup?
        var animations:[CABasicAnimation] = [CABasicAnimation]()
        
        if !CGPointEqualToPoint(olderLayer.position, newLayer.position) {
            let basicAnimation = CABasicAnimation()
            basicAnimation.fromValue =  NSValue(CGPoint: olderLayer.position)
            basicAnimation.toValue = NSValue(CGPoint:newLayer.position)
            basicAnimation.keyPath = "position"
            animations.append(basicAnimation)
        }
        
        if !CATransform3DEqualToTransform(olderLayer.transform, newLayer.transform) {
            let basicAnimation = CABasicAnimation(keyPath: "transform")
            basicAnimation.fromValue = NSValue(CATransform3D: olderLayer.transform)
            basicAnimation.toValue = NSValue(CATransform3D: newLayer.transform)
            animations.append(basicAnimation)
        }
        
        if !CGRectEqualToRect(olderLayer.frame, newLayer.frame)
        {
            let basicAnimation = CABasicAnimation(keyPath: "frame")
            basicAnimation.fromValue = NSValue(CGRect: olderLayer.frame)
            basicAnimation.toValue = NSValue(CGRect: newLayer.frame)
            animations.append(basicAnimation)
        }
        
        if !CGRectEqualToRect(olderLayer.bounds, olderLayer.bounds)
        {
            let basicAnimation = CABasicAnimation(keyPath: "bounds")
            basicAnimation.fromValue = NSValue(CGRect: olderLayer.bounds)
            basicAnimation.toValue = NSValue(CGRect: newLayer.bounds)
            animations.append(basicAnimation)
        }
        
        if olderLayer.opacity != newLayer.opacity
        {
            let basicAnimation = CABasicAnimation(keyPath: "opacity")
            basicAnimation.fromValue = olderLayer.opacity
            basicAnimation.toValue = newLayer.opacity
            animations.append(basicAnimation)

        }
        
        if animations.count > 0 {
            animationGroup = CAAnimationGroup()
            animationGroup!.animations = animations
        }
        return animationGroup
    }
    
    
    func animatableLayerCopy(layer:CALayer)->CALayer
    {
        let layerCopy = CALayer()
        layerCopy.opacity = layer.opacity
        layerCopy.bounds = layer.bounds
        layerCopy.transform = layer.transform
        layerCopy.position = layer.position
        return layerCopy
    }
    
    
    //MARK:animationDelegate
    
    
    
}

extension TELayerAniamtion: CAAnimationDelegate {
    func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if let tempCompletionBLK = self.completionBLK
        {
            self.textLayer?.removeAnimationForKey(textAnimationGroupKey)
            tempCompletionBLK(finished: flag)
        }
    }
}
