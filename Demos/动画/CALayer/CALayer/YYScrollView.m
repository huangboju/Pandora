//
//  YYImageView.m
//  CALayer
//
//  Created by hdf on 16/1/5.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "YYScrollView.h"

@interface YYScrollView ()

@property (nonatomic , weak)CAScrollLayer *scrollLayer;

@property (nonatomic , weak) UIImageView *imageView;

@property (nonatomic , assign) CGPoint point;

@property (nonatomic , assign) CGPoint beginPoint;

@end

@implementation YYScrollView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addScrollLayer];
    }
    return self;
}

- (void)awakeFromNib{
    [self addScrollLayer];
}

- (void)addScrollLayer{
    _point = CGPointZero;
    CAScrollLayer *scrollLayer = [CAScrollLayer layer];
//    scrollLayer.scrollMode = kCAScrollHorizontally;
    scrollLayer.bounds = self.bounds;
    scrollLayer.position = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    scrollLayer.backgroundColor = [UIColor redColor].CGColor;
    
    [self.layer addSublayer:scrollLayer];
    _scrollLayer = scrollLayer;
    
    
    UIImageView *imageView = [[UIImageView alloc]init];
//    [self addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView = imageView;
    _imageView.frame = CGRectMake(0, 0, 1000, 1000);
    _imageView.image =[UIImage imageNamed:@"IU"];
    _imageView.userInteractionEnabled = YES;
    [scrollLayer addSublayer:imageView.layer];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
//    [self addGestureRecognizer:pan];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    __weak typeof(self)ws = self;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       ws.beginPoint = [[touches anyObject] locationInView:self];
    });
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint p1 = [touch locationInView:self];
//    CGPoint p2 = [touch preciseLocationInView:self];
    _point.x += _beginPoint.x - p1.x;
    _point.y += _beginPoint.y - p1.y;
    [_scrollLayer scrollToPoint:_point];
    NSLog(@"%@",NSStringFromCGPoint(_point));
    _beginPoint = p1;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint p1 = [touch locationInView:self];
//    _beginPoint = _point;
//    return;
//    _point.x += _beginPoint.x - p1.x;
//    _point.y += _beginPoint.y - p1.y;
//    [_scrollLayer scrollToPoint:_point];
//    NSLog(@"%@",NSStringFromCGPoint(_point));
}

//- (void)pan:(UIPanGestureRecognizer *)pan {
//    _point.x -= [pan translationInView:self].x;
//    _point.y -= [pan translationInView:self].y;
//    
//    [_scrollLayer scrollToPoint:_point];
//    
////    [pan setTranslation:CGPointZero inView:self];
//}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com