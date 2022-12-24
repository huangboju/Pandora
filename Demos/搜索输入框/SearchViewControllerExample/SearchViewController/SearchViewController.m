//
//  SearchViewController.m
//  搜索控制器Demo
//
//  Created by 樊小聪 on 2017/6/7.
//  Copyright © 2017年 樊小聪. All rights reserved.
//


/*
 *  备注：搜索控制器 🐾
 */



#import "SearchViewController.h"



#define LazyLoadMethod(variable)    \
- (NSMutableArray *)variable \
{   \
if (!_##variable)  \
{   \
_##variable = [NSMutableArray array];  \
}   \
return _##variable;    \
}


@interface SearchViewController ()<UISearchResultsUpdating, UITableViewDataSource, UISearchBarDelegate>

@property(nonatomic, strong) UISearchController *searchController;

@end


static NSString * const cellIdentifier = @"cellIdentifier";

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// 设置 UI
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - 💤 👀 LazyLoad Method 👀

LazyLoadMethod(dataArr)

- (UISearchController *)searchController
{
    if (!_searchController)
    {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:NULL];
        _searchController.searchBar.frame = CGRectMake(0, 0, 0, 44);
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.placeholder = self.placeholder ?: @"请输入搜索内容";
        _searchController.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
                
        /// 去除 searchBar 上下两条黑线
        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor =  [UIColor groupTableViewBackgroundColor].CGColor;
        barImageView.layer.borderWidth = 1;
        
        self.tableView.tableHeaderView = _searchController.searchBar;
        [_searchController.searchBar sizeToFit];
    }
    
    return _searchController;
}

#pragma mark - 👀 设置 UI 👀 💤

/**
 *  设置 UI
 */
- (void)setupUI
{
    /// 设置 tableView
    [self setupTableView];
    
    switch (self.searchMode)
    {
        case SearchModeRealTime:    /// 实时搜索
        {
            self.searchController.searchBar.returnKeyType = UIReturnKeyDone;
            self.searchController.searchResultsUpdater = self;
            break;
        }
        case SearchModeAction:      /// 点击搜索按钮进行搜索
        {
            self.searchController.searchBar.returnKeyType = UIReturnKeySearch;
            self.searchController.searchBar.delegate = self;
            break;
        }
    }
}

/**
 *  设置 tableView
 */
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView = tableView;
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [self.view addSubview:tableView];
}

#pragma mark - 📕 👀 UITableViewDataSource 👀

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.numberOfSectionsInTableViewCofigure)
    {
        return self.numberOfSectionsInTableViewCofigure(tableView, self.searchController.isActive);
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.numberOfRowsInSectionConfigure)
    {
        return self.numberOfRowsInSectionConfigure(tableView, section, self.searchController.isActive);
    }
    
    return (!self.searchController.active) ? self.dataArr.count : self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellForRowAtIndexPathConfigure)
    {
        return self.cellForRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
    }
    
    return [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
}

#pragma mark - 💉 👀 UITableViewDelegate 👀

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectRowAtIndexPathConfigure)
    {
        self.didSelectRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didDeselectRowAtIndexPathConfigure)
    {
        self.didDeselectRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.heightForRowAtIndexPathConfigure)
    {
        return self.heightForRowAtIndexPathConfigure(tableView, indexPath, self.searchController.isActive);
    }
    
    return 50;
}

#pragma mark - 💉 👀 UISearchResultsUpdating 👀

#pragma mark - 👀 这里主要处理实时搜索的配置 👀 💤

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    /// 如果不是实时搜索，则直接返回
    if (self.searchMode == SearchModeAction)    return;
    
    
    if (self.updateSearchResultsConfigure)
    {
        /// 获取搜索结果的数据
        _searchResults = self.updateSearchResultsConfigure(self.searchController.searchBar.text);
        
        /// 刷新 tableView
        [self.tableView reloadData];
    }
}

#pragma mark - 💉 👀 UISearchBarDelegate 👀

#pragma mark - 👀 这里主要处理非实时搜索的配置 👀 💤

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{    
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    if (self.updateSearchResultsConfigure)
    {
        /// 获取搜索结果的数据
        _searchResults = self.updateSearchResultsConfigure(self.searchController.searchBar.text);
        
        /// 刷新 tableView
        [self.tableView reloadData];
    }
}

/**
 *  结束编辑的时候，显示搜索之前的界面，并将 _searchResults 清空
 */
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    self.searchController.active = NO;
    _searchResults = nil;
    [self.tableView reloadData];
}

/**
 *  开始编辑的时候，显示搜索结果控制器
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    /// 如果是实时搜索，则直接返回
    if (self.searchMode == SearchModeRealTime)  return;
    
    self.searchController.active = YES;
    [self.tableView reloadData];
}

@end
