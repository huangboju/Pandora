//
//  ViewController.m
//  DataStorageExample
//
//  Created by lmj  on 16/5/26.
//  Copyright (c) 2016年 linmingjun. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewController.h"



#define kScreenWidth self.view.frame.size.width
#define kScreenHeight self.view.frame.size.height

#define idenfierName @"exampleIdentifier"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) NSMutableArray *classNames;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UICollectionView Example";
    
    self.titleArray = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    // MyCollectionViewController
    [self addTableCell:@"MyCollectionViewController" class:@"MyCollectionViewController"];
    
    [self setupTableView];
    
}

- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    _tableView.scrollIndicatorInsets = _tableView.contentInset;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)addTableCell:(NSString *)title class:(NSString *)className {
    
    [self.titleArray addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - TableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfierName];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfierName];
    }
    
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *className = self.classNames[indexPath.row];
    
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = [[class alloc] init];
        ctrl.title = _titleArray[indexPath.row];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


@end
