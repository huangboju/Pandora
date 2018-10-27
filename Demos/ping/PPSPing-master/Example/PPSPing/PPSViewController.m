//
//  PPSViewController.m
//  PPSPing
//
//  Created by ppsheep.qian@gmail.com on 05/15/2017.
//  Copyright (c) 2017 ppsheep.qian@gmail.com. All rights reserved.
//

#import "PPSViewController.h"
#import <PPSPing/PPSPingServices.h>

@interface PPSViewController ()

@property (nonatomic, strong) PPSPingServices *service;
@property (weak, nonatomic) IBOutlet UITextView *pingResultTextView;
@property (nonatomic, strong) NSMutableString *resultString;

@end

@implementation PPSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.resultString = [[NSMutableString alloc] initWithString:@"ping结果:\n"];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:UIBarButtonItemStylePlain target:self action:@selector(startPing)];
    
    NSArray <NSString *>*domains = @[
                                     @"www.163.com",
                                     @"www.baidu.com",
                                     @"www.google.com",
                                     @"www.jianshu.com"
                                     ];

    for (NSString *address in domains) {
        
    }
}

- (void)startPing {
    self.service = [PPSPingServices serviceWithAddress:@"www.163.com" maximumPingTimes:4];
    [self.service startWithCallbackHandler:^(PPSPingSummary *pingItem, NSArray *pingItems) {
        [self.resultString appendFormat:@"%@\n",pingItem];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pingResultTextView.text = self.resultString;
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
