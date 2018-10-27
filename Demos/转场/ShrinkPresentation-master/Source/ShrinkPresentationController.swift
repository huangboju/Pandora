//
//  ShrinkPresentationController.swift
//
//  Copyright © 2015 GuiminChu All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class ShrinkPresentationController: UIPresentationController {
    
    let effectContainerView = UIView()
    let blurView = UIVisualEffectView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        let effect = UIBlurEffect(style: .dark)
        blurView.effect = effect
        
        effectContainerView.alpha = 0.0
    }
    
    override func presentationTransitionWillBegin() {
        effectContainerView.frame = containerView!.bounds
        blurView.frame = containerView!.bounds
        
        effectContainerView.insertSubview(blurView, at: 0)
        
        containerView!.addSubview(presentingViewController.view)
        containerView!.addSubview(effectContainerView)
        
        UIView.animate(withDuration: 0.08, animations: {
            self.effectContainerView.alpha = 1.0
        }) 
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { context in
            
            self.presentingViewController.view.transform = CGAffineTransform.identity.scaledBy(x: 0.92, y: 0.92)
            
            }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        
        if !completed {
            effectContainerView.removeFromSuperview()
        }
        
    }
    
    override func dismissalTransitionWillBegin() {
        
        UIView.animate(withDuration: 0.08, animations: {
            self.presentingViewController.view.transform = CGAffineTransform.identity
        }) 
        
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) -> Void in
            self.effectContainerView.alpha = 0.0
            }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.effectContainerView.removeFromSuperview()
        }
     
        UIApplication.shared.keyWindow?.addSubview(self.presentingViewController.view)
    }
}
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
