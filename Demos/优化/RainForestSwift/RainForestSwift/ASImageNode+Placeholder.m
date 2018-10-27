//
//  ASImageNode+Placeholder.m
//  RainforestFinished
//
//  Created by Luke Parham on 12/28/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

#import "ASImageNode+Placeholder.h"

@implementation ASImageNode (Placeholder)

- (UIImage *)placeholderImage
{
    static UIImage *placeholderImage;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(10, 10), NO, 0.0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
        CGContextFillRect(context, CGRectMake(0, 0, 10, 10));
        
        placeholderImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    
    return placeholderImage;
}

@end
