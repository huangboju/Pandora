//
//  FirstLayout.swift
//  WBWaterfallFlow
//
//  Created by caowenbo on 16/2/20.
//  Copyright © 2016年 曹文博. All rights reserved.
//

import UIKit

class FirstLayout: UICollectionViewFlowLayout {

    /**
     当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
     一旦重新刷新布局，就会重新调用下面的方法：
      1.prepareLayout
      2.layoutAttributesForElementsInRect:
     */
    override func shouldInvalidateLayoutForBoundsChange(newBounds _: CGRect) -> Bool {
        return true
    }

    /**
     用来布局时的初始化操作
     */
    override func prepareLayout() {
        super.prepareLayout()

        scrollDirection = .Horizontal

        let inset = (collectionView!.frame.size.width - itemSize.width) * 0.5
        collectionView!.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }

    /**
     一个cell对应一个UICollectionViewLayoutAttributes属性
     UICollectionViewLayoutAttributes决定了cell的布局属性

     - parameter rect: 重新布局的范围

     - returns: rect范围内所有cell的布局属性
     */
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        let array = super.layoutAttributesForElementsInRect(rect)!

        // 需要copy，否则会出现警告
        let attributes = NSArray.init(array: array, copyItems: true) as! [UICollectionViewLayoutAttributes]

        //  collectionView以collectionContentSize为参考系的中心点的坐标
        let centerX = collectionView!.center.x + collectionView!.contentOffset.x

        for attribute in attributes {

            // cell的中心距离屏幕中心点的的距离
            let delta = attribute.center.x - centerX

            let scale = 1 - abs(delta) / collectionView!.frame.size.width / 2

            var transform = CGAffineTransformMakeScale(scale, scale)

            transform = CGAffineTransformRotate(transform, delta / collectionView!.frame.size.width / 2 * CGFloat(M_PI))

            attribute.transform = transform
        }

        return attributes
    }

    /**
     更改collectionView停止滚动时的偏移值

     - parameter proposedContentOffset: 系统预算的停止滚动时的偏移值
     - parameter velocity:              滚动的速度

     - returns: 更改后的偏移值
     */
    override func targetContentOffsetForProposedContentOffset(var proposedContentOffset: CGPoint, withScrollingVelocity _: CGPoint) -> CGPoint {

        // 计算出最终显示的矩形框
        let rect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.frame.size.width, height: collectionView!.frame.size.height)
        // 获得super已经计算好的布局属性
        let array = super.layoutAttributesForElementsInRect(rect)

        // 计算collectionView最中心点的x值
        let centerX = proposedContentOffset.x + collectionView!.frame.size.width * 0.5

        var minDeleta = CGFloat(MAXFLOAT)

        for item in array! {
            if abs(minDeleta) > abs(item.center.x - centerX) {
                minDeleta = item.center.x - centerX
            }
        }

        proposedContentOffset.x += minDeleta

        return proposedContentOffset
    }
}

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
