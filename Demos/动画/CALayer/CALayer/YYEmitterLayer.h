//
//  YYEmitterLayer.h
//  CALayer
//
//  Created by hdf on 16/1/4.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class YYEmitterLayer;

@protocol YYEmitterLayerDatasource <NSObject>
- (CAEmitterCell *)emitterLayer:(YYEmitterLayer *)layer cellAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfCells;
@end

@protocol YYEmitterLayerDelegate <NSObject>
@optional

@end


@interface YYEmitterLayer : CAEmitterLayer

@property (nonatomic, weak) id<YYEmitterLayerDatasource> dataSource;
- (void)reloadData;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com