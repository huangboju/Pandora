//
//  HelpAnmina.h
//  XWCollectionViewLayout2
//
//  Created by 温仲斌 on 15/12/31.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelpAnmina : NSObject

+ (HelpAnmina *)shareHeleAnmina;
- (void)animtionWithItem:(UICollectionViewCell *)item withItemArray:(NSArray *)itemArray andCollectionView:(UICollectionView *)collectionView;

@end
