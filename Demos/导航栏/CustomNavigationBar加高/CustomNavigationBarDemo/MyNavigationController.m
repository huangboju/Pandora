//
//  MyNavigationController.m
//  CustomNavigationBarDemo
//
//  Created by yunzhi on 17/2/22.
//  Copyright © 2017年 GrongRong. All rights reserved.
//

#import "MyNavigationController.h"
#import "CustomNavigationBar.h"


@interface MyNavigationController ()

@end

@implementation MyNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setValue:[[CustomNavigationBar alloc]init] forKey:@"navigationBar"];
    
    
}

- (void)back{
    
    [self popViewControllerAnimated:YES];
    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count >= 1) {
        viewController.hidesBottomBarWhenPushed = YES;

        UIButton *backBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

        UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        // 将控制器中的返回按钮进行统一设置
        viewController.navigationItem.leftBarButtonItem =item;
    }
    [super pushViewController:viewController animated:YES];
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
