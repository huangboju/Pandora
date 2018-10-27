//
//  UICollectionView+LTIndexPathHeightCache.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/18.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICollectionView+LTIndexPathHeightCache.h"

@interface LTIndexPathHeightCache : NSObject

@property (nonatomic, assign) BOOL automaticallyInvalidateEnabled;

- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath;

- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath;

- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath;

- (void)invalidateAllHeightCache;

@end

@interface UICollectionView (LTIndexPathHeightCache)

@property (nonatomic, strong, readonly) LTIndexPathHeightCache *lt_indexPathHeightCache;

@end

@interface UICollectionView (LTIndexPathHeightCacheInvalidation)

- (void)lt_reloadDataWithoutInvalidateIndexPathHeightCache;

@end
