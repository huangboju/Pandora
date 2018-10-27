//
//  TestViewController.m
//  CustomNavigationBarDemo
//
//  Created by yunzhi on 17/2/22.
//  Copyright © 2017年 GrongRong. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"哈哈";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIButton *rightBar=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35, 35)];
    [rightBar setImage:[UIImage imageNamed:@"theme"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
