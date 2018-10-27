//
//  ViewController.m
//  LDNetDiagnoServieDemo
//
//  Created by 庞辉 on 14-10-29.
//  Copyright (c) 2014年 庞辉. All rights reserved.
//

#import "ViewController.h"
#import "LDNetDiagnoService.h"

@interface ViewController () <LDNetDiagnoServiceDelegate, UITextFieldDelegate> {
    UIActivityIndicatorView *_indicatorView;
    UIButton *btn;
    UITextView *_txtView_log;
    UITextField *_txtfield_dormain;

    NSString *_logInfo;
    LDNetDiagnoService *_netDiagnoService;
    BOOL _isRunning;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"网络诊断Demo";

    _indicatorView = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.frame = CGRectMake(0, 0, 30, 30);
    _indicatorView.hidden = NO;
    _indicatorView.hidesWhenStopped = YES;
    [_indicatorView stopAnimating];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_indicatorView];
    self.navigationItem.rightBarButtonItem = rightItem;


    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10.0f, 79.0f, 100.0f, 50.0f);
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [btn.titleLabel setNumberOfLines:2];
    [btn setTitle:@"开始诊断" forState:UIControlStateNormal];
    [btn addTarget:self
                  action:@selector(startNetDiagnosis)
        forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];


    _txtfield_dormain =
        [[UITextField alloc] initWithFrame:CGRectMake(130.0f, 79.0f, 180.0f, 50.0f)];
    _txtfield_dormain.delegate = self;
    _txtfield_dormain.returnKeyType = UIReturnKeyDone;
//    https://testclass.dadaabc.com/api/net/getNetTestList 
    _txtfield_dormain.text = @"www.baidu.com";
    [self.view addSubview:_txtfield_dormain];


    _txtView_log = [[UITextView alloc] initWithFrame:CGRectZero];
    _txtView_log.layer.borderWidth = 1.0f;
    _txtView_log.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _txtView_log.backgroundColor = [UIColor whiteColor];
    _txtView_log.font = [UIFont systemFontOfSize:10.0f];
    _txtView_log.textAlignment = NSTextAlignmentLeft;
    _txtView_log.scrollEnabled = YES;
    _txtView_log.editable = NO;
    _txtView_log.frame =
        CGRectMake(0.0f, 140.0f, self.view.frame.size.width, self.view.frame.size.height - 120.0f);
    [self.view addSubview:_txtView_log];

    // Do any additional setup after loading the view, typically from a nib.
//    _netDiagnoService = [[LDNetDiagnoService alloc] initWithAppCode:@"test"
//                                                            appName:@"网络诊断应用"
//                                                         appVersion:@"1.0.0"
//                                                             userID:@"huipang@corp.netease.com"
//                                                           deviceID:nil
//                                                            dormain:_txtfield_dormain.text
//                                                        carrierName:nil
//                                                     ISOCountryCode:nil
//                                                  MobileCountryCode:nil
//                                                      MobileNetCode:nil];

    NSArray *ipAddress = @[
                           @"139.196.17.187",
                           @"115.29.38.186",
                           @"121.43.173.34",
                           @"115.29.38.186",
                           @"120.76.75.233",
                           @"47.92.80.116",
                           @"175.6.7.128",
                           @"121.196.220.124",
                           @"211.147.74.226",
                           @"106.15.42.79"
                           ];

    _netDiagnoService = [[LDNetDiagnoService alloc] initWithAppCode:@"test" userID:@"huipang@corp.netease.com" ipAddress:ipAddress maximumPingTimes:5];

    _netDiagnoService.delegate = self;
    _isRunning = NO;
}

- (void)startNetDiagnosis
{
    [_txtfield_dormain resignFirstResponder];
    _netDiagnoService.dormain = _txtfield_dormain.text;
    if (!_isRunning) {
        [_indicatorView startAnimating];
        [btn setTitle:@"停止诊断" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
        [btn setUserInteractionEnabled:FALSE];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
        _txtView_log.text = @"";
        _logInfo = @"";
        _isRunning = !_isRunning;
        [_netDiagnoService startNetDiagnosis];
    } else {
        [_indicatorView stopAnimating];
        _isRunning = !_isRunning;
        [btn setTitle:@"开始诊断" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:1.0]];
        [btn setUserInteractionEnabled:FALSE];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0f];
        [_netDiagnoService stopNetDialogsis];
    }
}

- (void)delayMethod
{
    [btn setBackgroundColor:[UIColor lightGrayColor]];
    [btn setUserInteractionEnabled:TRUE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark NetDiagnosisDelegate
- (void)netDiagnosisDidStarted {
    NSLog(@"开始诊断～～～");
}

- (void)netDiagnosisStepInfo:(NSString *)stepInfo {
    NSLog(@"%@", stepInfo);
    _logInfo = [_logInfo stringByAppendingString:stepInfo];
    dispatch_async(dispatch_get_main_queue(), ^{
        _txtView_log.text = _logInfo;
    });
}


- (void)netDiagnosisDidEnd:(NSString *)allLogInfo fastIPSummary:(LDNetSummary *)summary {
    NSLog(@"logInfo>>>>>\n%@", allLogInfo);
    NSLog(@"🍀fastIPAdress=%@🍀  %@", summary.ipAddress, [NSThread currentThread]);
    //可以保存到文件，也可以通过邮件发送回来
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicatorView stopAnimating];
        [btn setTitle:@"开始诊断" forState:UIControlStateNormal];
        _isRunning = NO;
    });
}

- (void)emailLogInfo {
    [_netDiagnoService printLogInfo];
}


#pragma mark -
#pragma mark - textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
