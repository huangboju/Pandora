//
//  CurveRefreshFooterView.swift
//  AnimatedCurveDemo-Swift
//
//  Created by Kitten Yang on 1/18/16.
//  Copyright © 2016 Kitten Yang. All rights reserved.
//

import UIKit

class CurveRefreshFooterView: UIView {

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
                curveView.progress =  progress
                labelView.progress =  progress
            }
            
            let diff =  _associatedScrollView.contentOffset.y - (_associatedScrollView.contentSize.height - _associatedScrollView.frame.height) - pullDistance + 10.0;
            
            if diff > 0 {
                if !_associatedScrollView.isTracking && !isHidden {
                    if !notTracking {
                        notTracking = true
                        loading = true
                        
                        //旋转...
                        curveView.startInfiniteRotation()
                        UIView.animate(withDuration: 0.3, animations: { [weak self] () -> Void in
                            if let strongSelf = self {
                                strongSelf._associatedScrollView.contentInset = UIEdgeInsetsMake(strongSelf.originOffset, 0, strongSelf.pullDistance, 0)
                            }
                            }, completion: { [weak self] (finished) -> Void in
                                if let strongSelf = self{
                                    strongSelf.refreshingBlock?()
                                }
                        })
                    }
                    
                }
                
                if (!loading) {
                    curveView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI) * (diff*2/180))
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
    fileprivate var contentSize: CGSize?
    fileprivate var originOffset: CGFloat!
    fileprivate var willEnd: Bool = false
    fileprivate var notTracking: Bool = false
    fileprivate var loading: Bool = false
    
    init(associatedScrollView: UIScrollView, withNavigationBar: Bool) {
        super.init(frame: CGRect(x: associatedScrollView.frame.width/2-200/2, y: associatedScrollView.frame.height, width: 200, height: 100))
        if withNavigationBar {
            originOffset = 64.0
        }else{
            originOffset = 0.0
        }
        _associatedScrollView = associatedScrollView
        setUp()
        _associatedScrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        _associatedScrollView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
        isHidden = true
        _associatedScrollView.insertSubview(self, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        _associatedScrollView.removeObserver(self, forKeyPath: "contentOffset")
        _associatedScrollView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    func stopRefreshing() {
        willEnd = true
        progress = 1.0
        UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions(), animations: { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.alpha = 0.0
                strongSelf._associatedScrollView.contentInset = UIEdgeInsetsMake(strongSelf.originOffset, 0, 0, 0)
            }

            }) { [weak self] (finished) -> Void in
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


extension CurveRefreshFooterView {
    fileprivate func setUp() {
        pullDistance = 99;
        curveView = CurveView(frame: CGRect(x: 20, y: 0, width: 30, height: frame.height))
        insertSubview(curveView, at: 0)
        labelView = LabelView(frame: CGRect(x: curveView.frame.origin.x + curveView.frame.width + 10.0, y: curveView.frame.origin.y, width: 150, height: curveView.frame.height))
        labelView.state = .up
        insertSubview(labelView, aboveSubview: curveView)
    }
}

// MARK : KVO

extension CurveRefreshFooterView {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            if let change = change {
                contentSize = (change[NSKeyValueChangeKey.newKey] as AnyObject).cgSizeValue
                if let contentSize = contentSize {
                    if contentSize.height > 0.0 {
                        isHidden = false
                    }
                    frame = CGRect(x: _associatedScrollView.frame.width/2-200/2, y: contentSize.height, width: 200, height: 100);
                }
            }
        }

        if keyPath == "contentOffset" {
            if let change = change {
                let contentOffset = (change[NSKeyValueChangeKey.newKey] as AnyObject).cgPointValue
                if let contentOffset = contentOffset, let contentSize = contentSize {
                    if contentOffset.y >= (contentSize.height - _associatedScrollView.frame.height) {
                        center = CGPoint(x: center.x, y: contentSize.height + (contentOffset.y - (contentSize.height - _associatedScrollView.frame.height))/2);

                        progress = max(0.0, min((contentOffset.y - (contentSize.height - _associatedScrollView.frame.height)) / pullDistance, 1.0))

                    }
                }
            }
        }
    }
}
