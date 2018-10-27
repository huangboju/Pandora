//
//  ProductListViewController.m
//  Products
//
//  Created by home on 2017/11/15.
//  Copyright © 2017年 home. All rights reserved.
//

#import "ProductListViewController.h"
#import "Masonry.h"
#import "LongCell.h"
#import "NormalCell.h"
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define KHeight  [UIScreen mainScreen].bounds.size.height

typedef NS_ENUM(NSInteger,CollectionMode){
    CollectionModeNormal,
    CollectionModeLong
};

@interface ProductListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong) UICollectionViewFlowLayout * flowLayout;
@property(nonatomic,strong) UICollectionView * allProductCollection;
@property(nonatomic,assign) CollectionMode  mode;
@end

@implementation ProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addButton];
    [self addCollectionView];
    _mode = CollectionModeNormal;
    // Do any additional setup after loading the view.
}
- (void)addButton{
  UIButton * btn = ({
    btn = [UIButton new];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn.titleLabel setTextAlignment:NSTextAlignmentRight];
    [btn setTitle:@"改变布局" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeLayout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(22);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(80);
    }];
    btn;
  });
}
- (void)changeLayout{
        if(_mode == CollectionModeNormal){
            _mode = CollectionModeLong;
        }
        else{
            _mode = CollectionModeNormal;
        }
       [self collectionViewMode:_mode];
}
- (void)addCollectionView{
    _flowLayout = [[UICollectionViewFlowLayout alloc]init];
    _allProductCollection = [[UICollectionView alloc]initWithFrame:CGRectMake( 10, 64, kWidth-20 , KHeight-64) collectionViewLayout:_flowLayout];
    _allProductCollection.delegate = self;
    _allProductCollection.dataSource = self;
    _allProductCollection.backgroundColor  = [UIColor  whiteColor];
    _allProductCollection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_allProductCollection];
    [self collectionViewMode:_mode];
}

-(void)collectionViewMode:(CollectionMode)mode{
    if(mode == CollectionModeNormal){
        _flowLayout.itemSize = CGSizeMake((kWidth-30)/2,(kWidth-30)/2+50);
        [_allProductCollection registerClass:[NormalCell class] forCellWithReuseIdentifier:@"NormalCell"];
    }
    else{
        _flowLayout.itemSize = CGSizeMake(kWidth,(kWidth-30)/2);
        [_allProductCollection registerClass:[LongCell class] forCellWithReuseIdentifier:@"LongCell"];
    }
    [_allProductCollection reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 40;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NormalCell * cell;
    
    if(_mode == CollectionModeNormal){
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"NormalCell" forIndexPath:indexPath];
    }
    else{
        cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"LongCell" forIndexPath:indexPath];
    }
    return cell;
    
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
