//
//  CustomNavigationBar.m
//  CustomNavigationBarDemo
//
//  Created by yunzhi on 17/2/22.
//  Copyright © 2017年 GrongRong. All rights reserved.
//

#import "CustomNavigationBar.h"

const CGFloat NavigationBarHeightIncrease = 40.f;

@implementation CustomNavigationBar

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    
    [self setTransform:CGAffineTransformMakeTranslation(0, -(NavigationBarHeightIncrease))];
}


- (void)layoutSubviews{
    [super layoutSubviews];

    NSArray *classNamesToReposition = @[@"_UIBarBackground",@"_UINavigationBarBackground"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect bounds = [self bounds];
            CGRect frame = [view frame];
            frame.origin.y = bounds.origin.y + NavigationBarHeightIncrease - 20.f;
            frame.size.height = bounds.size.height + 20.f;
            
            [view setFrame:frame];
        }
    }
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize navigationBarSize = [super sizeThatFits:size];
    
    navigationBarSize.height += NavigationBarHeightIncrease;
    
    return navigationBarSize;
}

@end
