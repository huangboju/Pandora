//
//  LTFeedCell.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/18.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "LTFeedCell.h"

@interface LTFeedCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) IBOutlet UIImageView *contentImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;


@end

@implementation LTFeedCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        NSString *className = NSStringFromClass([self class]);
       
        return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:nil] firstObject];;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews]; // 注意，一定不要忘记调用父类的layoutSubviews方法！
    
}

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    
    // Fix the bug in iOS7 - initial constraints warning
    self.contentView.bounds = [UIScreen mainScreen].bounds;
}

- (void)setEntity:(LTFeedEntity *)entity
{
    _entity = entity;
    
    self.titleLabel.text = entity.title;
    self.contentLabel.text = entity.content;
    self.contentImageView.image = entity.imageName.length > 0 ? [UIImage imageNamed:entity.imageName] : nil;
    self.usernameLabel.text = entity.username;
    self.timeLabel.text = entity.time;
}



@end
