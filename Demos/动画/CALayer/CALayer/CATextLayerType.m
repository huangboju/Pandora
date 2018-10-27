//
//  CATextLayerType.m
//  CALayer
//
//  Created by Lqq on 16/1/1.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CATextLayerType.h"

@interface CATextLayerType ()

@end

@implementation CATextLayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTextLayer];
}

/** CATextLayer */
- (void)addTextLayer{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = @"CATextLayer";
    textLayer.font = (__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:14]);
    textLayer.fontSize = 20;
    textLayer.foregroundColor = [UIColor redColor].CGColor;
    textLayer.wrapped = NO;
    
    //允许字体 像素数字化
    textLayer.allowsFontSubpixelQuantization = YES;
    
    CGSize size = [@"CATextLayer" boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20]} context:nil].size;
    textLayer.bounds = (CGRect){{0,0},size};
    textLayer.position = CGPointMake(100, 100);
    [self.view.layer addSublayer:textLayer];
    
    //    self.view.backgroundColor = [UIColor cyanColor];
    //    textLayer.position =
    /*
     @property(nullable, copy) id string;
     @property(nullable) CFTypeRef font;
     @property CGFloat fontSize;
     @property(nullable) CGColorRef foregroundColor;
     @property(getter=isWrapped) BOOL wrapped;
     //缩略方式
     @property(copy) NSString *truncationMode;
     //对齐方式
     @property(copy) NSString *alignmentMode;
     @property BOOL allowsFontSubpixelQuantization;
     
     CA_EXTERN NSString * const kCATruncationNone
     CA_EXTERN NSString * const kCATruncationStart
     CA_EXTERN NSString * const kCATruncationEnd
     CA_EXTERN NSString * const kCATruncationMiddle
     
     CA_EXTERN NSString * const kCAAlignmentNatural
     CA_EXTERN NSString * const kCAAlignmentLeft
     CA_EXTERN NSString * const kCAAlignmentRight
     CA_EXTERN NSString * const kCAAlignmentCenter
     CA_EXTERN NSString * const kCAAlignmentJustified
     */
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com