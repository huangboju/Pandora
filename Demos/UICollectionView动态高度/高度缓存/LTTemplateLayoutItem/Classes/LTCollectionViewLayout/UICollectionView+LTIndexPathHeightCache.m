//
//  UICollectionView+LTIndexPathHeightCache.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/18.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "UICollectionView+LTIndexPathHeightCache.h"
#import <objc/runtime.h>

typedef NSMutableArray <NSMutableArray<NSNumber *> *> LTIndexPathHeightsBySection;

@interface LTIndexPathHeightCache ()

@property (nonatomic, strong) LTIndexPathHeightsBySection *heightsBySectionForPortrait;

@property (nonatomic, strong) LTIndexPathHeightsBySection *heightsBySectionFor  ;

@end

@implementation LTIndexPathHeightCache

- (instancetype)init {
    self = [super init];
    if (self) {
        _heightsBySectionForPortrait = [NSMutableArray array];
        _heightsBySectionForPortrait = [NSMutableArray array];
    }
    return self;
}

- (LTIndexPathHeightsBySection *)heightsBySectionForCurrentOrientation {
    return UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) ? self.heightsBySectionForPortrait: self.heightsBySectionForPortrait;
}

- (void)enumerateAllOrientationsUsingBlock:(void (^)(LTIndexPathHeightsBySection *heightsBySection))block {
    block(self.heightsBySectionForPortrait);
    block(self.heightsBySectionForPortrait);
}

- (BOOL)existsHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];
    return ![number isEqualToNumber:@-1];
}

- (void)cacheHeight:(CGFloat)height byIndexPath:(NSIndexPath *)indexPath {
    self.automaticallyInvalidateEnabled = YES;
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row] = @(height);
}

- (CGFloat)heightForIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    NSNumber *number = self.heightsBySectionForCurrentOrientation[indexPath.section][indexPath.row];
#if CGFLOAT_IS_DOUBLE
    return number.doubleValue;
#else
    return number.floatValue;
#endif
}


- (void)invalidateHeightAtIndexPath:(NSIndexPath *)indexPath {
    [self buildCachesAtIndexPathsIfNeeded:@[indexPath]];
    [self enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
        heightsBySection[indexPath.section][indexPath.row] = @-1;
    }];
}

- (void)invalidateAllHeightCache {
    [self enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
        [heightsBySection removeAllObjects];
    }];
}

- (void)buildCachesAtIndexPathsIfNeeded:(NSArray *)indexPaths {
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        [self buildSectionsIfNeeded:indexPath.section];
        [self buildRowsIfNeeded:indexPath.row inExistSection:indexPath.section];
    }];
}

- (void)buildSectionsIfNeeded:(NSInteger)targetSection {
    [self enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
        for (NSInteger section = 0; section <= targetSection; ++section) {
            if (section >= heightsBySection.count) {
                heightsBySection[section] = [NSMutableArray array];
            }
        }
    }];
}

- (void)buildRowsIfNeeded:(NSInteger)targetRow inExistSection:(NSInteger)section {
    [self enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
        NSMutableArray<NSNumber *> *heightsByRow = heightsBySection[section];
        for (NSInteger row = 0; row <= targetRow; ++row) {
            if (row >= heightsByRow.count) {
                heightsByRow[row] = @-1;
            }
        }
    }];
}

@end

@implementation UICollectionView (LTIndexPathHeightCache)

- (LTIndexPathHeightCache *)lt_indexPathHeightCache {
    LTIndexPathHeightCache *cache = objc_getAssociatedObject(self, _cmd);
    if (!cache) {
        [self methodSignatureForSelector:nil];
        cache = [LTIndexPathHeightCache new];
        objc_setAssociatedObject(self, _cmd, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

@end


static void __LT_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(void (^callout)(void)) {
    callout();
}
#define LTPrimaryCall(...) do {__LT_TEMPLATE_LAYOUT_CELL_PRIMARY_CALL_IF_CRASH_NOT_OUR_BUG__(^{__VA_ARGS__});} while(0)

@implementation UICollectionView (LTIndexPathHeightCacheInvalidation)

- (void)lt_reloadDataWithoutInvalidateIndexPathHeightCache {
    LTPrimaryCall([self lt_reloadData];);
}

+ (void)load {
    SEL selectors[] = {
        @selector(reloadData),
        @selector(insertSections:),
        @selector(deleteSections:),
        @selector(reloadSections:),
        @selector(moveSection:toSection:),
        @selector(insertItemsAtIndexPaths:),
        @selector(deleteItemsAtIndexPaths:),
        @selector(reloadItemsAtIndexPaths:),
        @selector(moveItemAtIndexPath:toIndexPath:)
    };
    for (NSUInteger index = 0; index < sizeof(selectors) / sizeof(SEL); ++index) {
        SEL originalSelector = selectors[index];
        SEL swizzledSelector = NSSelectorFromString([@"lt_" stringByAppendingString:NSStringFromSelector(originalSelector)]);
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)lt_reloadData {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection removeAllObjects];
        }];
    }
    LTPrimaryCall([self lt_reloadData];);
}

- (void)lt_insertSections:(NSIndexSet *)sections {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            
            [self.lt_indexPathHeightCache buildSectionsIfNeeded:section];
            [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection insertObject:[NSMutableArray array] atIndex:section];
            }];
        }];
    }
    LTPrimaryCall([self lt_insertSections:sections];);
}

- (void)lt_deleteSections:(NSIndexSet *)sections {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock:^(NSUInteger section, BOOL *stop) {
            [self.lt_indexPathHeightCache buildSectionsIfNeeded:section];
            [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection removeObjectAtIndex:section];
            }];
        }];
    }
    LTPrimaryCall([self lt_deleteSections:sections];);
}

- (void)lt_reloadSections:(NSIndexSet *)sections {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [sections enumerateIndexesUsingBlock: ^(NSUInteger section, BOOL *stop) {
            [self.lt_indexPathHeightCache buildSectionsIfNeeded:section];
            [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[section] removeAllObjects];
            }];
            
        }];
    }
    LTPrimaryCall([self lt_reloadSections:sections];);
}

- (void)lt_moveSection:(NSInteger)section toSection:(NSInteger)newSection {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.lt_indexPathHeightCache buildSectionsIfNeeded:section];
        [self.lt_indexPathHeightCache buildSectionsIfNeeded:newSection];
        [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
            [heightsBySection exchangeObjectAtIndex:section withObjectAtIndex:newSection];
        }];
    }
    LTPrimaryCall([self lt_moveSection:section toSection:newSection];);
}

- (void)lt_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.lt_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[indexPath.section] insertObject:@-1 atIndex:indexPath.row];
            }];
        }];
    }
    LTPrimaryCall([self lt_insertItemsAtIndexPaths:indexPaths];);
}

- (void)lt_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.lt_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        // 移动集合字典
        NSMutableDictionary<NSNumber *, NSMutableIndexSet *> *mutableIndexSetsToRemove = [NSMutableDictionary dictionary];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            NSMutableIndexSet *mutableIndexSet = mutableIndexSetsToRemove[@(indexPath.section)];
            if (!mutableIndexSet) {
                mutableIndexSet = [NSMutableIndexSet indexSet];
                mutableIndexSetsToRemove[@(indexPath.section)] = mutableIndexSet;
            }
            [mutableIndexSet addIndex:indexPath.row];
        }];
        
        [mutableIndexSetsToRemove enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSIndexSet *indexSet, BOOL *stop) {
            [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
                [heightsBySection[key.integerValue] removeObjectsAtIndexes:indexSet];
            }];
        }];
    }
    LTPrimaryCall([self lt_deleteItemsAtIndexPaths:indexPaths];);
}

- (void)lt_reloadItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.lt_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:indexPaths];
        [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
            [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
                heightsBySection[indexPath.section][indexPath.row] = @-1;
            }];
        }];
    }
    LTPrimaryCall([self lt_reloadItemsAtIndexPaths:indexPaths];);
}

- (void)lt_moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (self.lt_indexPathHeightCache.automaticallyInvalidateEnabled) {
        [self.lt_indexPathHeightCache buildCachesAtIndexPathsIfNeeded:@[sourceIndexPath, destinationIndexPath]];
        [self.lt_indexPathHeightCache enumerateAllOrientationsUsingBlock:^(LTIndexPathHeightsBySection *heightsBySection) {
            NSMutableArray<NSNumber *> *sourceRows = heightsBySection[sourceIndexPath.section];
            NSMutableArray<NSNumber *> *destinationRows = heightsBySection[destinationIndexPath.section];
            NSNumber *sourceValue = sourceRows[sourceIndexPath.row];
            NSNumber *destinationValue = destinationRows[destinationIndexPath.row];
            sourceRows[sourceIndexPath.row] = destinationValue;
            destinationRows[destinationIndexPath.row] = sourceValue;
        }];
    }
    LTPrimaryCall([self lt_moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];);
}

@end


