//
//  WaterFlowViewLayout.swift
//  JMWaterFlow
//
//  Created by Jimmy on 15/10/11.
//  Copyright © 2015年 Jimmy. All rights reserved.
//

import UIKit

// 代理
protocol WaterFlowViewLayoutDelegate: NSObjectProtocol {
    /// Width是瀑布流每列的宽度
    func waterFlowViewLayout(_ waterFlowViewLayout: WaterFlowViewLayout, heightForWidth: CGFloat, atIndexPath: IndexPath) -> CGFloat
}

/// 自定义布局
class WaterFlowViewLayout: UICollectionViewLayout {
    /// 间隔,默认8
    static var Margin: CGFloat = 8

    /// 瀑布流四周的间距
    var sectionInsert = UIEdgeInsets(top: Margin, left: Margin, bottom: Margin, right: Margin)

    /// 瀑布流列数
    var column = 4

    /// 列间距
    var columnMargin: CGFloat = Margin

    /// 行间距
    var rowMargin: CGFloat = Margin

    /// 布局的代理
    weak var delegate: WaterFlowViewLayoutDelegate?

    /// 所有cell的布局属性
    var layoutAttributes = [UICollectionViewLayoutAttributes]()

    /// 使用一个字典记录每列的最大Y值
    var maxYDict = [Int: CGFloat]()

    var maxY: CGFloat = 0

    var columnWidth: CGFloat = 0

    // prepareLayout会在调用collectionView.reloadData()
    override func prepare() {
        // 设置布局

        // 需要清空字典里面的值
        for key in 0 ..< column {
            maxYDict[key] = 0
        }

        // 清空之前的布局属性
        layoutAttributes.removeAll()

        // 清空最大列的Y值
        maxY = 0

        // 清空列宽
        columnWidth = 0

        // 计算每列的宽度,需要在布局之前算好
        columnWidth = (UIScreen.main.bounds.width - sectionInsert.left - sectionInsert.right - (CGFloat(column) - 1) * columnMargin) / CGFloat(column)

        // 有多少个cell要显示
        let number = collectionView?.numberOfItems(inSection: 0) ?? 0

        for i in 0 ..< number {
            // 布局每一个cell的frame
            let layoutAttr = layoutAttributesForItem(at: IndexPath(item: i, section: 0))!
            layoutAttributes.append(layoutAttr)
        }

        // 在布局之后计算最大Y值
        calcMaxY()
    }

    func calcMaxY() {
        // 获取最大这一列的Y

        // 默认第0列最长
        var maxYCoulumn = 0

        // for循环比较,获取最长的这列
        for (key, value) in maxYDict {
            // value的Y值大于目前Y值最大的这列
            if value > maxYDict[maxYCoulumn]! {
                // key这列的Y值是最大的
                maxYCoulumn = key
            }
        }

        // 获取到Y值最大的这一列
        maxY = maxYDict[maxYCoulumn]! + sectionInsert.bottom
    }

    // 返回collectionViewcontentSize大小
    override var collectionViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: maxY)
    }

    // 返回每一个cell的布局属性(layoutAttributes)
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {

        assert(delegate != nil, "瀑布流必须实现代理来返回cell的高度")

        // 高度通过代理传入
        let height = delegate!.waterFlowViewLayout(self, heightForWidth: columnWidth, atIndexPath: indexPath)

        // 最短的这一列
        var minYColumn = 0

        // 通过for循环去和其他列比较
        for (key, value) in maxYDict {
            // value 当前遍历出来的这一列的高度
            if value < maxYDict[minYColumn]! { // maxYDict[minYColumn] 之前最短的哪一列
                // 说明 key这一列小于 minYColumn这一列,将key这个设置为最小的那一列
                minYColumn = key
            }
        }

        // minYColumn 就是短的那一列
        let x = sectionInsert.left + CGFloat(minYColumn) * (columnWidth + columnMargin)

        // 最短这列的Y值 + 行间距
        let y = maxYDict[minYColumn]! + rowMargin

        // 设置cell的frame
        let frame = CGRect(x: x, y: y, width: columnWidth, height: height)

        // 更新最短这列的最大Y值
        maxYDict[minYColumn] = frame.maxY

        // 创建每个cell对应的布局属性
        let layoutAttr = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        layoutAttr.frame = frame
        return layoutAttr
    }

    // 预加载下一页数据
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes
    }
}
