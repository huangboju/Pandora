//
//  DemoDetailViewController.m
//  MGJRequestManagerDemo
//
//  Created by limboy on 3/20/15.
//  Copyright (c) 2015 juangua. All rights reserved.
//

#import "DemoDetailViewController.h"
#import "DemoListViewController.h"
#import "MGJRouter.h"

@interface DemoDetailViewController ()
@property (nonatomic) UITextView *resultTextView;
@property (nonatomic) SEL selectedSelector;
@end

@implementation DemoDetailViewController

+ (void)load
{
    DemoDetailViewController *detailViewController = [[DemoDetailViewController alloc] init];
    [DemoListViewController registerWithTitle:@"基本使用" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoBasicUsage);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"中文匹配" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoChineseCharacter);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"自定义参数" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoParameters);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"传入字典信息" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoUserInfo);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"Fallback 到全局的 URL Pattern" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoFallback);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"Open 结束后执行 Completion Block" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoCompletion);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"基于 URL 模板生成 具体的 URL" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoGenerateURL);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"取消注册 URL Pattern" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoDeregisterURLPattern);
        return detailViewController;
    }];
    
    [DemoListViewController registerWithTitle:@"同步获取 URL 对应的 Object" handler:^UIViewController *{
        detailViewController.selectedSelector = @selector(demoObjectForURL);
        return detailViewController;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:239.f/255 green:239.f/255 blue:244.f/255 alpha:1];
    [self.view addSubview:self.resultTextView];
    // Do any additional setup after loading the view.
}

- (void)appendLog:(NSString *)log
{
    NSString *currentLog = self.resultTextView.text;
    if (currentLog.length) {
        currentLog = [currentLog stringByAppendingString:[NSString stringWithFormat:@"\n----------\n%@", log]];
    } else {
        currentLog = log;
    }
    self.resultTextView.text = currentLog;
    [self.resultTextView sizeThatFits:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.resultTextView.subviews enumerateObjectsUsingBlock:^(UIImageView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            // 这个是为了去除显示图片时，添加的 imageView
            [obj removeFromSuperview];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.resultTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self performSelector:self.selectedSelector withObject:nil afterDelay:0];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.resultTextView removeObserver:self forKeyPath:@"contentSize"];
    self.resultTextView.text = @"";
}

- (UITextView *)resultTextView
{
    if (!_resultTextView) {
        NSInteger padding = 20;
        NSInteger viewWith = self.view.frame.size.width;
        NSInteger viewHeight = self.view.frame.size.height - 64;
        _resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(padding, padding + 64, viewWith - padding * 2, viewHeight - padding * 2)];
        _resultTextView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        _resultTextView.layer.borderWidth = 1;
        _resultTextView.editable = NO;
        _resultTextView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _resultTextView.font = [UIFont systemFontOfSize:14];
        _resultTextView.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        _resultTextView.contentOffset = CGPointZero;
    }
    return _resultTextView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        NSInteger contentHeight = self.resultTextView.contentSize.height;
        NSInteger textViewHeight = self.resultTextView.frame.size.height;
        [self.resultTextView setContentOffset:CGPointMake(0, MAX(contentHeight - textViewHeight, 0)) animated:YES];
    }
}

#pragma mark - Demos

- (void)demoFallback
{
    [MGJRouter registerURLPattern:@"mgj://" toHandler:^(NSDictionary *routerParameters) {
        [self appendLog:@"匹配到了 url，以下是相关信息"];
        [self appendLog:[NSString stringWithFormat:@"routerParameters:%@", routerParameters]];
    }];
    
    [MGJRouter registerURLPattern:@"mgj://foo/bar/none/exists" toHandler:^(NSDictionary *routerParameters) {
        [self appendLog:@"it should be triggered"];
    }];
    
    [MGJRouter openURL:@"mgj://foo/bar"];
}

- (void)demoBasicUsage
{
    [MGJRouter registerURLPattern:@"mgj://foo/bar" toHandler:^(NSDictionary *routerParameters) {
        [self appendLog:@"匹配到了 url，以下是相关信息"];
        [self appendLog:[NSString stringWithFormat:@"routerParameters:%@", routerParameters]];
    }];
    
    [MGJRouter openURL:@"mgj://foo/bar"];
}

- (void)demoChineseCharacter
{
    [MGJRouter registerURLPattern:@"mgj://category/家居" toHandler:^(NSDictionary *routerParameters) {
        [self appendLog:@"匹配到了 url，以下是相关信息"];
        [self appendLog:[NSString stringWithFormat:@"routerParameters:%@", routerParameters]];
    }];
    
    [MGJRouter openURL:@"mgj://category/家居"];
}

- (void)demoUserInfo
{
    [MGJRouter registerURLPattern:@"mgj://category/travel" toHandler:^(NSDictionary *routerParameters) {
        [self appendLog:@"匹配到了 url，以下是相关信息"];
        [self appendLog:[NSString stringWithFormat:@"routerParameters:%@", routerParameters]];
    }];
    
    [MGJRouter openURL:@"mgj://category/travel" withUserInfo:@{@"user_id": @1900} completion:nil];
}

- (void)demoParameters
{
    [MGJRouter registerURLPattern:@"mgj://search/:query" toHandler:^(NSDictionary *routerParameters) {
        [self appendLog:@"匹配到了 url，以下是相关信息"];
        [self appendLog:[NSString stringWithFormat:@"routerParameters:%@", routerParameters]];
    }];
    
    [MGJRouter openURL:@"mgj://search/bicycle?color=red"];
}

- (void)demoCompletion
{
[MGJRouter registerURLPattern:@"mgj://detail" toHandler:^(NSDictionary *routerParameters) {
    NSLog(@"匹配到了 url, 一会会执行 Completion Block");
    
    // 模拟 push 一个 VC
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        void (^completion)(id result) = routerParameters[MGJRouterParameterCompletion];
        if (completion) {
            completion(nil);
        }
    });
}];

[MGJRouter openURL:@"mgj://detail" withUserInfo:nil completion:^(id result){
    [self appendLog:@"Open 结束，我是 Completion Block"];
}];
}

- (void)demoGenerateURL
{
#define TEMPLATE_URL @"mgj://search/:keyword"
    
[MGJRouter registerURLPattern:TEMPLATE_URL  toHandler:^(NSDictionary *routerParameters) {
    NSLog(@"routerParameters[keyword]:%@", routerParameters[@"keyword"]); // Hangzhou
}];

[MGJRouter openURL:[MGJRouter generateURLWithPattern:TEMPLATE_URL parameters:@[@"Hangzhou"]]];
}

- (void)demoDeregisterURLPattern
{
#define TEMPLATE_URL @"mgj://search/:keyword"
    
    [MGJRouter registerURLPattern:TEMPLATE_URL  toHandler:^(NSDictionary *routerParameters) {
        NSAssert(NO, @"这里不会被触发");
        NSLog(@"routerParameters[keyword]:%@", routerParameters[@"keyword"]); // Hangzhou
    }];
    
    [MGJRouter deregisterURLPattern:TEMPLATE_URL];

    [MGJRouter openURL:[MGJRouter generateURLWithPattern:TEMPLATE_URL parameters:@[@"Hangzhou"]]];
    
    [self appendLog:@"如果没有运行到断点，就表示取消注册成功了"];
}

- (void)demoObjectForURL
{
    [MGJRouter registerURLPattern:@"mgj://search_top_bar" toObjectHandler:^id(NSDictionary *routerParameters) {
        UIView *searchTopBar = [[UIView alloc] init];
        return searchTopBar;
    }];
    
    UIView *searchTopBar = [MGJRouter objectForURL:@"mgj://search_top_bar"];
    
    if ([searchTopBar isKindOfClass:[UIView class]]) {
        [self appendLog:@"同步获取 Object 成功"];
    } else {
        [self appendLog:@"同步获取 Object 失败"];
    }
}

- (void)dealloc {
    NSLog(@"😁");
}

@end
