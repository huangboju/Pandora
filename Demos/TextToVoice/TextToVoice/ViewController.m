//
//  ViewController.m
//  TextToVoice
//
//  Created by JoKy_Li on 16/1/18.
//  Copyright © 2016年 IVT. All rights reserved.
//

#import "ViewController.h"
#import "SoundePlayer.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *dayWeather = @"投资成功";
    SoundePlayer *player = [SoundePlayer soundPlayerInstance];
    [player play:dayWeather];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
