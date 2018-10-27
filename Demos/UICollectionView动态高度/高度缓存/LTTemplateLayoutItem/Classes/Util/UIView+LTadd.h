//
//  UIView+LTadd.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/20.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LTadd)

@property (nonatomic) CGFloat top;         ///< Shortcut for frame.origin.y

@property (nonatomic) CGFloat left;        ///< Shortcut for frame.origin.x.

@property (nonatomic) CGFloat bottom;      ///< Shortcut for frame.origin.y + frame.size.height

@end
