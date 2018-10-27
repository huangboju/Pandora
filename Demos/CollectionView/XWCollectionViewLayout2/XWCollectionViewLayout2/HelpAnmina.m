//
//  HelpAnmina.m
//  XWCollectionViewLayout2
//
//  Created by 温仲斌 on 15/12/31.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import "HelpAnmina.h"


typedef enum : NSUInteger {
    itemWillAnmintion,
    itemDidAnmintion,
} itemAnmintion;

@implementation HelpAnmina{
    itemAnmintion itemAnimtionStatue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
            itemAnimtionStatue = itemWillAnmintion;
    }
    return self;
}


+ (HelpAnmina *)shareHeleAnmina {
    static HelpAnmina *helpManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helpManger = [[HelpAnmina alloc]init];
    });
    return helpManger;
}

- (void)animtionWithItem:(UICollectionViewCell *)item withItemArray:(NSArray *)itemArray andCollectionView:(UICollectionView *)collectionView {
    switch (itemAnimtionStatue) {
        case itemDidAnmintion:{
            [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:1 / 0.85 options:0 animations:^{
                item.transform = CGAffineTransformIdentity;
                [itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UICollectionViewCell *xw = obj;
                    xw.transform = CGAffineTransformIdentity;
                }];
            } completion:^(BOOL finished) {
                itemAnimtionStatue = itemWillAnmintion;
                collectionView.scrollEnabled = YES;

            }];
        }
            
            break;
        
        default:{
            [UIView animateWithDuration:.3 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:1 / 0.85 options:0 animations:^{
                item.transform = CGAffineTransformMakeTranslation(0, -(item.frame.origin.y - collectionView.contentOffset.y  - 69));
                [itemArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    UICollectionViewCell *xw = obj;
//                    NSLog(@"%@", @([UIScreen mainScreen].bounds.size.height - (xw.frame.origin.y - collectionView.contentOffset.y) - itemArray.count * 5 + 5 * idx));
                    
                    NSLog(@"+++++%@", @((xw.frame.origin.y - collectionView.contentOffset.y)));
                    xw.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height - (xw.frame.origin.y - collectionView.contentOffset.y)  - itemArray.count * 5 + 5 * idx);
                }];
            } completion:^(BOOL finished) {
                itemAnimtionStatue = itemDidAnmintion;
                collectionView.scrollEnabled = NO;
            }];

        }
            break;
    }
    }

@end
