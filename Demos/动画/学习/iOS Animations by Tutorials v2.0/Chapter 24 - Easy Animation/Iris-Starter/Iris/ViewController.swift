//
//  ViewController.swift
//  Siri
//
//  Created by Marin Todorov on 6/23/15.
//  Copyright (c) 2015 Underplot ltd. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  @IBOutlet weak var meterLabel: UILabel!
  @IBOutlet weak var speakButton: UIButton!
  
  let replicator = CAReplicatorLayer()
  let dot = CALayer()

  let monitor = MicMonitor()
  let assistant = Assistant()

  let dotLength: CGFloat = 6.0
  let dotOffset: CGFloat = 8.0

  var lastTransformScale: CGFloat = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    replicator.frame = view.bounds
    view.layer.addSublayer(replicator)

    dot.frame = CGRect(
      x: replicator.frame.size.width - dotLength,
      y: replicator.position.y,
      width: dotLength, height: dotLength)
    dot.backgroundColor = UIColor.lightGrayColor().CGColor
    dot.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
    dot.borderWidth = 0.5
    dot.cornerRadius = 1.5

    replicator.addSublayer(dot)
    
    replicator.instanceCount = Int(view.frame.size.width / dotOffset)
    replicator.instanceTransform = CATransform3DMakeTranslation(-dotOffset, 0.0, 0.0)
    
//    let move = CABasicAnimation(keyPath: "position.y")
//    move.fromValue = dot.position.y
//    move.toValue = dot.position.y - 50.0
//    move.duration = 1.0
//    move.repeatCount = 10
//    dot.addAnimation(move, forKey: nil)

    replicator.instanceDelay = 0.02
  }
  
  @IBAction func actionStartMonitoring(sender: AnyObject) {
    dot.backgroundColor = UIColor.greenColor().CGColor
    
    monitor.startMonitoringWithHandler {level in
      self.meterLabel.text = String(format: "%.2f db", level)
      
      let scaleFactor = max(0.2, CGFloat(level) + 50) / 2
      
      let scale = CABasicAnimation(keyPath: "transform.scale.y")
      scale.fromValue = self.lastTransformScale
      scale.toValue = scaleFactor
      scale.duration = 0.1
      scale.removedOnCompletion = false
      scale.fillMode = kCAFillModeForwards
      self.dot.addAnimation(scale, forKey: nil)

      self.lastTransformScale = scaleFactor
    }

  }
  
  @IBAction func actionEndMonitoring(sender: AnyObject) {

    monitor.stopMonitoring()
    
    //challenges
    let scale = CABasicAnimation(keyPath: "transform.scale.y")
    scale.fromValue = lastTransformScale
    scale.toValue = 1.0
    scale.duration = 0.2
    scale.removedOnCompletion = false
    scale.fillMode = kCAFillModeForwards
    dot.addAnimation(scale, forKey: nil)
    
    dot.backgroundColor = UIColor.magentaColor().CGColor
    
    let tint = CABasicAnimation(keyPath: "backgroundColor")
    tint.fromValue = UIColor.greenColor().CGColor
    tint.toValue = UIColor.magentaColor().CGColor
    tint.duration = 1.2
    tint.fillMode = kCAFillModeBackwards
    dot.addAnimation(tint, forKey: nil)
    
    //speak after 1 second
    delay(seconds: 1.0, completion: {
      self.startSpeaking()
    })
  
  }
  
  func startSpeaking() {
    print("speak back")
    
    meterLabel.text = assistant.randomAnswer()
    assistant.speak(meterLabel.text!, completion: endSpeaking)
    speakButton.hidden = true
    
    let scale = CABasicAnimation(keyPath: "transform")
    scale.fromValue = NSValue(CATransform3D: CATransform3DIdentity)
    scale.toValue = NSValue(CATransform3D:
      CATransform3DMakeScale(1.4, 15, 1.0))
    scale.duration = 0.33
    scale.repeatCount = Float.infinity
    scale.autoreverses = true
    scale.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseOut)
    dot.addAnimation(scale, forKey: "dotScale")

    let fade = CABasicAnimation(keyPath: "opacity")
    fade.fromValue = 1.0
    fade.toValue = 0.2
    fade.duration = 0.33
    fade.beginTime = CACurrentMediaTime() + 0.33
    fade.repeatCount = Float.infinity
    fade.autoreverses = true
    fade.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseOut)
    dot.addAnimation(fade, forKey: "dotOpacity")

    let tint = CABasicAnimation(keyPath: "backgroundColor")
    tint.fromValue = UIColor.magentaColor().CGColor
    tint.toValue = UIColor.cyanColor().CGColor
    tint.duration = 0.66
    tint.beginTime = CACurrentMediaTime() + 0.28
    tint.fillMode = kCAFillModeBackwards
    tint.repeatCount = Float.infinity
    tint.autoreverses = true
    tint.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseInEaseOut)
    dot.addAnimation(tint, forKey: "dotColor")

    let initialRotation = CABasicAnimation(keyPath:
      "instanceTransform.rotation")
    initialRotation.fromValue = 0.0
    initialRotation.toValue   = 0.01
    initialRotation.duration = 0.33
    initialRotation.removedOnCompletion = false
    initialRotation.fillMode = kCAFillModeForwards
    initialRotation.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseOut)
    replicator.addAnimation(initialRotation, forKey:
      "initialRotation")

    let rotation = CABasicAnimation(keyPath:
      "instanceTransform.rotation")
    rotation.fromValue = 0.01
    rotation.toValue   = -0.01
    rotation.duration = 0.99
    rotation.beginTime = CACurrentMediaTime() + 0.33
    rotation.repeatCount = Float.infinity
    rotation.autoreverses = true
    rotation.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseInEaseOut)
    replicator.addAnimation(rotation, forKey: "replicatorRotation")

  }
  
  func endSpeaking() {
    replicator.removeAllAnimations()
    
    let scale = CABasicAnimation(keyPath: "transform")
    scale.toValue = NSValue(CATransform3D: CATransform3DIdentity)
    scale.duration = 0.33
    scale.removedOnCompletion = false
    scale.fillMode = kCAFillModeForwards
    dot.addAnimation(scale, forKey: nil)

    dot.removeAnimationForKey("dotColor")
    dot.removeAnimationForKey("dotOpacity")
    dot.backgroundColor = UIColor.lightGrayColor().CGColor
    
    speakButton.hidden = false
  }
}