//
//  ViewController.m
//  CustomNavigationBarDemo
//
//  Created by yunzhi on 17/2/22.
//  Copyright © 2017年 GrongRong. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title=@"测试";
    
    self.view.backgroundColor=[UIColor whiteColor];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    TestViewController *testController=[[TestViewController alloc]init];
    
    [self.navigationController pushViewController:testController animated:YES];
    
}


@end
