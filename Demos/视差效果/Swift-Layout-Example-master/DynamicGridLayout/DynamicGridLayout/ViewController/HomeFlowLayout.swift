//
//  HomeFlowLayout.swift
//  DynamicGridLayout
//
//  Created by don chen on 2017/3/13.
//  Copyright © 2017年 Don Chen. All rights reserved.
//

import UIKit

class HomeFlowLayout: UICollectionViewFlowLayout {
    
    // 定義幾種column類型
    enum LayoutType:String {
        case twoColumn, threeColumn, sixColumn, twelve
        
        var column: Int {
            switch self {
            case .twoColumn: return 2
            case .threeColumn: return 3
            case .sixColumn: return 6
            case .twelve: return 12
            }
        }
        
        var keyName: String {
            switch self {
            case .twoColumn: return "two"
            case .threeColumn: return "three"
            case .sixColumn: return "six"
            case .twelve: return "twelve"
            }
        }
        
    }
    
    var items = [UIImage]()
    var layoutType:LayoutType = .twoColumn
    fileprivate lazy var layoutAttributes:[String:[UICollectionViewLayoutAttributes]] = {
        return [String:[UICollectionViewLayoutAttributes]]()
    }()
    
    fileprivate lazy var layoutItemSize:[String:CGSize] = {
        return [String:CGSize]()
    }()
    
    override func prepare() {
        super.prepare()
        minimumInteritemSpacing = 10
        minimumLineSpacing      = 10
        
        sectionInset.top        = 10
        sectionInset.left       = 10
        sectionInset.right      = 10
        
        // 如果之前沒有計算過Layout則計算並存入cache中
        if layoutAttributes[layoutType.keyName] == nil && collectionView != nil{
            // 根據想要的column數量來計算一個cell的寬度
            let contentWidth:CGFloat = collectionView!.bounds.size.width - sectionInset.left - sectionInset.right
            let itemWidth = (contentWidth - minimumInteritemSpacing * (CGFloat(layoutType.column)-1)) / CGFloat(layoutType.column)
            
            // 計算cell的佈局
            computeAndStoreAttributes(layoutType ,CGFloat(itemWidth))

        }

        // 佈局變化時記得跟著改變itemSize
        if let size = layoutItemSize[layoutType.keyName] {
            itemSize = size
        }


    }
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributes[layoutType.keyName]
    }
    
    // 計算cell的frame以及設定item size來提供系統計算UICollectionView的contentSize
    fileprivate func computeAndStoreAttributes(_ layoutType:LayoutType ,_ itemWidth:CGFloat) {
        
        // 以sectionInset.top作為最初始的高度，紀錄每一個column的高度
        var columnHeights = [CGFloat](repeating: sectionInset.top, count: layoutType.column)
        
        // 記錄每一個column的item個數
        var columnItemCount = [Int](repeating: 0, count: layoutType.column)
        
        // 紀錄每一個cell的attributes
        var attributes = [UICollectionViewLayoutAttributes]()
        
        var row = 0
        for item in items {
            // 建立一個attribute
            let indexPath = IndexPath.init(row: row, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            // 找出最短的Column
            let minHeight = columnHeights.sorted().first!
            let minHeightColumn = columnHeights.index(of: minHeight)!
            
            // 新的照片放到最短Column上
            columnItemCount[minHeightColumn] += 1
            let itemX = (itemWidth + minimumInteritemSpacing) * CGFloat(minHeightColumn) + sectionInset.left
            let itemY = minHeight
            
            // 計算高度，按照原圖片大小等比例縮放
            let itemHeight = item.size.height * itemWidth / item.size.width
            
            // 設定Frame，加入到attributes中
            attribute.frame = CGRect(x: itemX, y: CGFloat(itemY), width: itemWidth, height: CGFloat(itemHeight))
            attributes.append(attribute)
            
            // 計算最短的column當前的高度
            columnHeights[minHeightColumn] += itemHeight + minimumLineSpacing
            
            row += 1
        }
        
        // 找出最高的Column
        let maxHeight = columnHeights.sorted().last!
        let column = columnHeights.index(of: maxHeight)
        
        // 用於系統計算collectionView的contentSize - 根據最高的Column來設置itemSize，使用總高度的平均值
        let itemHeight = (maxHeight - minimumLineSpacing * CGFloat(columnItemCount[column!])) / CGFloat(columnItemCount[column!])
        let cellSize = CGSize(width: itemWidth, height: itemHeight)
        
        // 將計算後的結果存起來
        layoutAttributes[layoutType.keyName] = attributes
        layoutItemSize[layoutType.keyName] = cellSize
        
    }
    

    
    
}
