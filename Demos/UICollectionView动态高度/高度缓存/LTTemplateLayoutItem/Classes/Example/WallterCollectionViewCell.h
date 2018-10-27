//
//  WallterCollectionViewCell.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/19.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTWallEntity.h"
@interface WallterCollectionViewCell : UICollectionViewCell


@property (nonatomic, strong) LTWallEntity *entity;
@property (weak, nonatomic) IBOutlet UIImageView *imageName;

@end
