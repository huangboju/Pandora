
//
//  ParallaxHeaderView.swift
//  ParallaxHeaderView
//
//  Created by wl on 15/11/3.
//  Copyright © 2015年 wl. All rights reserved.
//

import UIKit

protocol ParallaxHeaderViewDelegate: class {
    func LockScorllView(_ maxOffsetY: CGFloat)
    func autoAdjustNavigationBarAplha(_ aplha: CGFloat)
}

extension ParallaxHeaderViewDelegate where Self : UITableViewController {
    func LockScorllView(_ maxOffsetY: CGFloat) {
        tableView.contentOffset.y = maxOffsetY
    }

    func autoAdjustNavigationBarAplha(_ aplha: CGFloat) {
        navigationController?.navigationBar.setMyBackgroundColorAlpha(aplha)
    }
}

enum ParallaxHeaderViewStyle {
    case fill(UIImage)
    case thumb
}

class ParallaxHeaderView: UIView {

    var contentView: UIView
    var containerView = UIView()
    /// 最大的下拉限度（因为是下拉所以总是为负数），超过(小于)这个值，下拉将不会有效果
    var maxOffsetY: CGFloat
    /// 是否需要自动调节导航栏的透明度
    var autoAdjustAplha = true
    
    weak var delegate: ParallaxHeaderViewDelegate!

    /// 模糊效果的view
    fileprivate var blurView: UIVisualEffectView?
    fileprivate let defaultBlurViewAlpha: CGFloat = 0.5
    fileprivate let style: ParallaxHeaderViewStyle

    fileprivate let originY: CGFloat = -64

     // MARK: - 初始化方法
    init(style: ParallaxHeaderViewStyle, contentView: UIView, headerViewSize: CGSize, maxOffsetY: CGFloat, delegate: ParallaxHeaderViewDelegate) {

        self.contentView = contentView
        self.maxOffsetY = min(maxOffsetY, -maxOffsetY)
        self.delegate = delegate
        self.style = style

        super.init(frame: CGRect(origin: .zero, size: headerViewSize))
        //这里是自动布局的设置，大概意思就是subView与它的superView拥有一样的frame
        contentView.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        containerView.frame = bounds
        containerView.addSubview(contentView)
        containerView.clipsToBounds = true
        addSubview(containerView)

        setupStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupStyle() {
        switch style {
        case .fill(_):
            autoAdjustAplha = true
        case .thumb:
            autoAdjustAplha = false
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.alpha = defaultBlurViewAlpha
            blurView.frame = self.contentView.frame
            blurView.autoresizingMask = contentView.autoresizingMask

            self.blurView = blurView
            containerView.addSubview(blurView)
        }
        
    }

     // MARK: - 其他方法
    func layoutHeaderViewWhenScroll(_ offset: CGPoint) {
        let delta = offset.y

        if delta < maxOffsetY {
            delegate.LockScorllView(maxOffsetY)
        } else if delta < 0 {
            var rect = CGRect(origin: .zero, size: bounds.size)
            rect.origin.y = delta
            rect.size.height -= delta
            containerView.frame = rect
        }

        switch style {
        case .fill(_):
            layoutDefaultViewWhenScroll(delta)
        case .thumb:
            layoutThumbViewWhenScroll(delta)
        }

        if autoAdjustAplha {
            let alpha = CGFloat((-originY + delta) / (frame.height))
            delegate.autoAdjustNavigationBarAplha(alpha)
        }
    }

    fileprivate func layoutDefaultViewWhenScroll(_ delta: CGFloat) {
        // do nothing
    }

    fileprivate func layoutThumbViewWhenScroll(_ delta: CGFloat) {
        if delta > 0 {
            containerView.frame.origin.y = delta
        }

        if let blurView = blurView, delta < 0 {
            blurView.alpha = defaultBlurViewAlpha - CGFloat(delta / maxOffsetY)  < 0 ? 0 : defaultBlurViewAlpha - CGFloat(delta / maxOffsetY)
        }
    }
}


extension UIBezierPath {
    class func pathFromBitmap() -> UIBezierPath? {
        let map: [[UInt8]] = [
            [0,0,0,0,0,0,1,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,1,0,0,1,0,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
            [0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
            [0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
            [0,0,0,0,1,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1],
            [0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1],
            [0,1,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1],
            [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,0],
            [0,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0],
            [0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0],
            [0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1,1,0,0,0,0],
            [0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0],
            ]
        
        let path = UIBezierPath()
        for i in 0..<map.count {
            for j in 0..<map.first!.count {
                if map[i][j] != 0 {
                    let pathTem = UIBezierPath(rect: CGRect(x: j, y: i, width: 1, height: 1))
                    path.append(pathTem)
                }
            }
        }
        return path
    }
}

class DogView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        startAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        let path = UIBezierPath.pathFromBitmap()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.lineWidth = 1.0
        shapeLayer.path = path?.cgPath
        self.layer.addSublayer(shapeLayer)
        shapeLayer.transform = CATransform3DMakeScale(10, 10, 1)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 20
        animation.fromValue = 0
        animation.toValue = 1
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
}
