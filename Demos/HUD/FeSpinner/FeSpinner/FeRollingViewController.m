//
//  FeRollingViewController.m
//  FeSpinner
//
//  Created by Nghia Tran on 8/18/14.
//  Copyright (c) 2014 fe. All rights reserved.
//

#import "FeRollingViewController.h"
#import "FeRollingLoader.h"

@interface FeRollingViewController ()
@property (strong, nonatomic) FeRollingLoader *rollingLoader;

@end

@implementation FeRollingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _rollingLoader = [[FeRollingLoader alloc] initWithView:self.view title:@"LOADING"];
    [self.view addSubview:_rollingLoader];
    
    [_rollingLoader showWhileExecutingBlock:^{
        [self myTask];
    } completion:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (void)myTask
{
    // Do something usefull in here instead of sleeping ...
    sleep(2);
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
