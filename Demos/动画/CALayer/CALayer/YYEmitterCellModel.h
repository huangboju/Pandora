//
//  YYEmitterCellModel.h
//  CALayer
//
//  Created by hdf on 16/1/4.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYEmitterCellModel : NSObject

@property(nonatomic, copy) NSString *name;

@property(nonatomic , assign ,getter=isEnabled) BOOL enabled;

@property (nonatomic , assign)float birthRate;

@property (nonatomic , assign)float lifetime;
@property (nonatomic , assign)float lifetimeRange;

@property (nonatomic , assign)CGFloat emissionLatitude;
@property (nonatomic , assign)CGFloat emissionLongitude;

@property (nonatomic , assign)CGFloat emissionRange;

@property (nonatomic , assign)CGFloat velocity;
@property (nonatomic , assign)CGFloat velocityRange;

@property (nonatomic , assign)CGFloat xAcceleration;
@property (nonatomic , assign)CGFloat yAcceleration;
@property (nonatomic , assign)CGFloat zAcceleration;

@property (nonatomic , assign)CGFloat scale;
@property (nonatomic , assign)CGFloat scaleRange;
@property (nonatomic , assign)CGFloat scaleSpeed;

@property (nonatomic , assign)CGFloat spin;
@property (nonatomic , assign)CGFloat spinRange;

@property (nullable , nonatomic , assign) CGColorRef color;

@property (nonatomic , assign)float redRange;
@property (nonatomic , assign)float greenRange;
@property (nonatomic , assign)float blueRange;
@property (nonatomic , assign)float alphaRange;

@property (nonatomic , assign)float redSpeed;
@property (nonatomic , assign)float greenSpeed;
@property (nonatomic , assign)float blueSpeed;
@property (nonatomic , assign)float alphaSpeed;

@property (nullable, strong) id contents;

@property (nonatomic , assign)CGRect contentsRect;

@property (nonatomic , assign)CGFloat contentsScale;

@property(nonatomic ,copy) NSString *minificationFilter;
@property(nonatomic ,copy) NSString *magnificationFilter;
@property (nonatomic , assign)float minificationFilterBias;

@property(nonatomic ,nullable, copy) NSArray<CAEmitterCell *> *emitterCells;

@property(nonatomic ,nullable, copy) NSDictionary *style;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com