//
//  SPcsdf.swift
//  createBageCollectionView
//
//  Created by Ivan Vorobei on 9/7/16.
//  Copyright © 2016 Ivan Vorobei. All rights reserved.
//

import UIKit

class SPGradientViewController: UIViewController {
    
    var gradient: CAGradientLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        
    }
    
    func setGradient(_ fromColor: UIColor,
                     toColor: UIColor,
                     startPoint: CGPoint = CGPoint(x: 0.0, y: 0.0),
                     endPoint: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
        self.gradient = CAGradientLayer()
        self.gradient!.colors = [fromColor.cgColor, toColor.cgColor]
        self.gradient!.locations = [0.0, 1.0]
        self.gradient!.startPoint = startPoint
        self.gradient!.endPoint = endPoint
        self.gradient!.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(self.gradient!, at: 0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.gradient?.frame = self.view.bounds
    }
}
