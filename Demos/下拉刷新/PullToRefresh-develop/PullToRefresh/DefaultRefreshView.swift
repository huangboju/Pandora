//
//  DefaultRefreshView.swift
//  PullToRefreshDemo
//
//  Created by Serhii Butenko on 26/7/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

class DefaultRefreshView: UIView {
    
    fileprivate(set) lazy var activityIndicator: UIActivityIndicatorView! = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    override func layoutSubviews() {
        centerActivityIndicator()
        setupFrame(in: superview)
        
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        centerActivityIndicator()
        setupFrame(in: superview)
    }
}

private extension DefaultRefreshView {
    
    func setupFrame(in newSuperview: UIView?) {
        guard let superview = newSuperview else { return }
        
        frame = CGRect(x: frame.minX, y: frame.minY, width: superview.frame.width, height: frame.height)
    }
    
    func centerActivityIndicator() {
        activityIndicator.center = convert(center, from: superview)
    }
}
