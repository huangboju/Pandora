//
//  XLBaseViewController.h
//  SCaptain
//
//  Created by mxl on 2017/3/20.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XLBaseViewController : UIViewController
/**
 修改导航栏颜色

 @param backColor 导航颜色
 */
- (void)changeNaviBackColor:(UIColor *)backColor;

+ (void)presentVC:(UIViewController *)viewController;

- (void)tabBarItemClicked;

- (void)configSubViews;

@end
