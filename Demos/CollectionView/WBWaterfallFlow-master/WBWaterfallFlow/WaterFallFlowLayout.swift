//
//  WaterFallFlowLayout.swift
//  WBWaterfallFlow
//
//  Created by caowenbo on 16/2/20.
//  Copyright © 2016年 曹文博. All rights reserved.
//

import UIKit

protocol WaterFallFlowLayoutDelegate: class {

    /**
     根据flowLayout获得cell的高度

     - parameter waterFallFlowLayout: WaterFallFlowLayout
     - parameter heigtForItemAtIndex: 第几个cell
     - parameter itemWidth:           cell的width

     - returns: cell的高度
     */
    func waterflowLayout(waterFallFlowLayout: WaterFallFlowLayout, heigtForItemAtIndex: Int, itemWidth: CGFloat) -> CGFloat
}

class WaterFallFlowLayout: UICollectionViewLayout {

    // 布局属性
    private lazy var attributes: [UICollectionViewLayoutAttributes] = {
        [UICollectionViewLayoutAttributes]()
    }()

    weak var delegate: WaterFallFlowLayoutDelegate?
    /// cell 间距
    private let cellMargin: CGFloat = 10
    // 列数
    private let columnCount = 3
    /**  每列的行高  */
    private var heights: [CGFloat] = [0, 0, 0]

    /**
     collection的布局
     */
    override func prepareLayout() {
        super.prepareLayout()

        attributes.removeAll()
        heights.removeAll()

        for _ in 0 ..< columnCount {
            let height: CGFloat = 0
            heights.append(height)
        }

        let count = collectionView!.numberOfItemsInSection(0)

        for i in 0 ..< count {

            let indexPath = NSIndexPath.init(forItem: i, inSection: 0)

            let attribute = layoutAttributesForItemAtIndexPath(indexPath)!

            attributes.append(attribute)
        }
    }

    /**
     一个cell对应一个UICollectionViewLayoutAttributes属性
     UICollectionViewLayoutAttributes决定了cell的布局属性

     - parameter rect: 重新布局的范围

     - returns: rect范围内所有cell的布局属性
     */
    override func layoutAttributesForElementsInRect(rect _: CGRect) -> [UICollectionViewLayoutAttributes]? {

        return attributes
    }

    /**
     - parameter indexPath: item 的 indexPath

     - returns: 返回indexPath上的item的布局属性
     */
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {

        let attribute = UICollectionViewLayoutAttributes.init(forCellWithIndexPath: indexPath)

        var minHeight = heights[0]
        var minColumnIndex = 0

        // 取出最小的列高和对应的列数
        for i in 1 ..< columnCount {
            if heights[i] < minHeight {
                minHeight = heights[i]
                minColumnIndex = i
            }
        }

        let collectionViewW = collectionView!.frame.size.width

        let width = (collectionViewW - (CGFloat(columnCount) + 1) * cellMargin) / CGFloat(columnCount)
        let height = delegate!.waterflowLayout(self, heigtForItemAtIndex: indexPath.row, itemWidth: width)

        let x = (CGFloat(minColumnIndex) + 1) * cellMargin + CGFloat(minColumnIndex) * width
        let y = minHeight + cellMargin

        heights[minColumnIndex] = y + CGFloat(height)

        attribute.frame = CGRect(x: x, y: y, width: width, height: CGFloat(height))

        return attribute
    }

    /**
     返回collectionView的内容大小
     */
    override func collectionViewContentSize() -> CGSize {

        // 取出最大的列高
        var maxHeight = heights[0]

        for i in 1 ..< columnCount {
            if heights[i] > maxHeight {
                maxHeight = heights[i]
            }
        }

        return CGSize(width: 0, height: maxHeight + cellMargin)
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
