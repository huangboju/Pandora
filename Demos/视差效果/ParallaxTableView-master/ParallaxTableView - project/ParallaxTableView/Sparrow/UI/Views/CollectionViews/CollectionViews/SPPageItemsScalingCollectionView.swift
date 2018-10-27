//
//  dsa.swift
//  createBageCollectionView
//
//  Created by Ivan Vorobei on 9/6/16.
//  Copyright © 2016 Ivan Vorobei. All rights reserved.
//

import UIKit

class SPPageItemsScalingCollectionView: UICollectionView {
    
    var layout = SPPageItemsScalingCollectionLayout()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame, collectionViewLayout: self.layout)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: self.layout)
        commonInit()
    }
}

// MARK: create
extension SPPageItemsScalingCollectionView {
    
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.clear
        self.collectionViewLayout = self.layout
        self.decelerationRate = UIScrollViewDecelerationRateFast
        self.delaysContentTouches = false
        self.isPagingEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
    }
}


