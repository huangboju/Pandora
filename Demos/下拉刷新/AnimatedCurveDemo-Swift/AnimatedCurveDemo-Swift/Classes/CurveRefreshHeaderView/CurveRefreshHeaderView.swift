//
//  CurveRefreshHeaderView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

typealias RefreshingBlock = ()->()
class CurveRefreshHeaderView: UIView {

    /// 需要滑动多大距离才能松开
    var pullDistance: CGFloat = 0.0
    /// 刷新执行的具体操作    
    var refreshingBlock: RefreshingBlock?
    
    fileprivate var progress: CGFloat = 0.0 {
        didSet{
            if !_associatedScrollView.isTracking {
                labelView.loading = true
            }
            
            if !willEnd && !loading {
                curveView.progress = progress
                labelView.progress = progress
            }
            
            center = CGPoint(x: center.x, y: -fabs(_associatedScrollView.contentOffset.y + originOffset)/2)
            
            let diff = fabs(_associatedScrollView.contentOffset.y + originOffset) - pullDistance + 10
            
            if diff > 0 {
                if !_associatedScrollView.isTracking {
                    if !notTracking {
                        notTracking = true
                        loading = true
                        
                        //旋转...
                        curveView.startInfiniteRotation()
                        UIView.animate(withDuration: 0.3, animations: { [weak self] in
                            if let strongSelf = self {
                                strongSelf._associatedScrollView.contentInset = UIEdgeInsetsMake(strongSelf.pullDistance + strongSelf.originOffset, 0, 0, 0)
                            }
                            }, completion: { [weak self] (_) in
                                if let strongSelf = self {
                                    strongSelf.refreshingBlock?()
                                }
                        })

                    }
                }
                
                if (!loading) {
                    curveView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) * (diff*2/180));
                }
                
            }else{
                labelView.loading = false
                curveView.transform = CGAffineTransform.identity
            }
        }
    }
    
    fileprivate var _associatedScrollView: UIScrollView!
    fileprivate var labelView: LabelView!
    fileprivate var curveView: CurveView!
    fileprivate var originOffset: CGFloat!
    fileprivate var willEnd: Bool = false
    fileprivate var notTracking: Bool = false
    fileprivate var loading: Bool = false
    
    init(associatedScrollView: UIScrollView, withNavigationBar: Bool) {
        super.init(frame: CGRect(x: associatedScrollView.frame.width/2-200/2, y: -100, width: 200, height: 100))
        if withNavigationBar {
            originOffset = 64.0
        }else{
            originOffset = 0.0
        }
        _associatedScrollView = associatedScrollView
        setUp()
        _associatedScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        _associatedScrollView.insertSubview(self, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        _associatedScrollView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    func triggerPulling() {
        _associatedScrollView.setContentOffset(CGPoint(x: 0, y: -pullDistance-originOffset), animated: true)
    }
    
    func stopRefreshing() {
        willEnd = true
        progress = 1.0
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions(), animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.alpha = 0.0
                strongSelf._associatedScrollView.contentInset = UIEdgeInsetsMake(strongSelf.originOffset+0.1, 0, 0, 0)
                
            }
            }) { [weak self] (_) -> Void in
                if let strongSelf = self {
                    strongSelf.alpha = 1.0
                    strongSelf.willEnd = false
                    strongSelf.notTracking = false
                    strongSelf.loading = false
                    strongSelf.labelView.loading = false
                    strongSelf.curveView.stopInfiniteRotation()
                }
        }
    }
    
}

extension CurveRefreshHeaderView {
    fileprivate func setUp() {
        pullDistance = 99;
        curveView = CurveView(frame: CGRect(x: 20, y: 0, width: 30, height: frame.height))
        insertSubview(curveView, at: 0)
        
        labelView = LabelView(frame: CGRect(x: curveView.frame.origin.x + curveView.frame.width + 10.0, y: curveView.frame.origin.y, width: 150, height: curveView.frame.height))
        insertSubview(labelView, aboveSubview: curveView)
    }
    
}

// MARK : KVO

extension CurveRefreshHeaderView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            if let change = change {
                if let contentOffset = (change[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue {
                    if contentOffset.y + originOffset <= 0 {
                        progress = max(0.0, min(fabs(contentOffset.y+originOffset)/pullDistance, 1.0))
                    }
                }
            }
        }
    }
}

extension UIView {
    func startInfiniteRotation() {
        transform = CGAffineTransform.identity
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI * 2.0
        rotationAnimation.duration = 0.5
        rotationAnimation.autoreverses = false
        rotationAnimation.repeatCount = HUGE
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        layer.add(rotationAnimation, forKey: "rotationAnimation")
    }

    func stopInfiniteRotation() {
        layer.removeAllAnimations()
    }
}
