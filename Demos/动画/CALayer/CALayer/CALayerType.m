//
//  CALayerType.m
//  CALayer
//
//  Created by Lqq on 16/1/1.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CALayerType.h"

@interface CALayerType ()

@end

@implementation CALayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLayer];
    [self addMarkLayer];
}

/** 基本动画 */
- (void)setBasicAnimationAtLayer:(CALayer *)layer{
    //基本动画
    //animationWithKeyPath : @"layer的属性名"如:position anchorPoint
    //fromValue toValue byValue 与 @"layer的属性名" 对应的类型 ps:不是对象的封装成value对象
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    //动画持续时间
    basicAnimation.duration = 2;
    
    //重复次数
    basicAnimation.repeatCount = 20;
    
    //重复动画的时候以动画的形式返回
    basicAnimation.autoreverses = YES;
    
//        animation.removedOnCompletion = NO;
//        animation.additive = YES;
    //    animation.cumulative = YES;
    basicAnimation.timingFunction = [[CAMediaTimingFunction alloc]initWithControlPoints:1 :1 :1 :1];
    //    animation.fromValue = [CAValueFunction functionWithName:@""];
    basicAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(300, 300, 100)];
    //[layer addAnimation:animation forKey:@"key"]; 可以通过[layer animationForKey:@"key"];方法获取
    [layer addAnimation:basicAnimation forKey:@"basicAnimation"];
}

/** layer */
- (void)addLayer{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 90, 90);
    //position决定layer在superLayer上的位置 这个点默认是layer的中点
    //anchorPoint(默认0.5,0.5)决定position在layer上的位置 如(0,0):layer的左上角在superLayer上的位置就是position
    layer.position = CGPointMake(100, 100);
    //    layer.zPosition = 2;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    //    layer.anchorPointZ = 0.5;
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:layer];
    
    //基本动画
    [self setBasicAnimationAtLayer:layer];
}

/** 标示点 */
- (void)addMarkLayer{
    CALayer *layer1 = [CALayer layer];
    layer1.bounds = CGRectMake(0, 0, 5, 5);
    layer1.position = CGPointMake(100, 100);
    layer1.anchorPoint = CGPointMake(0.5, 0.5);
    layer1.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:layer1];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com