//
//  UICollectionView+LTCollectionViewLayoutCell.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/17.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+LTIndexPathHeightCache.h"
#import "UICollectionView+LTKeyedHeightCache.h"
#import "UICollectionView+LTCollectionViewLayoutItemDebug.m"
#import "LTCollectionViewDynamicHeightCellLayout.h"


@interface UICollectionView (LTCollectionViewLayoutCell)

- (__kindof UICollectionViewCell *)lt_templateCellForReuseIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)lt_heightForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration ;

- (CGFloat)lt_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration;

- (CGFloat)lt_heightForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath cacheByKey:(id<NSCopying>)key configuration:(void (^)(id cell))configuration;

@end

@interface UICollectionView (LTTemplateLayoutHeaderFooterView)

- (CGFloat)lt_heightForHeaderFooterViewWithIdentifier:(NSString *)identifier configuration:(void (^)(id headerFooterView))configuration;

@end

@interface UICollectionViewCell (LTTemplateLayoutCell)

@property (nonatomic, assign) BOOL lt_isTemplateLayoutCell;

@property (nonatomic, assign) BOOL lt_enforceFrameLayout;

@end
