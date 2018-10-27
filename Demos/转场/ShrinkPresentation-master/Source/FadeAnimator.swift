//
//  FadeAnimator.swift
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

class FadeAnimator: NSObject {
    
    enum Mode {
        case presentation
        case dismissal
    }
    
    fileprivate let duration = 0.3
    fileprivate let mode: Mode
    
    init(_ mode: Mode) {
        self.mode = mode
    }
    
    func presentationAnimate(_ context: UIViewControllerContextTransitioning) {
        let menuViewController = context.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let menuView = menuViewController.view
        context.containerView.addSubview(menuView!)
        
        menuView?.alpha = 0.0
        
        UIView.animate(withDuration: duration,
            animations: {
                menuView?.alpha = 1.0
            }, completion: { _ in
                context.completeTransition(true)
        })
    }
    
    func dismissalAnimate(_ context: UIViewControllerContextTransitioning) {
        let menuViewController = context.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let menuView = menuViewController.view
        
        UIView.animate(withDuration: duration,
            animations: {
                menuView?.alpha = 0.0
            }, completion: { _ in
                context.completeTransition(true)
        })        
    }
}

extension FadeAnimator: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        switch mode {
        case .presentation:
            presentationAnimate(transitionContext)
        case .dismissal:
            dismissalAnimate(transitionContext)
        }
    }
}
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
