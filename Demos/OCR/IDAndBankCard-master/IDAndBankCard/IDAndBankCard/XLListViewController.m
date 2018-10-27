//
//  XLListViewController.m
//  IDAndBankCard
//
//  Created by mxl on 2017/3/28.
//  Copyright © 2017年 mxl. All rights reserved.
//


#import "XLListViewController.h"
#import "XLTableDelegateObj.h"
#import "XLBankScanViewController.h"
#import "XLIDScanViewController.h"

@interface XLListViewController ()

@property (nonatomic, strong) UITableView *myTableView;

@property (nonatomic, strong) XLTableDelegateObj *delegateObj;

@end

@implementation XLListViewController

- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _myTableView.dataSource = self.delegateObj;
        _myTableView.delegate = self.delegateObj;
    }
    return _myTableView;
}

- (XLTableDelegateObj *)delegateObj {
    if (_delegateObj == nil) {
        _delegateObj = [XLTableDelegateObj new];
    }
    return _delegateObj;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"OCR";

    [self.view addSubview:self.myTableView];
    
    [self.delegateObj.selectSubject subscribeNext:^(id x) {
        NSIndexPath *indexPath = (NSIndexPath *)x;
        switch (indexPath.row) {
            case 0:
                [self.navigationController pushViewController:[XLBankScanViewController new] animated:YES];
                break;
            case 1:
                [self.navigationController pushViewController:[XLIDScanViewController new] animated:YES];
                break;
            default:
                break;
        }
    }];
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
