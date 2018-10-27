#Core Spotlight和深度链接结合使用(上)



在iOS 9中苹果推出了新的Search API,可以搜索应用内的一些数据了,Spotlight 和 Safari 可以直接搜App内的内容(in-App Search)，这样用户更容易找到他们想要的内容，哪怕这个内容是在某个 App 内部的，从而大大提高 App 的使用度和曝光度。

 在WWDC公布关于用户习惯的数据，用户有 86% 的时间花在 App 中，仅有 14% 的时间花在 Web 上。所以提高 App 的曝光度和使用度可以大大的提高用户的粘度。
从目前公布的内容上看，他们公布了几个实现这个功能的 API，比如 “Core Spotlight”，“NSUserActivity”，”Web markup”。下面我们就来简单的了解一下这些新的Api.

#iOS 9 Search API概述

	•	(私有设备索引)A private on-device index。保存在用户设备上，不会同步到服务器与其它设备上。 
	•	( server索引)Apple’s server-side index。pubulic index，内容保存在应用服务器。 

##Search API的三种用法

	•	NSUserActivity。这个类我们很熟悉在iOS 8的时候我们就拿它来做Handoff,在iOS 9中我们能拿它来更多的事儿了~在这里我们先说它的搜索功能,当内容被记NSUserActivity，就可以在 Spotlight 和 Safari 中同时被搜索到,现在这里我们只介绍创建用户索引 
	•	Core Spotlight。iOS 9中全新提出的Api,允许App在本地存一个类似索引的文件,可以曾删改查,用来搜索本地内容(on-device index)。适合持续的用户数据。 
	•	Web markup。网站上的内容如何在App中存在可以在搜索显示App相关信息,pubulic index.内容必须在应用服务器,苹果通过applebot获取相关数据，iOS所有用户均可以利用Spotligight和Safari搜索功能获取到相关内容。(国内不支持) 

为App添加Spotlight支持

###注:Spotlight只支持iOS 9+如果你的项目支持iOS 9以下版本需要添加如下方法判断
```objc
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000

//code...

#endif
```


####第一步:导入Framework

>MobileCoreServices.framework
>CoreSpotlight.framework

####第二步:导入头文件

```objc
#import <CoreSpotlight/CoreSpotlight.h>
#import <MobileCoreServices/MobileCoreServices.h>
```

####第三步:创建Spotlight索引

>新建了一个Demo工程做例子演示,最后会提供Demo下载地址

```objc
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

```

```
CSSearchableItemAttributeSet设置Spotlight搜索内容的类,我们可以设置各种属性如下图
```
![Spotlight info](http://7xq8b0.com1.z0.glb.clouddn.com/spotLight_info.png)

方法声明

```objc
- (instancetype)initWithUniqueIdentifier:(NSString *)uniqueIdentifier 
                        domainIdentifier:(NSString *)domainIdentifier 
                            attributeSet:(CSSearchableItemAttributeSet *)attributeSet;

```

参数详解

参数 | 说明
------------ | -------------
uniqueIdentifier | 可以理解为标识符，后面可以用于判断用户点击 Spotlight 的搜索结果，判断用户是通过那个关键字唤起App的。
domainIdentifier| 是确定这个索引数据是属于哪个“范围”的，这个范围可以用来区别不同 app 的索引数据，也可以用于区别同一个app里面不同模块的索引数据。
attributeSet|一组详细数据,指定数据源要显示搜索结果.

[查看官方文档](https://developer.apple.com/reference/corespotlight/cssearchableitem/1621647-initwithuniqueidentifier)

通过上面的操作我们已经可以在Spotlight中搜索到我们创建的索引内容了,可以搜索到了下一步就是怎么通过搜索内容打开相应的页面.

通过搜索结果跳转到相应页面

```objc
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{

      NSString* idetifier = userActivity.userInfo[@"kCSSearchableItemActivityIdentifier"];        //获取传入的索引数据的唯一标识
   if ([idetifier isEqualToString:@"1"]) {
       DemoOneViewController * ovc = [[DemoOneViewController alloc]init];
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
       [navigationController pushViewController: ovc animated:true];
    }
    NSLog(@"%@",idetifier);
    return YES;
}
```

同时Spotlight还提供删除索引方法,过期的索引需要手动删除,系统提供了三个删除索引方法


####通过identifier删除索引
```objc
- (IBAction)deleteSearchableItemFormIdentifier{
   [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[@"1"] completionHandler:^(NSError * _Nullable error) {
       if (error) {
            NSLog(@"%@", error.localizedDescription);
        }else{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"通过identifier删除索引成功" waitUntilDone:NO];
        }
    }];
}
```

####通过DomainIdentifiers删除索引
```objc
- (IBAction)deleteSearchableItemFormDomain{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:@[@"linkedme.cc"] completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }else{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"通过DomainIdentifiers删除索引成功" waitUntilDone:NO];
        }
    }];
}
```
####删除所有索引

```objc
- (IBAction)deleteAllSearchableItem{
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        }else{
            [self performSelectorOnMainThread:@selector(showAlert:) withObject:@"删除所有索引成功" waitUntilDone:NO];
        }
    }];
}
```

[下载Demo](https://github.com/bindx/Spotlight-Demo)
[参考连接LinkedME](https://github.com/WFC-LinkedME/LinkedME-iOS-Deep-Linking-Demo)

