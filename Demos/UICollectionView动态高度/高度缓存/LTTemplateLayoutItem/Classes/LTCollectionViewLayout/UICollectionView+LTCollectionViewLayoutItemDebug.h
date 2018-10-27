//
//  UICollectionView+LTCollectionViewLayoutItemDebug.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/18.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (LTCollectionViewLayoutItemDebug)


@property (nonatomic, assign) BOOL lt_debugLogEnabled;

- (void)lt_debugLog:(NSString *)message;


@end
