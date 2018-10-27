//
//  UICollectionView+LTCollectionViewLayoutItemDebug.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/18.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "UICollectionView+LTCollectionViewLayoutItemDebug.h"
#import <objc/runtime.h>

@implementation UICollectionView (LTCollectionViewLayoutItemDebug)

- (BOOL)lt_debugLogEnabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLt_debugLogEnabled:(BOOL)debugLogEnabled {
    objc_setAssociatedObject(self, @selector(lt_debugLogEnabled), @(debugLogEnabled), OBJC_ASSOCIATION_RETAIN);
}

- (void)lt_debugLog:(NSString *)message {
    if (self.lt_debugLogEnabled) {
        NSLog(@"** bug ** %@", message);
    }
}


@end
