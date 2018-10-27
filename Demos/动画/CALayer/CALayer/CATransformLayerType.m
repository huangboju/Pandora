//
//  CATransformLayerType.m
//  CALayer
//
//  Created by hdf on 16/1/4.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CATransformLayerType.h"

@interface CATransformLayerType ()

@end

@implementation CATransformLayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTransformLayer];
}

- (void)addTransformLayer {//并不能用
    /* "Transform" layers are used to create true 3D layer hierarchies.
     “转换”层是用来创建真正的三维层的层次结构.
     *
     * Unlike normal layers, transform layers do not project (i.e. flatten)
     * their sublayers into the plane at Z=0. However due to this neither
     * do they support many features of the 2D compositing model:
     *
     * - only their sublayers are rendered (i.e. no background, contents,
     *   border)
     *
     * - filters, backgroundFilters, compositingFilter, mask, masksToBounds
     *   and shadow related properties are ignored (they all assume 2D
     *   image processing of the projected layer)
     *
     * - opacity is applied to each sublayer individually, i.e. the transform
     *   layer does not form a compositing group.
     *
     * Also, the -hitTest: method should never be called on transform
     * layers (they do not have a 2D coordinate space into which to map the
     * supplied point.) CALayer will pass over transform layers directly to
     * their sublayers, applying the effects of the transform layer's
     * geometry when hit-testing each sublayer. */
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com