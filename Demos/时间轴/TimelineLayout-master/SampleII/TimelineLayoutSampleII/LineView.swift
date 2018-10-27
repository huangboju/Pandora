//
//  DecorationLineView.swift
//  TimelineLayoutSampleI
//
//  Created by seedante on 15/11/19.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit

class LineView: UICollectionReusableView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.white
    }
}
