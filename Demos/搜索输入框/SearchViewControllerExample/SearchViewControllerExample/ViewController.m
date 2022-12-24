//
//  ViewController.m
//  SearchViewControllerExample
//
//  Created by 樊小聪 on 2017/6/7.
//  Copyright © 2017年 樊小聪. All rights reserved.
//

#import "ViewController.h"

#import "TextSearchViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

/**
 *  点击了搜索按钮
 */
- (IBAction)didClickSearchButtonAction:(UIButton *)sender
{
    TextSearchViewController *vc = [[TextSearchViewController alloc] init];
    
    vc.searchMode = sender.tag - 100;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end

