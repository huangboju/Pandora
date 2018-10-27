//
//  TabmanScrollingButtonBar.swift
//  Tabman
//
//  Created by Merrick Sapsford on 17/02/2017.
//  Copyright © 2017 Merrick Sapsford. All rights reserved.
//

import UIKit
import PureLayout
import Pageboy

/// A bar with scrolling buttons and line indicator.
///
/// Akin to Android ViewPager, Instagram notification screen etc.
internal class TabmanScrollingButtonBar: TabmanButtonBar {
        
    //
    // MARK: Constants
    //
    
    private struct Defaults {
        
        static let minimumItemWidth: CGFloat = 44.0
    }
    
    //
    // MARK: Properties
    //
    
    // Private
    
    internal lazy var scrollView: TabmanScrollView = {
        let scrollView = TabmanScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    internal var fadeGradientLayer: CAGradientLayer?
    
    // Public
    
    /// Whether scroll is enabled on the bar.
    public var isScrollEnabled: Bool {
        set(isScrollEnabled) {
            guard isScrollEnabled != self.scrollView.isScrollEnabled else { return }

            self.scrollView.isScrollEnabled = isScrollEnabled
            UIView.animate(withDuration: 0.3, animations: { // reset scroll position
                self.transitionStore?.indicatorTransition(forBar: self)?.updateForCurrentPosition()
            })
        }
        get {
            return self.scrollView.isScrollEnabled
        }
    }
    
    /// The inset at the edge of the bar items.
    public var edgeInset: CGFloat = Appearance.defaultAppearance.layout.edgeInset! {
        didSet {
            self.updateConstraints(self.edgeMarginConstraints,
                                   withValue: edgeInset)
            self.layoutIfNeeded()
            self.updateForCurrentPosition()
        }
    }
    
    public override var interItemSpacing: CGFloat {
        didSet {
            self.updateConstraints(self.horizontalMarginConstraints,
                                   withValue: interItemSpacing)
        }
    }
    
    override var color: UIColor {
        didSet {
            guard color != oldValue else { return }
            
            self.updateButtons(withContext: .unselected, update: { button in
                button.setTitleColor(color, for: .normal)
                button.setTitleColor(color.withAlphaComponent(0.3), for: .highlighted)
                button.tintColor = color
            })
        }
    }
    
    override var selectedColor: UIColor {
        didSet {
            guard selectedColor != oldValue else { return }
            
            self.focussedButton?.setTitleColor(selectedColor, for: .normal)
            self.focussedButton?.tintColor = selectedColor
        }
    }
    
    //
    // MARK: Lifecycle
    //
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.fadeGradientLayer?.frame = self.bounds
        
        self.transitionStore?.indicatorTransition(forBar: self)?.updateForCurrentPosition()
    }
    
    public override func defaultIndicatorStyle() -> TabmanIndicator.Style {
        return .line
    }
    
    override func indicatorTransitionType() -> TabmanIndicatorTransition.Type? {
        return TabmanScrollingBarIndicatorTransition.self
    }
    
    //
    // MARK: TabmanBar Lifecycle
    //
    
    override public func constructTabBar(items: [TabmanBarItem]) {
        super.constructTabBar(items: items)
        
        // add scroll view
        self.contentView.addSubview(scrollView)
        scrollView.autoPinEdgesToSuperviewEdges()
        scrollView.match(parent: self, onDimension: .height)
        scrollView.contentView.removeAllSubviews()
        scrollView.isScrollEnabled = self.appearance.interaction.isScrollEnabled ?? false
        
        self.addBarButtons(toView: self.scrollView.contentView, items: items)
        { (button, previousButton) in
            self.buttons.append(button)
            
            button.setTitleColor(self.color, for: .normal)
            button.setTitleColor(self.color.withAlphaComponent(0.3), for: .highlighted)
            button.titleLabel?.font = self.textFont
            button.addTarget(self, action: #selector(tabButtonPressed(_:)), for: .touchUpInside)
            
            // add a minimum width constraint to button
            let minWidthConstraint = NSLayoutConstraint(item: button,
                                                        attribute: .width,
                                                        relatedBy: .greaterThanOrEqual,
                                                        toItem: nil,
                                                        attribute: .notAnAttribute,
                                                        multiplier: 1.0, constant: Defaults.minimumItemWidth)
            button.addConstraint(minWidthConstraint)
        }
        
        self.updateConstraints(self.edgeMarginConstraints, withValue: self.edgeInset)
        self.updateConstraints(self.horizontalMarginConstraints, withValue: self.edgeInset)
        
        self.scrollView.layoutIfNeeded()
    }
    
    public override func addIndicatorToBar(indicator: TabmanIndicator) {
        
        self.scrollView.contentView.addSubview(indicator)
        indicator.autoPinEdge(toSuperviewEdge: .bottom)
        self.indicatorLeftMargin = indicator.autoPinEdge(toSuperviewEdge: .left)
        self.indicatorWidth = indicator.autoSetDimension(.width, toSize: 0.0)
    }
    
    override public func update(forAppearance appearance: Appearance,
                                defaultAppearance: Appearance) {
        super.update(forAppearance: appearance,
                     defaultAppearance: defaultAppearance)
        
        let edgeInset = appearance.layout.edgeInset
        self.edgeInset = edgeInset ?? defaultAppearance.layout.edgeInset!
        
        let isScrollEnabled = appearance.interaction.isScrollEnabled
        self.isScrollEnabled = isScrollEnabled ?? defaultAppearance.interaction.isScrollEnabled!
        
        self.updateEdgeFade(visible: appearance.style.showEdgeFade ?? false)
        
        // update left margin for progressive style
        if self.indicator?.isProgressiveCapable ?? false {
            
            let indicatorIsProgressive = appearance.indicator.isProgressive ?? defaultAppearance.indicator.isProgressive!
            let leftMargin = self.indicatorLeftMargin?.constant ?? 0.0
            let indicatorWasProgressive = leftMargin == 0.0
            
            if indicatorWasProgressive && !indicatorIsProgressive {
                self.indicatorLeftMargin?.constant = leftMargin - self.edgeInset
            } else if !indicatorWasProgressive && indicatorIsProgressive {
                self.indicatorLeftMargin?.constant = 0.0
            }
        }
    }
    
    //
    // MARK: Layout
    //
    
    private func updateConstraints(_ constraints: [NSLayoutConstraint], withValue value: CGFloat) {
        for constraint in constraints {
            var value = value
            if constraint.constant < 0.0 || constraint.firstAttribute == .trailing {
                value = -value
            }
            constraint.constant = value
        }
        self.layoutIfNeeded()
    }
}

internal extension TabmanScrollingButtonBar {
    
    func updateEdgeFade(visible: Bool) {
        if visible {
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.locations = [0.02, 0.05, 0.95, 0.98]
            self.contentView.layer.mask = gradientLayer
            self.fadeGradientLayer = gradientLayer
            
        } else {
            self.contentView.layer.mask = nil
            self.fadeGradientLayer = nil
        }
    }
    
}
