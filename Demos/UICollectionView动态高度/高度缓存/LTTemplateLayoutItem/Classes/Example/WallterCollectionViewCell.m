//
//  WallterCollectionViewCell.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/19.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "WallterCollectionViewCell.h"

@implementation WallterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        NSString *className = NSStringFromClass([self class]);
        
        return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setEntity:(LTWallEntity *)entity
{
    _entity = entity;
    self.imageName.image = entity.imageName.length > 0 ? [UIImage imageNamed:entity.imageName] : nil;
    
}

@end
