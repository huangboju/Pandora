//
//  ViewController.m
//  AttributeStringDemo
//
//  Created by caiiiac on 15/8/10.
//  Copyright (c) 2015年 sun3d. All rights reserved.
//

#import "ViewController.h"
#import "TextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self loadAttributeString];
    [self loadTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) loadAttributeString
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 40, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.center = self.view.center;
    [self.view addSubview:label];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"caiiiac.github.io"];
    
    //字体 颜色 背景色
//    NSDictionary * attris = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSBackgroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:30]};

    
    //下划线
//    NSDictionary * attris = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName:[UIColor orangeColor],NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),                             NSUnderlineColorAttributeName:[UIColor blueColor],};
    
    //描边
//    NSDictionary * attris = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:30],NSForegroundColorAttributeName:[UIColor whiteColor],NSStrokeColorAttributeName:[UIColor blueColor],NSStrokeWidthAttributeName:@(2)};
    
    //阴影
//    NSShadow * shadow = [[NSShadow alloc] init];
//    shadow.shadowColor = [UIColor blueColor];
//    shadow.shadowBlurRadius = 4.0;
//    shadow.shadowOffset = CGSizeMake(2.0, 2.0);
//    NSDictionary * attris = @{NSFontAttributeName:[UIFont systemFontOfSize:30],NSShadowAttributeName:shadow};
    
    //字符间隔
//    NSDictionary * attris = @{NSKernAttributeName:@(5),
//                              NSFontAttributeName:[UIFont systemFontOfSize:30]};
    
    //字体倾斜
//    NSDictionary * attris = @{NSObliquenessAttributeName:@(0.8),
//                              NSFontAttributeName:[UIFont systemFontOfSize:30]};
    
    //字体扁平化
//    NSDictionary * attris = @{NSExpansionAttributeName:@(1.0),
//                              NSFontAttributeName:[UIFont systemFontOfSize:30]};
    
    
    //添加图片
    NSTextAttachment * attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:@"收藏后"];
    attach.bounds = CGRectMake(2, -4, 20, 20);
    NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attach];
    [attributedString appendAttributedString:imageStr];
    
    
//    [attributedString setAttributes:attris range:NSMakeRange(0,attributedString.length)];
    label.attributedText = attributedString;
    }

- (void) loadTextView
{
    TextView *textView = [[TextView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
    [self.view addSubview:textView];
}
@end
