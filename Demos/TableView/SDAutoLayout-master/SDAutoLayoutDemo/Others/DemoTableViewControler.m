//
//  DemoTableViewControler.m
//  SDAutoLayout 测试 Demo
//
//  Created by gsd on 15/10/12.
//  Copyright (c) 2015年 gsd. All rights reserved.
//

/*
 
 *********************************************************************************
 *                                                                                *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 2689718696(gsdios)                                                      *
 * Email : gsdios@126.com                                                          *
 * GitHub: https://github.com/gsdios                                               *
 * 新浪微博:GSD_iOS                                                                 *
 *                                                                                *
 *********************************************************************************
 
 */

#import "DemoTableViewControler.h"

#import "UITableView+SDAutoTableViewCellHeight.h"

#import "DemoCell.h"

NSString * const demo0Content = @"自动布局动画，修改一个view的布局约束，其他view也会自动重新排布";
NSString * const demo1Content = @"布局示例，其中view1用到了普通view的内容自适应功能，view1内部的label用到了文字自适应功能";
NSString * const demo2Content = @"展示自动布局环境下父view修改布局约束对子view自动的自动调整";
NSString * const demo3Content = @"简单tableview展示";
NSString * const demo4Content = @"类cell的自动布局展示";
NSString * const demo5Content = @"1.利用普通view的内容自适应功能添加tableheaderview\n2.利用自动布局功能实现cell内部图文排布，图片可根据原始尺寸按比例缩放后展示\n3.利用“普通版tableview的cell高度自适应”完成tableview的排布";
NSString * const demo6Content = @"展示scrollview的内容自适应和普通view的动态圆角处理";
NSString * const demo7Content = @"利用“普通版tableview的《多cell》高度自适应”2步设置完成tableview的排布";
NSString * const demo8Content = @"利用“升级版tableview的《多cell》高度自适应”1步完成tableview的排布";
NSString * const demo9Content = @"利用SDAutoLayout仿制微信朋友圈。高仿微信计划：\n1.高仿朋友圈 \n2.完善细节 \n3.高仿完整微信app \nPS：代码会持续在我的github更新";

@implementation DemoTableViewControler
{
    NSArray *_contenArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVC9") new] animated:YES];
    
    _contenArray = @[demo0Content, demo1Content, demo2Content, demo3Content, demo4Content, demo5Content, demo6Content, demo7Content, demo8Content, demo9Content];
}

#pragma mark - tableview datasourece and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"test";
    DemoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[DemoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.titleLabel.text = [NSString stringWithFormat:@"Demo -- %ld", (long)indexPath.row];
    cell.contentLabel.text = _contenArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *demoClassString = [NSString stringWithFormat:@"DemoVC%ld", indexPath.row];
    UIViewController *vc = [NSClassFromString(demoClassString) new];
    vc.title = demoClassString;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeightForIndexPath:indexPath cellContentViewWidth:[UIScreen mainScreen].bounds.size.width];
}

@end
