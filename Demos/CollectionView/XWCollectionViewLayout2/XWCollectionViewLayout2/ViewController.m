//
//  ViewController.m
//  XWCollectionViewLayout2
//
//  Created by 温仲斌 on 15/12/31.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import "ViewController.h"

#import "XWCollectionViewLayout.h"

#import "XWCollectionViewCell.h"

#import "HelpAnmina.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UICollectionView *c = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:[[XWCollectionViewLayout alloc]init]];
    c.delegate = self;
    c.dataSource = self;
    [self.view addSubview:c];
    [c registerNib:[UINib nibWithNibName:@"XWCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section  {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.text = [NSString stringWithFormat:@"item : %@", @(indexPath.row)];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XWCollectionViewCell *cell = (XWCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSMutableArray *arr = [collectionView visibleCells].mutableCopy;
    [arr removeObject:cell];
    [[HelpAnmina shareHeleAnmina]animtionWithItem:cell withItemArray:arr andCollectionView:collectionView];
}

- (UIColor *)getArcColor {
    return [UIColor colorWithRed:arc4random() % 255 / 256. green:arc4random() % 255 / 256. blue:arc4random() % 255 / 256. alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
