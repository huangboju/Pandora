//
//  CardLayout.swift
//  DynamicStackOfCards
//
//  Created by Pritesh Nandgaonkar on 9/16/16.
//  Copyright © 2016 pritesh. All rights reserved.
//

import Foundation
import UIKit

internal protocol CardLayoutDelegate {
    var fractionToMove: CGFloat { get }
    var cardState: CardState { get }
    var configuration: Configuration { get }
}

class CardLayout: UICollectionViewLayout {

    var delegate: CardLayoutDelegate!
    var contentHeight: CGFloat = 0.0

    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        let collection = collectionView!
        let width = collection.bounds.size.width
        let height = contentHeight
        
        return CGSize(width: width, height: height)
    }
    
    override func prepare() {
        cachedAttributes.removeAll()
        contentHeight = delegate.cardState == .expanded ? 0.0 : CGFloat(delegate.configuration.collapsedHeight + delegate.fractionToMove)
        
        guard let numberOfItems = collectionView?.numberOfItems(inSection: 0) else {
            return
        }
        
        for index in 0..<numberOfItems {
            let layout = UICollectionViewLayoutAttributes(forCellWith: IndexPath(row: index, section: 0))
            layout.frame = frameFor(index: index, cardState: delegate!.cardState, translation: delegate.fractionToMove)
            if delegate.cardState == .expanded {
                contentHeight += CGFloat(delegate.configuration.verticalSpacing) + layout.frame.size.height
            }
            layout.zIndex = index
            layout.isHidden = false
            
            cachedAttributes.append(layout)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(cachedAttributes[attributes.indexPath.item])
            }

        }
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    func frameFor(index: Int, cardState: CardState, translation: CGFloat) -> CGRect {
        var frame = CGRect(origin: CGPoint(x: delegate.configuration.leftSpacing, y:0), size: CGSize(width: UIScreen.main.bounds.width - delegate.configuration.leftSpacing + delegate.configuration.rightSpacing, height: delegate.configuration.cardHeight))
        var frameOrigin = frame.origin
        switch cardState {
        case .expanded:
            let val = (delegate.configuration.cardHeight * CGFloat(index))
            frameOrigin.y = CGFloat(delegate.configuration.verticalSpacing * CGFloat(index) + val)
            
        case .inTransit:
            if index > 0 {
                
                let collapsedY = delegate.configuration.verticalSpacing + (delegate.configuration.cardOffset * CGFloat(index))
                let finalDistToMove = Swift.abs(((delegate.configuration.verticalSpacing + delegate.configuration.cardHeight) * CGFloat(index)) - collapsedY)
                let fract = (finalDistToMove * translation)/(delegate.configuration.expandedHeight - delegate.configuration.collapsedHeight)
                let val = CGFloat(delegate.configuration.verticalSpacing + (delegate.configuration.cardOffset * CGFloat(index)) + fract)
                frameOrigin.y = val
            }
            
        case .collapsed:
            if index > 0 {
                frameOrigin.y = CGFloat(delegate.configuration.verticalSpacing + (delegate.configuration.cardOffset * CGFloat(index)))
            }
        }
        frame.origin = frameOrigin
        return frame
    }

}
