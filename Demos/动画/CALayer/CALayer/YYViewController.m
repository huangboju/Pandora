//
//  YYViewController.m
//  CALayer
//
//  Created by hdf on 15/12/31.
//  Copyright © 2015年 董知樾. All rights reserved.
//

#import "YYViewController.h"

NSString * const CALayerType = @"CALayerType";
NSString * const CATextLayerType = @"CATextLayerType";
NSString * const CAShapeLayerType = @"CAShapeLayerType";
NSString * const CATiledLayerType = @"CATiledLayerType";
NSString * const CAGradientLayerType = @"CAGradientLayerType";

@interface YYViewController ()

@property (nonatomic , weak) CATiledLayer *tiledLayer;

@end

@implementation YYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _layerType;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([_layerType isEqualToString:CALayerType]) {
        [self addLayer];
    } else if ([_layerType isEqualToString:CATextLayerType]) {
        [self addTextLayer];
    } else if ([_layerType isEqualToString:CAShapeLayerType]) {
        [self addLayerFromBezierPath];
    } else if ([_layerType isEqualToString:CATiledLayerType]) {
        [self cutImageAndSave];
        [self addTiledLayer];
    } else if ([_layerType isEqualToString:CAGradientLayerType]) {
        [self addGradientLayer];
    }
    
    
    //CALayer 所有layer的父类
    //    [self addLayer];
    
    //    [self addMarkLayer];
    
    //根据贝塞尔曲线绘制shapeLayer
    //    [self addLayerFromBezierPath];
    
    //分割图片
    //    [self cutImageAndSave];
    
    //平铺大图
    //    [self addTiledLayer];
    
    //渐变色
    //    [self addGradientLayer];
    
    
//    [self addTextLayer];
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

/** 渐变色CAGradientLayer */
- (void)addGradientLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSInteger count = 20;
    NSMutableArray *colors = [NSMutableArray array];
    NSMutableArray *locations = [NSMutableArray array];
    for (NSInteger i = 0; i < count ; i ++) {
        UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [colors addObject:(__bridge id)color.CGColor];
        //        if (i % 2 == 0) {
        //            continue;
        //        }
        [locations addObject:@(i /(CGFloat)count)];
    }
    //颜色数组
    gradientLayer.colors = colors;
    //可以不设置
    gradientLayer.locations = locations;
    //startPoint endPoint 确定条纹方向 不设置 默认水平默认值[.5,0]和[.5,1]
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
    gradientLayer.type = kCAGradientLayerAxial;
    
    gradientLayer.bounds = CGRectMake(0, 0, 400, 400);
    gradientLayer.position = CGPointMake(200, 200);
    
    [self.view.layer addSublayer:gradientLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.duration = 2;
    
    NSMutableArray *toValue = [NSMutableArray array];
    
    for (NSInteger i = 0; i < count ; i ++) {
        
        UIColor *color = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        
        [toValue addObject:(__bridge id)color.CGColor];
        
    }
    animation.autoreverses = YES;
    animation.toValue = toValue;
    [gradientLayer addAnimation:animation forKey:@"gradientLayer"];
    
    /**
     CGColorRef对象的数组定义每个层次的颜色(渐变),默认为空,可以做成动画.
     @property(nullable, copy) NSArray *colors;
     
     一个可选的数组用来盛放NSNumber对象,定义每个层次的值域[0,1].值必须是单调递增.如果是一个空数组,均匀分布在[0,1]区间.在呈现时,颜色是映射到输出颜色空间插值.默认空.可以做成动画.
     An optional array of NSNumber objects defining the location of each
     * gradient stop as a value in the range [0,1]. The values must be
     * monotonically increasing. If a nil array is given, the stops are
     * assumed to spread uniformly across the [0,1] range. When rendered,
     * the colors are mapped to the output colorspace before being
     * interpolated. Defaults to nil. Animatable.
     
     @property(nullable, copy) NSArray<NSNumber *> *locations;
     
     startPoint和endPoint 决定渐变gradient 绘制时的坐标空间.startPoint对应于第一层次,endPoint对应最后层次。这两个点是定义在一个单元坐标空间,然后映射到层的边界矩形.(即[0,0]是手机的左下角,[1,1]是右上角).(默认值[0.5,0]和[0.5,1].都可以做成动画.
     The start and end points of the gradient when drawn into the layer's
     * coordinate space. The start point corresponds to the first gradient
     * stop, the end point to the last gradient stop. Both points are
     * defined in a unit coordinate space that is then mapped to the
     * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
     * corner of the layer, [1,1] is the top-right corner.) The default values
     * are [.5,0] and [.5,1] respectively. Both are animatable.
     
     @property CGPoint startPoint;
     @property CGPoint endPoint;
     
     这种层次将它们分开。目前只允许的值是“轴”(默认值)。
     The kind of gradient that will be drawn. Currently the only allowed
     * value is `axial' (the default value).
     
     @property(copy) NSString *type;
     
     */
}

/**
 *  平铺layer 可用于展示大图
 *  展示大图时可能会引起卡顿(阻塞主线程),将大图切分成小图,然后用到他们(需要展示)的时候再加载(读取)
 */
- (void)addTiledLayer{
    //BingWallpaper-2015-11-22.jpg
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    //    UIImage *image = [UIImage imageNamed:@"BingWallpaper-2015-11-22.jpg"];
    
    CATiledLayer *tiledLayer = [CATiledLayer layer];
    //layer->像素 和 点 的概念不同 一个点是[UIScreen mainScreen].scale个像素
    //    CGFloat screenScale = [UIScreen mainScreen].scale;
    //    tiledLayer.contentsScale = screenScale;
    tiledLayer.frame = CGRectMake(0, 0, 1920, 1200);//image.size.width, image.size.height);
    tiledLayer.delegate = self;
    
    _tiledLayer = tiledLayer;
    
    scrollView.contentSize = tiledLayer.frame.size;
    //CGSizeMake(image.size.width / screenScale, image.size.height / screenScale);
    [scrollView.layer addSublayer:tiledLayer];
    [tiledLayer setNeedsDisplay];
}

/**
 *  CALayerDelegate
 *  支持多线程绘制，-drawLayer:inContext:方法可以在多个线程中同时地并发调用
 *  所以请小心谨慎地确保你在这个方法中实现的绘制代码是线程安全的。(不懂哎)
 */
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx{
    
    //获取图形上下文的位置与大小
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    //floor 向下取整
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
    // * [UIScreen mainScreen].scale);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    // * [UIScreen mainScreen].scale);
    
    //load tile image
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *imageName = [NSString stringWithFormat:@"%@/初雪-%02ld-%02ld.png",filePath,x,y];
    UIImage *tileImage = [UIImage imageNamed:imageName];
    NSLog(@"%@",imageName);
    
    UIGraphicsPushContext(ctx);
    //绘制
    
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

/** 切图并保存到沙盒中 */
- (void)cutImageAndSave{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *imageName = [NSString stringWithFormat:@"%@/初雪-%00-%00.png",filePath];
    UIImage *tileImage = [UIImage imageNamed:imageName];
    if (tileImage) return;
    
    UIImage *image = [UIImage imageNamed:@"BingWallpaper-2015-11-22.jpg"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    [self.view addSubview:imageView];
    CGFloat WH = 256;
    CGSize size = image.size;
    
    //ceil 向上取整
    NSInteger rows = ceil(size.height / WH);
    NSInteger cols = ceil(size.width / WH);
    
    for (NSInteger y = 0; y < rows; ++y) {
        for (NSInteger x = 0; x < cols; ++x) {
            UIImage *subImage = [self captureView:imageView frame:CGRectMake(x*WH, y*WH, WH, WH)];
            NSString *path = [NSString stringWithFormat:@"%@/初雪-%02ld-%02ld.png",filePath,x,y];
            [UIImagePNGRepresentation(subImage) writeToFile:path atomically:YES];
        }
    }
}

/** 切图 */
- (UIImage*)captureView:(UIView *)theView frame:(CGRect)fra{
    //开启图形上下文 将heView的所有内容渲染到图形上下文中
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, fra);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    
    return i;
}

/** 贝塞尔曲线 */
- (void)addLayerFromBezierPath{
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(10, 20)];
    [bezierPath addCurveToPoint:CGPointMake(200, 300) controlPoint1:CGPointMake(5, 0) controlPoint2:CGPointMake(200, 0)];
    bezierPath.lineWidth = 2;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = nil;
    
    //根据bezierPath 获取 CAShapeLayer
    CGPathRef pathRef = CGPathCreateCopyByStrokingPath(shapeLayer.path, NULL, bezierPath.lineWidth, kCGLineCapRound, kCGLineJoinRound, shapeLayer.miterLimit);
    //获取 路径的范围CGPathGetBoundingBox()
    shapeLayer.bounds = CGPathGetBoundingBox(pathRef);
    CGPathRelease(pathRef);
    
    UIView *markView = [[UIView alloc]initWithFrame:CGRectMake(100, 150, 2, 2)];
    markView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:markView];
    
    [self.view.layer addSublayer:shapeLayer];
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
    
    //    animation.removedOnCompletion = NO;
    //    animation.additive = YES;
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
    layer.backgroundColor = [UIColor redColor].CGColor;
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
    layer1.backgroundColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:layer1];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_tiledLayer removeFromSuperlayer];
}

@end// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com