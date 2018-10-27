//
//  LZViewController.m
//  LZSearchController
//
//  Created by Artron_LQQ on 2016/12/19.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "LZViewController.h"

@interface LZViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation LZViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}

- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _datas;
}

- (NSMutableArray *)results {
    if (_results == nil) {
        _results = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    for (int i = 0; i < 100; i++) {
        
        NSString *str = [NSString stringWithFormat:@"测试数据%d", i];
        
        [self.datas addObject:str];
    }
    
    // 创建UISearchController, 这里使用当前控制器来展示结果
    UISearchController *search = [[UISearchController alloc]initWithSearchResultsController:nil];
    // 设置结果更新代理
    search.searchResultsUpdater = self;
    // 因为在当前控制器展示结果, 所以不需要这个透明视图
    search.dimsBackgroundDuringPresentation = NO;
    // 是否自动隐藏导航
//    search.hidesNavigationBarDuringPresentation = NO;
    self.searchController = search;
    // 将searchBar赋值给tableView的tableHeaderView
    self.tableView.tableHeaderView = search.searchBar;
    
    search.searchBar.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        
        return self.results.count ;
    }
    
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active ) {
        
        cell.textLabel.text = [self.results objectAtIndex:indexPath.row];
    } else {
        
        cell.textLabel.text = [self.datas objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.searchController.active) {
        NSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
    } else {
        
        NSLog(@"选择了列表中的%@", [self.datas objectAtIndex:indexPath.row]);
    }
    
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *inputStr = searchController.searchBar.text ;
    if (self.results.count > 0) {
        [self.results removeAllObjects];
    }
    for (NSString *str in self.datas) {
        
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            
            [self.results addObject:str];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
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
