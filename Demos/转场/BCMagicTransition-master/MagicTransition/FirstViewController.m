//
//  FirstViewController.m
//  MagicTransition
//
//  Created by Boyce on 10/31/14.
//  Copyright (c) 2014 Boyce. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"First VC";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)push:(id)sender {
    SecondViewController *secondVC = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    
    // preload views to the memory
    [secondVC view];
    
    [self pushViewController:secondVC
                   fromViews:@[self.imageView1, self.imageView2, self.label1]
                     toViews:@[secondVC.imageView1, secondVC.imageView2, secondVC.label1]
                    duration:0.5];
}


@end
