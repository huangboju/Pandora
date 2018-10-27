//
//  LTCollectionViewDynamicHeightCellLayout.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/20.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "LTCollectionViewDynamicHeightCellLayout.h"

typedef NSMutableArray <NSMutableArray<NSNumber *> *> IndexCountBySection;

@interface LTCollectionViewDynamicHeightCellLayout ()

@property (assign, nonatomic) NSInteger numberOfSections;

@property (assign, nonatomic) NSInteger numberOfCellsInSections;

@property (assign, nonatomic) NSInteger columnCount;

@property (assign, nonatomic) NSInteger margin;

@property (assign, nonatomic) CGFloat cellWidth;

@property (strong, nonatomic) NSMutableArray *cellHeightArray;

@property (strong, nonatomic) NSMutableArray *cellXArray;

@property (nonatomic, strong) IndexCountBySection *indexCountBySectionForHeight;

@property (strong, nonatomic) NSMutableArray *cellYArray;

@end

@implementation LTCollectionViewDynamicHeightCellLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    [self initData];
    [self initCellWidth];
    
}

- (CGSize)collectionViewContentSize {
    CGFloat height = [self maxCellYArrayWithArray:_cellYArray];
    return CGSizeMake([[UIScreen mainScreen] bounds].size.width,  height);
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    [self initCellYArray];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < _indexCountBySectionForHeight.count; i++) {
        for (NSInteger j = 0; j < _indexCountBySectionForHeight[i].count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            [array addObject:attributes];
        }
    }
    return array;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    _cellHeightArray = _indexCountBySectionForHeight[indexPath.section];
    CGRect frame = CGRectZero;
    CGFloat cellHeight = [_cellHeightArray[indexPath.row] floatValue];
    NSInteger minYIndex = [self minCellYArrayWithArray:_cellYArray];
    CGFloat tempX = [_cellXArray[minYIndex] floatValue];
    CGFloat tempY = [_cellYArray[minYIndex] floatValue];
    frame = CGRectMake(tempX, tempY, _cellWidth, cellHeight);
    _cellYArray[minYIndex] = @(tempY + cellHeight + _margin);
    attributes.frame = frame;
    
    return attributes;
    
}


#pragma mark -- 自定义方法
- (void)initData {
    _columnCount = [_dynamicLayoutDelegate numberOfColumnWithCollectionView:self.collectionView
                                                collectionViewLayout:self];
    
    _margin = [_dynamicLayoutDelegate marginOfCellWithCollectionView:self.collectionView
                                         collectionViewLayout:self];
    
    _indexCountBySectionForHeight = [_dynamicLayoutDelegate indexHeightOfCellWithCollectionView:self.collectionView
                                                       collectionViewLayout:self];
}

- (void)initCellWidth {
    _cellWidth = ([[UIScreen mainScreen] bounds].size.width - (_columnCount -1) * _margin) / _columnCount;
    _cellXArray = [[NSMutableArray alloc] initWithCapacity:_columnCount];
    for (int i = 0; i < _columnCount; i ++) {
        CGFloat tempX = i * (_cellWidth + _margin);
        [_cellXArray addObject:@(tempX)];
    }
}


- (void) initCellYArray {
    _cellYArray = @[].mutableCopy;
    for (int i = 0; i < _columnCount; i ++) {
        [_cellYArray addObject:@(0)];
    }
}


- (CGFloat)maxCellYArrayWithArray:(NSMutableArray *) array {
    if (array.count == 0) {
        return 0.0f;
    }
    
    CGFloat max = [array[0] floatValue];
    for (NSNumber *number in array) {
        
        CGFloat temp = [number floatValue];
        if (max < temp) {
            max = temp;
        }
    }
    return max;
    
}


- (CGFloat)minCellYArrayWithArray:(NSMutableArray *) array {
    
    if (array.count == 0) {
        return 0.0f;
    }
    NSInteger minIndex = 0;
    CGFloat min = [array[0] floatValue];
    for (int i = 0; i < array.count; i ++) {
        CGFloat temp = [array[i] floatValue];
        if (min > temp) {
            min = temp;
            minIndex = i;
        }
    }

    return minIndex;
    
}


@end
