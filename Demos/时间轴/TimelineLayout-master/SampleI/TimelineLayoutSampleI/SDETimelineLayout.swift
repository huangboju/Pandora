//
//  SDETimelineLayout.swift
//  TimelineLayoutSample
//
//  Created by seedante on 15/11/17.
//  Copyright © 2015年 seedante. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


private let decorationLineViewKind = "LineView"

class SDETimelineLayout: UICollectionViewFlowLayout {

    //the follow parameter is relative to header view config in storyboard
    let footerXOffset: CGFloat = 8.0
    let decorationLineXOffset: CGFloat = 18.0

    override init() {
        super.init()
        self.register(DecorationLineView.self, forDecorationViewOfKind: decorationLineViewKind)
        self.footerReferenceSize = CGSize(width: 10.0, height: 2.0)
        self.sectionInset = UIEdgeInsets(top: 10, left: 48, bottom: 10, right: 50.0)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.register(DecorationLineView.self, forDecorationViewOfKind: decorationLineViewKind)
        self.footerReferenceSize = CGSize(width: 10.0, height: 2.0)
        self.sectionInset = UIEdgeInsets(top: 10, left: 48, bottom: 10, right: 50.0)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttrs = super.layoutAttributesForElements(in: rect)

        let headerLayoutAttrs = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionHeader })//.sort({$0.indexPath.section < $1.indexPath.section})
        if headerLayoutAttrs?.count > 0{
            let sectionCount = (self.collectionView?.dataSource?.numberOfSections!(in: self.collectionView!))!
            for headerLayoutAttr in headerLayoutAttrs!{
                /*
                -------- HeaderView
                |
                |        DecorationView
                |
                -------- HeaderView
                |
                |        DecorationView
                |
                -------- FooterView
                */

                let decorationViewLayoutAttr = self.layoutAttributesForDecorationView(ofKind: decorationLineViewKind, at: headerLayoutAttr.indexPath)
                if decorationViewLayoutAttr != nil{
                    layoutAttrs?.append(decorationViewLayoutAttr!)
                }

                let headerSize = headerLayoutAttr.size
                var lineLength: CGFloat = 0

                if headerLayoutAttr.indexPath.section < sectionCount - 1{
                    if let nexHeaderLayoutAttr = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: headerLayoutAttr.indexPath.section + 1)){
                        lineLength = nexHeaderLayoutAttr.frame.origin.y - headerLayoutAttr.frame.origin.y
                    }
                }else{
                    //Only one footer, in last section.
                    let footerLayouts = layoutAttrs?.filter({ $0.representedElementKind == UICollectionElementKindSectionFooter && $0.indexPath.section == headerLayoutAttr.indexPath.section})
                    if footerLayouts?.count == 1{
                        let footerLayoutAttr = footerLayouts!.first
                        let y = footerLayoutAttr!.frame.origin.y
                        footerLayoutAttr!.frame = CGRect(x: footerXOffset, y: y, width: 20, height: 2)
                        lineLength =  y - headerLayoutAttr.frame.origin.y - headerSize.height / 2
                    }else{
                        lineLength = rect.height + rect.origin.y - headerLayoutAttr.frame.origin.y - headerSize.height / 2
                        //or
//                        if let footerLayoutAttr = self.layoutAttributesForSupplementaryViewOfKind(UICollectionElementKindSectionFooter, atIndexPath: headerLayoutAttr.indexPath){
//                            lineLength = footerLayoutAttr.frame.origin.y - headerLayoutAttr.frame.origin.y
//                        }
                    }
                }

                //about line width, on non-retina iOS device, it must >= 0.54, or else can't see it. There is no problem on retina iOS device with 0.5 width, it can deep to 0.27 width.
                decorationViewLayoutAttr?.frame = CGRect(x: decorationLineXOffset, y: (headerLayoutAttr.frame.origin.y + headerSize.height / 2), width: 0.55, height: lineLength)
            }
        }

        return layoutAttrs
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        let oldBounds = self.collectionView!.bounds
        if oldBounds.equalTo(newBounds){
            return false
        }else{
            return true
        }
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
        if elementKind == UICollectionElementKindSectionFooter{
            let origin = layoutAttr?.frame.origin
            layoutAttr?.frame = CGRect(x: footerXOffset, y: origin!.y, width: 20, height: 2)
        }
        return layoutAttr
    }

    //#MARK: config initial layout animation
    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind elementKind: String, at elementIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: elementKind, at: elementIndexPath)
        if elementKind == UICollectionElementKindSectionFooter{
            layoutAttr?.size = CGSize.zero
        }
        return layoutAttr
    }

    override func initialLayoutAttributesForAppearingDecorationElement(ofKind elementKind: String, at decorationIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttr = super.initialLayoutAttributesForAppearingDecorationElement(ofKind: elementKind, at: decorationIndexPath)
        let headerLayoutAttr = self.initialLayoutAttributesForAppearingSupplementaryElement(ofKind: UICollectionElementKindSectionHeader, at: decorationIndexPath)
        var offsetY: CGFloat = 0
        if headerLayoutAttr != nil{
            offsetY = (headerLayoutAttr?.frame.origin.y)! + (headerLayoutAttr?.size.height)! / 2
        }
        layoutAttr?.frame = CGRect(x: decorationLineXOffset, y: offsetY, width: 1.0, height: 1.0)

        return layoutAttr
    }

}
