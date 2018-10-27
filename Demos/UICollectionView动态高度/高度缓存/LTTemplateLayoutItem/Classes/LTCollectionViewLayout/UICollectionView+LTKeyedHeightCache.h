//
//  UICollectionView+LTKeyedHeightCache.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/18.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LTKeyedHeightCache : NSObject

- (BOOL)existsHeightForKey:(id<NSCopying>)key;

- (void)cacheHeight:(CGFloat)height byKey:(id<NSCopying>)key;

- (CGFloat)heightForKey:(id<NSCopying>)key;

- (void)invalidateHeightForKey:(id<NSCopying>)key;

- (void)invalidateAllHeightCache;
@end


@interface UICollectionView (LTKeyedHeightCache)


@property (nonatomic, strong, readonly) LTKeyedHeightCache *lt_keyedHeightCache;

@end



