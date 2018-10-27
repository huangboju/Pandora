//
//  CAReplicatorLayerType.m
//  CALayer
//
//  Created by hdf on 16/1/4.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CAReplicatorLayerType.h"

#import <objc/runtime.h>

@interface CAReplicatorLayerType ()

@property (nonatomic , weak) UIImageView *imageView;

@property (nonatomic , weak) CAReplicatorLayer *replicatorLayer;

@end

@implementation CAReplicatorLayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addReplicatorLayer];
    
    
    for (NSInteger i = 0; i < 3 ; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100 + 60 * i, self.view.frame.size.height - 40, 55, 40);
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:[NSString stringWithFormat:@"动画%ld",i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(selectAnimation:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 1;
        [self.view addSubview:btn];
    }
}

- (void)selectAnimation:(UIButton *)btn{
    [_imageView.layer removeAllAnimations];
    [_replicatorLayer removeAllAnimations];
    [_replicatorLayer removeFromSuperlayer];
    [_imageView removeFromSuperview];
    [self addImageView];
    [self addReplicatorLayer];
    SEL method = NSSelectorFromString([NSString stringWithFormat:@"animation%ld",btn.tag]);
    [self performSelector:method withObject:self];
}

- (void)addImageView {
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView = imageView;
}

- (void)addReplicatorLayer {
    
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    
    replicatorLayer.bounds = self.view.bounds;
    replicatorLayer.position = self.view.center;
    
    
    replicatorLayer.preservesDepth = YES;
    

//    replicatorLayer.instanceColor = [UIColor whiteColor].CGColor;
//    replicatorLayer.instanceRedOffset = 0.1;
//    replicatorLayer.instanceGreenOffset = 0.1;
//    replicatorLayer.instanceBlueOffset = 0.1;
//    replicatorLayer.instanceAlphaOffset = 0.1;
    
    
    
    
    [replicatorLayer addSublayer:_imageView.layer];
    [self.view.layer addSublayer:replicatorLayer];
    _replicatorLayer = replicatorLayer;
    
//    [self animation3];
    
}

- (void)animation1{
    
    _imageView.frame = CGRectMake(10, 200, 100, 100);
    _imageView.image =[UIImage imageNamed:@"IU"];
    _replicatorLayer.instanceDelay = 1;
    _replicatorLayer.instanceCount = 3;
    _replicatorLayer.instanceTransform = CATransform3DMakeTranslation(120, 0, 0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"instanceTransform"];
    animation.duration = 2;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(100, 0, 0)];
    [_replicatorLayer addAnimation:animation forKey:nil];
}

- (void)animation2{
    
    _imageView.frame = CGRectMake(172, 200, 20, 20);
    _imageView.backgroundColor = [UIColor orangeColor];
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    
    CGFloat count = 15.0;
    _replicatorLayer.instanceDelay = 1.0 / count;
    _replicatorLayer.instanceCount = count;
    //相对于_replicatorLayer.position旋转
    _replicatorLayer.instanceTransform = CATransform3DMakeRotation((2 * M_PI) / count, 0, 0, 1.0);
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
//    animation.autoreverses = YES;
    //从原大小变小时,动画 回到原状时不要动画
    animation.fromValue = @(1);
    animation.toValue = @(0.01);
    [_imageView.layer addAnimation:animation forKey:nil];
}

- (void)animation3{
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.frame = CGRectMake(20, 650, 15, 15);
    _imageView.backgroundColor = [UIColor orangeColor];
    _imageView.layer.cornerRadius = 7.5;
    _imageView.layer.masksToBounds = YES;
    
    CGFloat count = 30.0;
    CGFloat duration = 3;
    _replicatorLayer.instanceDelay = duration / count;
    _replicatorLayer.instanceCount = count;
    _replicatorLayer.instanceAlphaOffset = 0.1;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 650)];
    [path addLineToPoint:CGPointMake(20, 100)];
    [path addCurveToPoint:CGPointMake(200, 400) controlPoint1:CGPointMake(200, 20) controlPoint2:CGPointMake(20, 400)];
    [path addLineToPoint:CGPointMake(355, 100)];
    [path addLineToPoint:CGPointMake(250, 400)];
    [path addLineToPoint:CGPointMake(400, 500)];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = CGPathCreateCopyByTransformingPath(path.CGPath, NULL);
    keyFrameAnimation.duration = duration;
    keyFrameAnimation.repeatCount = 20;
    [_imageView.layer addAnimation:keyFrameAnimation forKey:nil];
    
}

/*
 The replicator layer creates a specified number of copies of its sublayers, each copy potentially having geometric, temporal and color transformations applied to it.
 *
 Note: the CALayer -hitTest: method currently only tests the first instance of z replicator layer's sublayers. This may change in the future.
 
 @interface CAReplicatorLayer : CALayer
 
 The number of copies to create, including the source object. Default value is one (i.e. no extra copies). Animatable.
 创建副本的数量,包括原对象
 @property NSInteger instanceCount;
 
 Defines whether this layer flattens its sublayers into its plane or not (i.e. whether it's treated similarly to a transform layer or not). Defaults to NO. If YES, the standard restrictions apply (see CATransformLayer.h). *
 
 @property BOOL preservesDepth;
 
 * The temporal delay between replicated copies. Defaults to zero.
 * Animatable. *
 
 @property CFTimeInterval instanceDelay;
 
 * The matrix applied to instance k-1 to produce instance k. The matrix is applied relative to the center of the replicator layer, i.e. the superlayer of each replicated sublayer. Defaults to the identity matrix. Animatable. *
 
 @property CATransform3D instanceTransform;
 
 * The color to multiply the first object by (the source object). Defaults to opaque white. Animatable. *
 
 @property(nullable) CGColorRef instanceColor;
 
 * The color components added to the color of instance k-1 to produce
 * the modulation color of instance k. Defaults to the clear color (no
 * change). Animatable. *
 
 @property float instanceRedOffset;
 @property float instanceGreenOffset;
 @property float instanceBlueOffset;
 @property float instanceAlphaOffset;
 */


@end























// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com