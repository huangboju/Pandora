//
//  PGCategoryView.h
//  分级菜单
//
//  Created by chun on 15/2/28.
//  Copyright (c) 2015年 guang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PGCategoryView;

@interface PGCategoryView : UIView

@property (nonatomic,strong) UIView *rightView;
@property (strong, nonatomic) UIImageView *toggleView;

+(PGCategoryView *)categoryRightView:(UIView *)rightView;
-(void)show;
-(void)hide;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com