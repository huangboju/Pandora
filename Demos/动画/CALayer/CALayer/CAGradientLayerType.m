//
//  CAGradientLayerType.m
//  CALayer
//
//  Created by Lqq on 16/1/1.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CAGradientLayerType.h"

@interface CAGradientLayerType ()

@property (nonatomic , strong)UILabel *label;

@end

@implementation CAGradientLayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addLabel];
    
    [self addGradientLayer];
    
}

- (void)addLabel{
    
    /*
     1. 新建label, 把label添加到view上(这个label图层作用也只是设置mask, 不用来显示)
     2. 创建 CAGradientLayer, 设置其渐变色, 将其添加到 label 的superView的layer上, 并覆盖在label上
     3. 设置 gradientLayer的mask为 label的layer 重新设置label的frame
     */
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(100, 200, 240, 50)];
//    label.textColor = [UIColor clearColor];
//    label.backgroundColor = [UIColor lightGrayColor];
    label.font = [UIFont boldSystemFontOfSize:20];
    label.text = @"渐变色?哼,渐变色!";
    label.textAlignment = NSTextAlignmentCenter;
    
//    [self.view addSubview:label];
    _label = label;
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
    gradientLayer.position = CGPointMake(200, 340);
    
    gradientLayer.mask = _label.layer;
    
    [self.view.layer addSublayer:gradientLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.duration = 2;
    
    animation.repeatCount = MAXFLOAT;
    
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
     
     startPoint和endPoint 决定渐变gradient 绘制时的坐标空间.startPoint对应于第一层次,endPoint对应最后层次.这两个点是定义在一个单元坐标空间,然后映射到层的边界矩形.(即[0,0]是手机的左下角,[1,1]是右上角).(默认值[0.5,0]和[0.5,1].都可以做成动画.
     The start and end points of the gradient when drawn into the layer's
     * coordinate space. The start point corresponds to the first gradient
     * stop, the end point to the last gradient stop. Both points are
     * defined in a unit coordinate space that is then mapped to the
     * layer's bounds rectangle when drawn. (I.e. [0,0] is the bottom-left
     * corner of the layer, [1,1] is the top-right corner.) The default values
     * are [.5,0] and [.5,1] respectively. Both are animatable.
     
     @property CGPoint startPoint;
     @property CGPoint endPoint;
     
     这种层次将它们分开.目前只允许的值是“轴”(默认值).
     The kind of gradient that will be drawn. Currently the only allowed
     * value is `axial' (the default value).
     
     @property(copy) NSString *type;
     
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com