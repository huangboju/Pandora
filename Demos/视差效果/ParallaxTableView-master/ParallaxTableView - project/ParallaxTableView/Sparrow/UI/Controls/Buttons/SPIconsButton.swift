//
//  432.swift
//  st
//
//  Created by Ivan Vorobei on 9/11/16.
//  Copyright © 2016 Ivan Vorobei. All rights reserved.
//

import UIKit

class SPIconsButton: SPRoundFrameButton {
    
    init(normalIconImage: UIImage?, highlightedIconImage: UIImage?) {
        super.init(frame: CGRect.zero)
        commonInit(normalIconImage, highlightedIconImage: highlightedIconImage)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit(_ normalIconImage: UIImage? = nil, highlightedIconImage: UIImage? = nil) {
        self.backgroundColor = UIColor.clear
        self.setImage(normalIconImage, for: UIControlState.normal)
        self.setImage(highlightedIconImage, for: UIControlState.highlighted)
    }
}
