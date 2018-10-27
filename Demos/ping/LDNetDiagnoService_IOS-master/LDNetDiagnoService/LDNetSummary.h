//
//  LDNetSummary.h
//  LDNetDiagnoService
//
//  Created by 黄伯驹 on 2017/9/10.
//  Copyright © 2017年 庞辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDNetSummary : NSObject

@property (assign, nonatomic) NSTimeInterval   averageTime;
@property (copy, nonatomic) NSString           *ipAddress;

@end
