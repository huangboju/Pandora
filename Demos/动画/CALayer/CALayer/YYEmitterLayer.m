//
//  YYEmitterLayer.m
//  CALayer
//
//  Created by hdf on 16/1/4.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "YYEmitterLayer.h"

struct DataSourceFlags {
    BOOL cellAtIndex ;
    BOOL numberOfCells ;
} ;
typedef struct DataSourceFlags DataSourceFlags;

@interface YYEmitterLayer ()

@property (nonatomic)DataSourceFlags dataSourceFlags;

@end

@implementation YYEmitterLayer

- (void)reloadData{
    
    _dataSourceFlags.cellAtIndex = [_dataSource respondsToSelector:@selector(emitterLayer:cellAtIndex:)];
    _dataSourceFlags.numberOfCells = [_dataSource respondsToSelector:@selector(numberOfCells)];
    
    if (!(_dataSourceFlags.cellAtIndex && _dataSourceFlags.numberOfCells)) return;
    
    NSMutableArray *cells = [NSMutableArray array];
    for (NSInteger i = 0; i < [_dataSource numberOfCells]; i ++) {
        CAEmitterCell *cell = [_dataSource emitterLayer:self cellAtIndex:i];
        [cells addObject:cell];
    }
    
    self.emitterCells = cells;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com