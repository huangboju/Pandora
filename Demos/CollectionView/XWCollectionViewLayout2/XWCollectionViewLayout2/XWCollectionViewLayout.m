//
//  XWCollectionViewLayout.m
//  XWCollectionViewLayout2
//
//  Created by 温仲斌 on 15/12/31.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import "XWCollectionViewLayout.h"

@implementation XWCollectionViewLayout {
    NSMutableArray *arrayItems;
}

- (void)prepareLayout {
    [super prepareLayout];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    arrayItems = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewLayoutAttributes *item = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        [arrayItems addObject:item];
//        [self layoutAttributesForItemAtIndexPath:indexPath];
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < arrayItems.count; i++) {
        UICollectionViewLayoutAttributes *item =  arrayItems[i];
        item.frame = CGRectMake(0, i * 100, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 100 - 64);
        item.zIndex = item.indexPath.item + 1;
        [arr addObject:item];
    }
    
    return arr;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, (arrayItems.count-1) * 100 + CGRectGetHeight([UIScreen mainScreen].bounds) - 100 - 64);
}

@end
