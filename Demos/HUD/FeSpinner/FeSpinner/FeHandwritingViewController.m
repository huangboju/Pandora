//
//  FeHandwritingViewController.m
//  FeSpinner
//
//  Created by Nghia Tran on 1/2/15.
//  Copyright (c) 2015 fe. All rights reserved.
//

#import "FeHandwritingViewController.h"
#import "FeHandwriting.h"
#import "UIColor+flat.h"

@interface FeHandwritingViewController ()
@property (strong, nonatomic) FeHandwriting *handwritingLoader;

@end

@implementation FeHandwritingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexCode:@"#ffe200"];
    
    _handwritingLoader = [[FeHandwriting alloc] initWithView:self.view];
    [self.view addSubview:_handwritingLoader];
    
    [_handwritingLoader showWhileExecutingBlock:^{
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
