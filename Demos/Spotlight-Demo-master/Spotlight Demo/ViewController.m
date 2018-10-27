//
//  ViewController.m
//  Spotlight Demo
//
//  Created by Bindx on 7/12/16.
//  Copyright © 2016 Bindx. All rights reserved.
//

#import "ViewController.h"

#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "DemoOneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)creatSearchableItem{
    
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:(NSString *)kUTTypeImage];
    
    // 标题
    attributeSet.title = @"标题";
    // 关键字,NSArray可设置多个
    attributeSet.keywords = @[@"demo",@"sp"];
    // 描述
    attributeSet.contentDescription = @"description";
    // 图标, NSData格式
    attributeSet.thumbnailData = UIImagePNGRepresentation([UIImage imageNamed:@"icon"]);
    // Searchable item
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"1" domainIdentifier:@"linkedme.cc" attributeSet:attributeSet];
    
    NSMutableArray *searchItems = [NSMutableArray arrayWithObjects:item, nil];
    //indexSearchableItems 接收参数NSMutableArray
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:searchItems completionHandler:^(NSError * error) {
        if (error) {
            NSLog(@"索引创建失败:%@",error.localizedDescription);
        }else{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"索引创建成功" waitUntilDone:NO];
        }
    }];
}

//通过identifier删除索引
- (IBAction)deleteSearchableItemFormIdentifier{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[@"1"] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }else{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"通过identifier删除索引成功" waitUntilDone:NO];
        }
    }];
}

//通过DomainIdentifiers删除索引
- (IBAction)deleteSearchableItemFormDomain{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:@[@"linkedme.cc"] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }else{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"通过DomainIdentifiers删除索引成功" waitUntilDone:NO];
        }
    }];
}

//删除所有索引
- (IBAction)deleteAllSearchableItem{
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }else{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"删除所有索引成功" waitUntilDone:NO];
        }
    }];
}


- (void)showAlert:(NSString *)title{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:(UIAlertControllerStyleAlert)];
    
    // 创建按钮
    UIAlertAction *ok= [UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)pushViewDemoController:(UIButton *)sender{
        DemoOneViewController * ovc = [[DemoOneViewController alloc]init];
        [self.navigationController pushViewController:ovc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
