//
//  XLTableDelegateObj.h
//  IDAndBankCard
//
//  Created by mxl on 2017/3/28.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XLTableDelegateObj : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RACSubject *selectSubject;

@end
