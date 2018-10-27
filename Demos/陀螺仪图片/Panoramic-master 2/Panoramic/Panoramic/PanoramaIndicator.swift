//
//  PanoramaIndicator.swift
//  Panorama Swift
//
//  Created by Sameh Mabrouk on 12/13/14.
//  Copyright (c) 2014 SMApps. All rights reserved.
//

import Foundation
import UIKit

//Constants
let ScrollIndicatorLeftRightThreshold:CGFloat = 16.0
let ScrollIndicatorBottomSpace:CGFloat = 20.0
let ScrollIndicatorHeight:CGFloat = 1.0
let ScrollIndicatorDefaultWidth:CGFloat = 20.0
var viewScrollIndicatorKey: Void?
var backgroundViewScrollIndicatorKey: Void?

extension UIScrollView{

    //MARK: Getters/Setters
    func setViewForPanoramaIndicator(_ viewScrollIndicator:UIView){
        objc_setAssociatedObject(self, &viewScrollIndicatorKey, viewScrollIndicator, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func getViewForPanoramaIndicator() -> UIView?{
    
        return objc_getAssociatedObject(self, &viewScrollIndicatorKey) as? UIView;
    }
    func setBackgroundViewForPanoramaIndicator(_ backgroundViewScrollIndicator:UIView){
    
        objc_setAssociatedObject(self, &backgroundViewScrollIndicatorKey, backgroundViewScrollIndicator, .OBJC_ASSOCIATION_RETAIN)
    }
    func getBackgroundViewForPanoramaIndicator()-> UIView?{
        return objc_getAssociatedObject(self, &backgroundViewScrollIndicatorKey) as? UIView;
    }
    
    //MARK: Instance methods
    func enablePanoramaIndicator(){
    
        if self.getBackgroundViewForPanoramaIndicator() == nil && self.getViewForPanoramaIndicator() == nil{
        
            
            self.showsHorizontalScrollIndicator = false
            let indicatorColor:UIColor = UIColor.white
            
            // Configure the scroll indicator's background
            let backgroundIndicatorWidth:CGFloat = self.frame.size.width - (ScrollIndicatorLeftRightThreshold * 2)
            let backgroundIndicatorFrame:CGRect = CGRect(x: self.contentOffset.x + (self.frame.size.width / 2) - (backgroundIndicatorWidth / 2), y: self.frame.size.height - ScrollIndicatorHeight - ScrollIndicatorBottomSpace, width: backgroundIndicatorWidth, height: ScrollIndicatorHeight)
            
            var backgroundViewScrollIndicator:UIView!
            backgroundViewScrollIndicator = UIView(frame: backgroundIndicatorFrame)
            backgroundViewScrollIndicator.backgroundColor = indicatorColor.withAlphaComponent(0.50)
            self.setBackgroundViewForPanoramaIndicator(backgroundViewScrollIndicator)
            self.addSubview(backgroundViewScrollIndicator)
            
            // Configure the scroll indicator
            var viewScrollIndicatorWidth:CGFloat = (self.bounds.size.width - (ScrollIndicatorLeftRightThreshold * 2)) * (self.bounds.size.width - (ScrollIndicatorLeftRightThreshold * 2)) / self.contentSize.width
            if viewScrollIndicatorWidth < ScrollIndicatorDefaultWidth{
                
                viewScrollIndicatorWidth = ScrollIndicatorDefaultWidth
            }
            
            let scrollIndicatorFrame:CGRect = CGRect(x: self.contentOffset.x + (self.frame.size.width / 2) - (viewScrollIndicatorWidth / 2), y: self.frame.size.height - ScrollIndicatorHeight - ScrollIndicatorBottomSpace, width: viewScrollIndicatorWidth, height: ScrollIndicatorHeight)
            
            var viewScrollIndicator:UIView!
            viewScrollIndicator = UIView(frame: scrollIndicatorFrame)
            viewScrollIndicator.backgroundColor = indicatorColor.withAlphaComponent(1.0)
            [self .setViewForPanoramaIndicator(viewScrollIndicator)];
            self.addSubview(viewScrollIndicator)
            
            self.setupObservers()

            
        }
    }
    
    func refreshPanoramaIndicator(){
    
        self.refreshBackgroundPanoramaIndicator()
        self.refreshPanoramaViewIndicator()
    }
    func refreshBackgroundPanoramaIndicator(){
    
        let backgroundViewScrollIndicator:UIView = self.getBackgroundViewForPanoramaIndicator()!
        let x:CGFloat = self.contentOffset.x + ScrollIndicatorLeftRightThreshold
        let rect:CGRect = CGRect(x: x, y: backgroundViewScrollIndicator.frame.origin.y, width: backgroundViewScrollIndicator.frame.width, height: backgroundViewScrollIndicator.frame.height)
        backgroundViewScrollIndicator.frame = rect
    }
    
    func refreshPanoramaViewIndicator(){
    
        let viewScrollIndicator:UIView = self.getViewForPanoramaIndicator()!
        let percent:CGFloat = self.contentOffset.x / self.contentSize.width
        let x:CGFloat =  self.contentOffset.x + ((self.bounds.size.width - ScrollIndicatorLeftRightThreshold) * percent) + ScrollIndicatorLeftRightThreshold
        let rect:CGRect = CGRect(x: x, y: viewScrollIndicator.frame.origin.y, width: viewScrollIndicator.frame.width, height: viewScrollIndicator.frame.height)
        viewScrollIndicator.frame = rect
        
    }
    
    func disablePanoramaIndicator(){
    print("disablePanoramaIndicator")
        self.stopObservers()
        self.getBackgroundViewForPanoramaIndicator()?.removeFromSuperview()
        self.getViewForPanoramaIndicator()?.removeFromSuperview()
    }
    
    //MARK: KVO
    func setupObservers(){
    
        self.addObserver(self, forKeyPath:"contentSize", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old] , context: nil)
        self.addObserver(self, forKeyPath:"contentOffset", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.old] , context: nil)
    }
    
    func stopObservers(){
    
        self.removeObserver(self, forKeyPath: "contentSize")
        self.removeObserver(self, forKeyPath: "contentOffset")
        
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.contentSize.width > 0.0{
        
            //refresh panorama indicator
            self.refreshPanoramaIndicator()
        }
    }
}
