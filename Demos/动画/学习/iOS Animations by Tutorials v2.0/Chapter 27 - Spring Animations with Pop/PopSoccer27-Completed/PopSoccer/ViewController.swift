/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var goal: UIImageView!
    @IBOutlet var ball: UIImageView!
    
    var playingRect: CGRect!
    var observeBounds = true
    
    weak var currentMessage: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup ball interaction
        ball.isUserInteractionEnabled = true
        ball.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(didPan))
        )
        
        resetBall()
        
        ball.addObserver(self, forKeyPath: "alpha", options: .new, context: nil)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ball.alpha = 0.0
    }
    
    func fadeInView(view: UIView) {
        let fade = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        fade?.fromValue = 0.0
        fade?.toValue = 1.0
        fade?.duration = 1.0
        view.pop_add(fade, forKey: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fadeInView(view: ball)
        animateMessage(text: "Game on!")
    }
    
    @objc
    func didPan(_ pan: UIPanGestureRecognizer) {
        print("Panning...")
        
        switch pan.state {
        case .changed:
            ball.center = pan.location(in: view)
        case .ended:
            let velocity = pan.velocity(in: view)
            
            guard let animation = POPDecayAnimation(propertyNamed:
                kPOPViewCenter) else { return }
            animation.fromValue = NSValue(cgPoint: ball.center)
            animation.velocity = NSValue(cgPoint: velocity)
            animation.delegate = self
            
            ball.pop_add(animation, forKey: nil)
        case .began:
            ball.pop_removeAllAnimations()
            
        default: break
        }
        
        print(pan.velocity(in: view))
        
    }
    
    func resetBall() {
        //set ball at random position on the field
        let randomX = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
        ball.center = CGPoint(x: randomX * view.frame.size.width, y: view.frame.size.height * 0.7)
        fadeInView(view: ball)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as? UIImageView) === ball && keyPath == "alpha" {
            print(ball.alpha)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object,
                                         change: change, context: context)
        }
    }
    
    func animateMessage(text: String) {
        let offScreenFrame = CGRect(x: -view.frame.size.width,
                                    y: 200.0, width: view.frame.size.width, height: 50.0)
        let label = UILabel(frame: offScreenFrame)
        
        label.font = UIFont(name: "ArialRoundedMTBold", size: 52.0)
        label.textAlignment = .center
        label.textColor = UIColor.yellow
        label.text = text
        label.shadowColor = UIColor.darkGray
        label.shadowOffset = CGSize(width: 2.0, height: 2.0)
        
        currentMessage = label
        view.addSubview(label)
        
        guard let bounce = POPSpringAnimation(propertyNamed: kPOPViewCenter) else { return }
        bounce.fromValue = NSValue(cgPoint: label.center)
        bounce.toValue = NSValue(cgPoint: view.center)
        
        bounce.springSpeed = 15.0
        bounce.springBounciness = 20.0
        
        bounce.completionBlock = { animation, finished in
            guard let fadeOut = POPBasicAnimation(propertyNamed: kPOPViewAlpha) else { return }
            fadeOut.toValue = 0.0
            fadeOut.duration = 0.5
            fadeOut.completionBlock = {_, _ in
                label.removeFromSuperview()
            }
            label.pop_add(fadeOut, forKey: nil)
        }
        
        label.pop_add(bounce, forKey: "bounce")
    }
    
    @objc
    func didTap(_ tap: UITapGestureRecognizer) {
        if let label = currentMessage {
            if let bounce = label.pop_animation(forKey: "bounce") as? POPSpringAnimation {
                bounce.toValue = NSValue(cgPoint: tap.location(in: view))
            }
        }
    }
}

extension ViewController: POPAnimationDelegate {
    func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
        print("animation did stop")
        
        if finished {
            resetBall()
        }
    }
    
    func pop_animationDidApply(_ anim: POPAnimation!) {
        if goal.frame.contains(ball.center) {
            ball.pop_removeAllAnimations()
            print("GOAL")
            
            resetBall()
            return
        }
    }
}

