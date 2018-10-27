//
//  FeZeroLoaderViewController.m
//  FeSpinner
//
//  Created by Nghia Tran on 8/17/14.
//  Copyright (c) 2014 fe. All rights reserved.
//

#import "FeZeroLoaderViewController.h"
#import "FeZeroLoader.h"

@interface FeZeroLoaderViewController ()

@property (strong, nonatomic) FeZeroLoader *zeroLoader;

@end

@implementation FeZeroLoaderViewController

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
    
    _zeroLoader = [[FeZeroLoader alloc] initWithView:self.view title:@"Loading"];
    [self.view addSubview:_zeroLoader];
    
    [_zeroLoader show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
