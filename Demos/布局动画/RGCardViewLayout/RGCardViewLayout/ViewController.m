//
//  ViewController.m
//  RGCardViewLayout
//
//  Created by ROBERA GELETA on 1/23/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//
#define TAG 99

#import "ViewController.h"
#import "RGCollectionViewCell.h"
@interface ViewController ()<UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return  4;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RGCollectionViewCell *cell = (RGCollectionViewCell  *)[collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    [self configureCell:cell withIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(RGCollectionViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    UIView  *subview = [cell.contentView viewWithTag:TAG];
    [subview removeFromSuperview];

    switch (indexPath.section) {
        case 0:
            cell.imageView.image =  [UIImage imageNamed:@"i1"];
            cell.mainLabel.text = @"Glaciers";
            break;
        case 1:
            cell.imageView.image =  [UIImage imageNamed:@"i2"];
            cell.mainLabel.text = @"Parrots";
            break;
        case 2:
            cell.imageView.image =  [UIImage imageNamed:@"i3"];
            cell.mainLabel.text = @"Whales";
            break;
        case 3:
            cell.imageView.image =  [UIImage imageNamed:@"i4"];
            cell.mainLabel.text = @"Lake View";
            break;
        case 4:
            cell.imageView.image =  [UIImage imageNamed:@"i5"];
            break;
        default:
            break;
    }
    
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com