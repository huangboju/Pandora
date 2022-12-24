//
//  LongCell.m
//  TopMenu
//
//  Created by home on 2017/9/29.
//  Copyright © 2017年 home. All rights reserved.
//

#import "LongCell.h"
#import "Masonry.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
@interface LongCell()
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UILabel * name;
@property(nonatomic,strong) UILabel * price;
@end
@implementation LongCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self makeUI];
    }
    return self;
}
-(void)makeUI{
    self.imageView = ({
        UIImageView * imageView = [UIImageView new];
       imageView.image = [UIImage imageNamed:@"iPhone.jpg"];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo((kWidth-30)/2);
            make.top.left.equalTo(self);
        }];
        imageView;
    });
    
    self.name = ({
        UILabel * name = [UILabel new];
        name.text = @"iPhoneX";
        name.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_imageView.mas_right).offset(10);
            make.top.equalTo(self.contentView).offset(10);
        }];
        name;
    });
    
    self.price = ({
        UILabel * price = [UILabel new];
        price.text = @"¥9999";
        price.textColor = [UIColor redColor];
        price.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_name).offset(20);
            make.left.equalTo(_imageView.mas_right).offset(10);
        }];
        price;
    });
}
-(void)reloadDatewith:(NSDictionary*)dict{
   
}
@end
