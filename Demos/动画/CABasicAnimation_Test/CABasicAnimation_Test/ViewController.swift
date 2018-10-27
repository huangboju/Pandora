//
//  ViewController.swift
//  CABasicAnimation_Test
//
//  Created by 伯驹 黄 on 16/2/2.
//  Copyright © 2016年 伯驹 黄. All rights reserved.
//

let IsIOS7orAbove = UIDevice.current.systemVersion >= "8"
let kYoffset: CGFloat = IsIOS7orAbove ? 64 : 0

import UIKit

class ViewController: UIViewController {
    var scaleLayer: CALayer!
    var moveLayer: CALayer!
    var rotateLayer: CALayer!
    var groupLayer: CALayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        initScaleLayer()
        initMoveLayer()
        initRotateLayer()
        initGroupLayer()
    }

    func initScaleLayer() {
        scaleLayer = CALayer()
        scaleLayer.backgroundColor = UIColor.blue.cgColor
        scaleLayer.frame = CGRect(x: 60, y: 20 + kYoffset, width: 50, height: 50)
        scaleLayer.cornerRadius = 10
        scaleLayer.contentsScale = UIScreen.main.scale
        scaleLayer.allowsEdgeAntialiasing = true
        scaleLayer.contentsGravity = kCAGravityResizeAspect
        scaleLayer.contents = UIImage(named: "msg_58.png")?.cgImage
        view.layer.addSublayer(scaleLayer)

        let testView = UIView(frame: CGRect(x: 60, y: 20 + kYoffset, width: 50, height: 50))
        view.addSubview(testView)
        testView.backgroundColor = .gray
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSNumber(value: 1.0)
        scaleAnimation.toValue = NSNumber(value: 3.5)
        scaleAnimation.autoreverses = true
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.repeatCount = MAXFLOAT
        scaleAnimation.duration = 0.8
        //        scaleLayer.addAnimation(scaleAnimation, forKey: "scaleAnimation")
        testView.layer.add(scaleAnimation, forKey: "scaleAnimation")
    }

    func initMoveLayer() {
        moveLayer = CALayer()
        moveLayer.backgroundColor = UIColor.red.cgColor

        moveLayer.frame = CGRect(x: 60, y: 130 + kYoffset, width: 500, height: 50)
        moveLayer.cornerRadius = 10
        view.layer.addSublayer(moveLayer)

        let moveAnimation = CABasicAnimation(keyPath: "position")
        moveAnimation.fromValue = NSValue(cgPoint: CGPoint(x: 350, y: moveLayer.position.y))
        moveAnimation.toValue = NSValue(cgPoint: CGPoint(x: -175, y: moveLayer.position.y))
        //        moveAnimation.autoreverses = true
        moveAnimation.fillMode = kCAFillModeForwards
        moveAnimation.repeatDuration = 10
        moveAnimation.duration = 2

        moveLayer.add(moveAnimation, forKey: "moveAnimation")
    }

    func initRotateLayer() {
        rotateLayer = CALayer()
        rotateLayer.backgroundColor = UIColor.green.cgColor
        rotateLayer.frame = CGRect(x: 60, y: 240 + kYoffset, width: 50, height: 50)
        rotateLayer.cornerRadius = 10
        view.layer.addSublayer(rotateLayer)

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.y")
        rotateAnimation.fromValue = NSNumber(value: 0.0)
        rotateAnimation.toValue = NSNumber(value: 2.0 * M_PI)
        rotateAnimation.autoreverses = true
        rotateAnimation.fillMode = kCAFillModeForwards
        rotateAnimation.repeatCount = MAXFLOAT
        rotateAnimation.duration = 2

        rotateLayer.add(rotateAnimation, forKey: "rotateAnimation")
    }

    func initGroupLayer() {
        groupLayer = CALayer()
        groupLayer.frame = CGRect(x: 60, y: 440 + kYoffset, width: 50, height: 50)
        groupLayer.cornerRadius = 10
        groupLayer.backgroundColor = UIColor.purple.cgColor
        view.layer.addSublayer(groupLayer)

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = NSNumber(value: 1.0)
        scaleAnimation.toValue = NSNumber(value: 1.5)
        scaleAnimation.autoreverses = true
        scaleAnimation.repeatCount = MAXFLOAT
        scaleAnimation.duration = 0.8

        let moveAnimaiton = CABasicAnimation(keyPath: "position")
        moveAnimaiton.fromValue = NSValue(cgPoint: groupLayer.position)
        moveAnimaiton.toValue = NSValue(cgPoint: CGPoint(x: 240, y: groupLayer.position.y))
        moveAnimaiton.autoreverses = true
        moveAnimaiton.repeatCount = MAXFLOAT
        moveAnimaiton.duration = 2

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.x")
        rotateAnimation.fromValue = NSNumber(value: 0.0)
        rotateAnimation.toValue = NSNumber(value: 6.0 * Float(M_PI))
        rotateAnimation.autoreverses = true
        rotateAnimation.repeatCount = MAXFLOAT
        rotateAnimation.duration = 2

        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 2
        groupAnimation.autoreverses = true
        groupAnimation.animations = [moveAnimaiton, scaleAnimation, rotateAnimation]
        groupAnimation.repeatCount = MAXFLOAT

        groupLayer.add(groupAnimation, forKey: "groupAnimation")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
