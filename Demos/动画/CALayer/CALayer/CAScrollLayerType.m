//
//  CAScrollLayerType.m
//  CALayer
//
//  Created by hdf on 16/1/4.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CAScrollLayerType.h"

#import "YYScrollView.h"

@interface CAScrollLayerType ()

@property (nonatomic , weak)CAScrollLayer *scrollLayer;

@property (nonatomic , weak) UIImageView *imageView;

@end

@implementation CAScrollLayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //未完成
    YYScrollView *view = [[YYScrollView alloc]initWithFrame:CGRectMake(0, 84, 300, 400)];
    [self.view addSubview:view];
//    UIImageView *imageView = [[UIImageView alloc]init];
//    [self.view addSubview:imageView];
//    
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    _imageView = imageView;
//    _imageView.frame = CGRectMake(10, 200, 100, 100);
//    _imageView.image =[UIImage imageNamed:@"IU"];
//    
//    [self addScrollLayer];
}

- (void)addScrollLayer {
    CAScrollLayer *scrollLayer = [CAScrollLayer layer];
    scrollLayer.scrollMode = kCAScrollHorizontally;
    scrollLayer.bounds = CGRectMake(0, 0 , 200, 200);
    scrollLayer.position = CGPointMake(150, 150);
    scrollLayer.backgroundColor = [UIColor redColor].CGColor;
    
    
    
    
    
    
    [self.view.layer addSublayer:scrollLayer];
    _scrollLayer = scrollLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [_scrollLayer scrollPoint:CGPointMake(200, 200)];
    [_scrollLayer scrollToRect:CGRectMake(90, 90, 90, 90)];
}

/*
 * Changes the origin of the layer to point 'p'. *

- (void)scrollToPoint:(CGPoint)p;

* Scroll the contents of the layer to ensure that rect 'r' is visible. *

- (void)scrollToRect:(CGRect)r;

 Defines the axes in which the layer may be scrolled. Possible values
 * are `none', `vertically', `horizontally' or `both' (the default).

@property(copy) NSString *scrollMode;

@end

@interface CALayer (CALayerScrolling)

 These methods search for the closest ancestor CAScrollLayer of the *
 * receiver, and then call either -scrollToPoint: or -scrollToRect: on
 * that layer with the specified geometry converted from the coordinate
 * space of the receiver to that of the found scroll layer.

- (void)scrollPoint:(CGPoint)p;

- (void)scrollRectToVisible:(CGRect)r;

 Returns the visible region of the receiver, in its own coordinate
 * space. The visible region is the area not clipped by the containing
 * scroll layer.

@property(readonly) CGRect visibleRect;

@end

 `scrollMode' values.

CA_EXTERN NSString * const kCAScrollNone
__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
CA_EXTERN NSString * const kCAScrollVertically
__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
CA_EXTERN NSString * const kCAScrollHorizontally
__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
CA_EXTERN NSString * const kCAScrollBoth
__OSX_AVAILABLE_STARTING (__MAC_10_5, __IPHONE_2_0);
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com