//
//  ViewController.m
//  YALRentalPullToRefresh
//
//  Created by Konstantin Safronov on 12/24/14.
//  Copyright (c) 2014 Konstantin Safronov. All rights reserved.
//

#import "YALExampleViewController.h"
#import "YALSunnyRefreshControl.h"

@interface YALExampleViewController ()

@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;

@end

@implementation YALExampleViewController

# pragma mark - UIView life cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setupRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.sunnyRefreshControl startRefreshing];
}

# pragma mark - YALSunyRefreshControl methods

-(void)setupRefreshControl{
    
    self.sunnyRefreshControl = [YALSunnyRefreshControl attachToScrollView:self.tableView
                                                                  target:self
                                                           refreshAction:@selector(sunnyControlDidStartAnimation)];
}

-(void)sunnyControlDidStartAnimation{
    
    // start loading something
}

-(IBAction)endAnimationHandle{
    
    [self.sunnyRefreshControl endRefreshing];
}



@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com