//
//  CAEmitterLayerType.m
//  CALayer
//
//  Created by Lqq on 16/1/1.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CAEmitterLayerType.h"

@interface CAEmitterLayerType ()

@property (nonatomic , weak)CAEmitterLayer *emitterLayer;

@end

@implementation CAEmitterLayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCAEmitterLayer];
}

- (void)addCAEmitterLayer{
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    
    emitterLayer.bounds = CGRectMake(0, 0, 300, 300);
    emitterLayer.position = CGPointMake(300, 400);
    
    // 产出率 * cell的birthRate = cell的产出个数/秒
    emitterLayer.birthRate = 10;
    // lifetime * cell.lifetime = cell的生命周期 即:每个cell可以有不同的生命周期
    emitterLayer.lifetime = 1;
    
    //发射中心的位置
//    emitterLayer.emitterPosition = CGPointMake(100, 140);
//    emitterLayer.emitterZPosition = 0.5;
    
    //发射中心的大小
    emitterLayer.emitterSize = CGSizeMake(1, 1);
    emitterLayer.emitterDepth = 100;
    
    /*
     `emitterShape' values. //发射中心的样式
     CA_EXTERN NSString * const kCAEmitterLayerPoint
     CA_EXTERN NSString * const kCAEmitterLayerLine
     CA_EXTERN NSString * const kCAEmitterLayerRectangle
     CA_EXTERN NSString * const kCAEmitterLayerCuboid
     CA_EXTERN NSString * const kCAEmitterLayerCircle
     CA_EXTERN NSString * const kCAEmitterLayerSphere
     
     `emitterMode' values. //发射形式
     CA_EXTERN NSString * const kCAEmitterLayerPoints
     CA_EXTERN NSString * const kCAEmitterLayerOutline
     CA_EXTERN NSString * const kCAEmitterLayerSurface
     CA_EXTERN NSString * const kCAEmitterLayerVolume
     
     `renderMode' values. //渲染形式
     CA_EXTERN NSString * const kCAEmitterLayerUnordered        无序的
     CA_EXTERN NSString * const kCAEmitterLayerOldestFirst      最后生成的在最上面
     CA_EXTERN NSString * const kCAEmitterLayerOldestLast       最后生成的在最后面
     CA_EXTERN NSString * const kCAEmitterLayerBackToFront
     CA_EXTERN NSString * const kCAEmitterLayerAdditive
     */
    
    emitterLayer.emitterShape = kCAEmitterLayerLine;
    emitterLayer.emitterMode = kCAEmitterLayerVolume;
    emitterLayer.renderMode = kCAEmitterLayerUnordered;
    emitterLayer.preservesDepth = YES;
    //速度 velocity * cell.velocity
    emitterLayer.velocity = 20;
    //缩放 scale * cell.scale
    emitterLayer.scale = 0.5;
    
    //旋转
//    emitterLayer.spin = M_PI;
    
    emitterLayer.seed = 20;
    
    
    CAEmitterCell *orangeCell = [CAEmitterCell emitterCell];
//    orangeCell.color = [UIColor whiteColor].CGColor;
    orangeCell.scale = 1;
    orangeCell.lifetime = 2;
    orangeCell.birthRate = 50;
    orangeCell.velocity = 1;
    orangeCell.velocityRange = 10;
    orangeCell.emissionRange = M_PI * 0.2;
    orangeCell.emissionLatitude = M_PI_4;
    orangeCell.emissionLongitude = M_PI_4;
    orangeCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"orange"].CGImage);

    CAEmitterCell *blackCell = [CAEmitterCell emitterCell];
//    blackCell.color = [UIColor whiteColor].CGColor;
//    blackCell.scale = 1;
    blackCell.lifetime = 2;
    blackCell.birthRate = 100;
    blackCell.velocity = 1;
    blackCell.velocityRange = 10;
    blackCell.emissionRange = M_PI * 0.2;
    blackCell.emissionLatitude = M_PI_4;
    blackCell.emissionLongitude = M_PI_4;
    blackCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"black"].CGImage);
    
    
    CAEmitterCell *cyanCell = [CAEmitterCell emitterCell];
//    cyanCell.color = [UIColor clearColor].CGColor;
    blackCell.scale = 0.5;
    cyanCell.lifetime = 1;
    cyanCell.birthRate = 1;
    cyanCell.velocity = 10;
    cyanCell.velocityRange = 50;
    cyanCell.emissionRange = M_PI * 0.1;
    cyanCell.emissionLatitude = M_PI_4;
    cyanCell.emissionLongitude = M_PI_4;
    cyanCell.contents = (__bridge id _Nullable)([UIImage imageNamed:@"cyan"].CGImage);
    
    
//    orangeCell.emitterCells = @[cyanCell];

    
    emitterLayer.emitterCells = @[blackCell,orangeCell];
    
    [self.view.layer addSublayer:emitterLayer];
    _emitterLayer = emitterLayer;
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"scale"];
    basicAnimation.duration = 2;
    basicAnimation.repeatCount = MAXFLOAT;
    basicAnimation.autoreverses = YES;
    basicAnimation.toValue = @(3);
    
    [_emitterLayer addAnimation:basicAnimation forKey:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    [_emitterLayer removeFromSuperlayer];
}

/*
 * The array of emitter cells attached to the layer. Each object must have the CAEmitterCell class. *

@property(nullable, copy) NSArray<CAEmitterCell *> *emitterCells;

* The birth rate of each cell is multiplied by this number to give the actual number of particles created every second. Default value is one. Animatable. *
每一个cell的出生率乘以这个数字，以给每一秒的粒子的实际数量.默认值是1.可以做成动画.
@property float birthRate;

* The cell lifetime range is multiplied by this value when particles are created. Defaults to one. Animatable. *
cell生命周期范围是在创建粒子时乘以这个值.默认为1.可以做成动画.
@property float lifetime;

* The center of the emission shape. Defaults to (0, 0, 0). Animatable. *
发射中心的形状.默认为(0,0,0),可以做成动画.
@property CGPoint emitterPosition;
@property CGFloat emitterZPosition;

* The size of the emission shape. Defaults to (0, 0, 0). Animatable. Depending on the `emitterShape' property some of the values may be ignored. *
 发射的大小形状.默认为(0,0,0)Animatable.根据“emitterShape”属性的值会被忽略.
@property CGSize emitterSize;
@property CGFloat emitterDepth;

* A string defining the type of emission shape used. Current options are: `point' (the default), `line', `rectangle', `circle', `cuboid' and `sphere'. *
字符串定义的发射形状类型.目前的选择是:“点point”(默认),“线line”、“矩形rectangle”,“圈circle”,“长方体cuboid”和“球sphere”.
@property(copy) NSString *emitterShape;

* A string defining how particles are created relative to the emission shape. Current options are `points', `outline', `surface' and `volume' (the default). *
字符串定义的发射粒子的形状.“分points”,“大纲outline”,“表面surface”和“量volume”(默认).
@property(copy) NSString *emitterMode;

* A string defining how particles are composited into the layer's image. Current options are `unordered' (the default), `oldestFirst', `oldestLast', `backToFront' (i.e. sorted into Z order) and `additive'. The first four use source-over compositing, the last uses additive compositing. *
 
 定义一个字符串粒子如何组合成层的图像.目前的选择是`无序unordered”（默认），` oldestfirst '，` oldestlast '，` backtofront”（即分为Z顺序）和`additive'.前四个使用源合成，最后使用additive的合成.
@property(copy) NSString *renderMode;

* When true the particles are rendered as if they directly inhabit the three dimensional coordinate space of the layer's superlayer, rathe than being flattened into the layer's plane first. Defaults to NO.If true, the effect of the `filters', `backgroundFilters' and shadow- related properties of the layer is undefined. *
当这个属性为true时,粒子被渲染，就好像他们直接出现在的三维坐标空间的layer's superlayer ，而不是平铺在layer的第一面.默认NO,如果为true,那么`filters`,'backgroundfilters'和阴影层的相关属性是未定义的.
@property BOOL preservesDepth;

* Multiplies the cell-defined particle velocity. Defaults to one. Animatable. *
定义的粒子速度的细胞/乘以cell-defined粒子速度.默认为一.
@property float velocity;

 Multiplies the cell-defined particle scale. Defaults to one. Animatable.
//缩放比例
@property float scale;

 Multiplies the cell-defined particle spin. Defaults to one. Animatable.
//旋转
@property float spin;

 The seed used to initialize the random number generator. Defaults to zero. Each layer has its own RNG state. For properties with a mean M and a range R, random values of the properties are uniformly distributed in the interval [M - R/2, M + R/2].
用来初始化随机数生成器的起源(从seed开始).默认为0.每一层都有其自己的RNG(随机数生成器)的状态.对于具有M和R范围内的性质，随机值的属性是均匀分布的间隔[M - R/2, M + R/2].
@property unsigned int seed;

 `emitterShape' values.
 
CA_EXTERN NSString * const kCAEmitterLayerPoint
 
CA_EXTERN NSString * const kCAEmitterLayerLine
 
CA_EXTERN NSString * const kCAEmitterLayerRectangle
 
CA_EXTERN NSString * const kCAEmitterLayerCuboid
 
CA_EXTERN NSString * const kCAEmitterLayerCircle
 
CA_EXTERN NSString * const kCAEmitterLayerSphere
 

 `emitterMode' values.

CA_EXTERN NSString * const kCAEmitterLayerPoints
 
CA_EXTERN NSString * const kCAEmitterLayerOutline
 
CA_EXTERN NSString * const kCAEmitterLayerSurface
 
CA_EXTERN NSString * const kCAEmitterLayerVolume
 

 `renderMode' values.
 
CA_EXTERN NSString * const kCAEmitterLayerUnordered
 
CA_EXTERN NSString * const kCAEmitterLayerOldestFirst
 
CA_EXTERN NSString * const kCAEmitterLayerOldestLast
 
CA_EXTERN NSString * const kCAEmitterLayerBackToFront
 
CA_EXTERN NSString * const kCAEmitterLayerAdditive
 
 */

/*
 + (instancetype)emitterCell;
 
  Emitter cells implement the same property model as defined by CALayer. See CALayer.h for more details.
 Emitter cells 实现相同的属性模型定义在CALayer中.更多细节见CALayer.h.
+ (nullable id)defaultValueForKey:(NSString *)key;
- (BOOL)shouldArchiveValueForKey:(NSString *)key;

 The name of the cell. Used to construct key paths. Defaults to nil.
cell的名字 用于构造关键路径
@property(nullable, copy) NSString *name;

 Controls whether or not cells from this emitter are rendered.
控制来自这个发射器的cell是否被渲染
@property(getter=isEnabled) BOOL enabled;

 The number of emitted objects created every second. Default value is zero. Animatable.
每秒发射的对象的数目.默认值为零.
@property float birthRate;

 The lifetime of each emitted object in seconds, specified as a mean value and a range about the mean. Both values default to zero. Animatable.
每个被发射对象的寿命为lifetime秒,指定作为一个平均值和一个范围内的平均值
@property float lifetime;
@property float lifetimeRange;

 The orientation of the emission angle in radians, relative to the natural orientation angle of the emission shape. Note that latitude here is what is typically called colatitude, the zenith or phi, the angle from the z-axis. Similarly longitude is the angle in the xy-plane from the x-axis, often referred to as the azimuth or theta. Both values default to zero, which translates to no change relative to the emission shape's direction. Both values are animatable.
有发射角度(弧度制)确定方向弧度制,相对于发射方位角的自然形状.注意，这里的纬度是什么,是通常被称为余纬，极点或phi，从Z轴的角度.同样的经度是从x轴的XY平面的角度，通常被称为方位或θ.这两个值的默认值为零，这意味着对于发射形状的方向没有变化.两个值可以做动画
@property CGFloat emissionLatitude;
@property CGFloat emissionLongitude;

 An angle (in radians) defining a cone around the emission angle. Emitted objects are uniformly distributed across this cone. Defaults to zero.  Animatable.
是一个角度（弧度）,发射角度来定义一个圆锥.发射的对象均匀分布在这个圆锥.默认为零.
@property CGFloat emissionRange;

 The initial mean velocity of each emitted object, and its range. Both values default to zero. Animatable.
每个发射的对象的初始平均速度，和它的范围.
@property CGFloat velocity;
@property CGFloat velocityRange;

 The acceleration vector applied to emitted objects. Defaults to (0, 0, 0). Animatable.
确定发射对象的加速度矢量
@property CGFloat xAcceleration;
@property CGFloat yAcceleration;
@property CGFloat zAcceleration;

 The scale factor applied to each emitted object, defined as mean and range about the mean. Scale defaults to one, range to zero. Animatable.
缩放比例 适用于每个发射对象,定义为平均值和平均范围,scale default 0 ,
@property CGFloat scale;
@property CGFloat scaleRange;
@property CGFloat scaleSpeed;

 The rotation speed applied to each emitted object, defined as mean and range about the mean. Defaults to zero. Animatable. *
旋转速度 适用于每个发射对象,定义为平均值和平均范围
@property CGFloat spin;
@property CGFloat spinRange;

* The mean color of each emitted object, and the range from that mean color. `color' defaults to opaque white, `colorRange' to (0, 0, 0, 0). Animatable. *
每一个发射物体的平均颜色，以及这个颜色的范围.颜色默认为不透明白色`colorRange'（0，0，0，0）
@property(nullable) CGColorRef color;

@property float redRange;
@property float greenRange;
@property float blueRange;
@property float alphaRange;

* The speed at which color components of emitted objects change over their lifetime, defined as the rate of change per second. Defaults to (0, 0, 0, 0). Animatable. *
所发射的对象在其生命周期内颜色变化的速度，定义为每秒变化的速率
@property float redSpeed;
@property float greenSpeed;
@property float blueSpeed;
@property float alphaSpeed;

* The cell contents, typically a CGImageRef. Defaults to nil. Animatable. *
cell的内容 通常是CGImageRef类型的
@property(nullable, strong) id contents;

* The sub-rectangle of the contents image that will be drawn. See CALayer.h for more details. Defaults to the unit rectangle [0 0 1 1]. Animatable. *
将绘制内容图像的子矩形.See CALayer.h for more details.Defaults to the unit rectangle [0 0 1 1](单元矩形).
@property CGRect contentsRect;

* Defines the scale factor applied to the contents of the cell. See CALayer.h for more details. *
内容缩放比例
@property CGFloat contentsScale;

* The filter parameters used when rendering the `contents' image. See CALayer.h for more details. *
滤波器的参数用于渲染内容图像
@property(copy) NSString *minificationFilter;
@property(copy) NSString *magnificationFilter;
@property float minificationFilterBias;

* An array containing the sub-cells of this cell, or nil (the default value). When non-nil each particle emitted by the cell will act as an emitter for each of the cell's sub-cells. The emission point is the current particle position and the emission angle is relative to the current direction of the particle. Animatable. *
这个cell包含的子cell的数组,default nil . !nil时每一个由发射器发射的cell将作为其子cells的发射器(每一个cell将作为发射器发射emitterCells),发射点是当前粒子的位置,方向为:发射角相对于粒子的当前方向
@property(nullable, copy) NSArray<CAEmitterCell *> *emitterCells;

 Inherited attributes similar to in layers.
类似于层的继承属性
@property(nullable, copy) NSDictionary *style;
 */

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com