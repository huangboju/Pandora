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
  
  var waveAnimation: EAAnimationDelayed?
    
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

    UIView.animateWithDuration(0.33, delay: 0.0, options: [.Repeat, .Autoreverse, .CurveEaseOut], animations: {
        self.dot.transform = CATransform3DMakeScale(1.4, 15, 1.0)
    }, completion: nil)
    
    UIView.animateWithDuration(0.33, delay: 0.33, options: [.Repeat, .Autoreverse, .CurveEaseOut], animations: {
        self.dot.opacity = 0.2
    }, completion: nil)

    UIView.animateWithDuration(0.66, delay: 0.28, options: [.Repeat, .Autoreverse, .CurveEaseInOut], animations: {
        self.dot.backgroundColor = UIColor.cyanColor().CGColor
    }, completion: nil)

    waveAnimation = UIView.animateAndChainWithDuration(0.5,
      delay: 0.0, options: .CurveEaseInOut, animations: {
        self.replicator.instanceTransform = CATransform3DConcat(
          CATransform3DMakeTranslation(-self.dotOffset, 0.0, 0.0),
          CATransform3DMakeRotation(0.01, 0.0, 0.0, 1.0)
        )
      }, completion: nil)
      .animateWithDuration(0.5, delay: 0.0, options: [.CurveEaseInOut, .Repeat], animations: {
        self.replicator.instanceTransform = CATransform3DConcat(
          CATransform3DMakeTranslation(-self.dotOffset, 0.0, 0.0),
          CATransform3DMakeRotation(-0.01, 0.0, 0.0, 1.0)
        )
      }, completion: nil)

    
  }
  
  func endSpeaking() {
    
    waveAnimation?.cancelAnimationChain {
      self.dot.removeAllAnimations()
      
      self.dot.transform = CATransform3DIdentity
      self.dot.opacity = 1.0
      self.dot.backgroundColor = UIColor.lightGrayColor().CGColor

      self.replicator.instanceTransform =
        CATransform3DMakeTranslation(-self.dotOffset, 0.0, 0.0)

      self.speakButton.hidden = false
      self.meterLabel.text = "Hold to speak"
    }
  }
}