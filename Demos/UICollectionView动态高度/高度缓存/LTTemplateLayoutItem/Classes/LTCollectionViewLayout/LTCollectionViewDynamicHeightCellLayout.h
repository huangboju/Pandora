//
//  LTCollectionViewDynamicHeightCellLayout.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/20.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTCollectionViewDynamicHeightCellLayout;

@protocol LTCollectionViewDynamicHeightCellLayoutDelegate <NSObject>

@required
- (NSInteger)numberOfColumnWithCollectionView:(UICollectionView *)collectionView
                         collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout;
@required
- (CGFloat)marginOfCellWithCollectionView:(UICollectionView *)collectionView
                     collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout;
@required
- (NSMutableArray <NSMutableArray *> *)indexHeightOfCellWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout;


@end

@interface LTCollectionViewDynamicHeightCellLayout : UICollectionViewLayout

@property (nonatomic, weak) id<LTCollectionViewDynamicHeightCellLayoutDelegate> dynamicLayoutDelegate;

@end
