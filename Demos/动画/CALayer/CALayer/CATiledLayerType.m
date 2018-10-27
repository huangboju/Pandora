//
//  CATiledLayerType.m
//  CALayer
//
//  Created by Lqq on 16/1/1.
//  Copyright © 2016年 董知樾. All rights reserved.
//

#import "CATiledLayerType.h"

@interface CATiledLayerType ()

@property (nonatomic , weak)CATiledLayer *tiledLayer;

@end

@implementation CATiledLayerType

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cutImageAndSave];
    [self addTiledLayer];
    
}

/**
 *  平铺layer 可用于展示大图
 *  展示大图时可能会引起卡顿(阻塞主线程),将大图切分成小图,然后用到他们(需要展示)的时候再加载(读取)
 */
- (void)addTiledLayer{
    //BingWallpaper-2015-11-22.jpg
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    //    UIImage *image = [UIImage imageNamed:@"BingWallpaper-2015-11-22.jpg"];
    
    CATiledLayer *tiledLayer = [CATiledLayer layer];
    //layer->像素 和 点 的概念不同 一个点是[UIScreen mainScreen].scale个像素
    //    CGFloat screenScale = [UIScreen mainScreen].scale;
    //    tiledLayer.contentsScale = screenScale;
    tiledLayer.frame = CGRectMake(0, 0, 1920, 1200);//image.size.width, image.size.height);
    tiledLayer.delegate = self;
    
    _tiledLayer = tiledLayer;
    
    scrollView.contentSize = tiledLayer.frame.size;
    //CGSizeMake(image.size.width / screenScale, image.size.height / screenScale);
    [scrollView.layer addSublayer:tiledLayer];
    [tiledLayer setNeedsDisplay];
}

/**
 *  CALayerDelegate
 *  支持多线程绘制，-drawLayer:inContext:方法可以在多个线程中同时地并发调用
 *  所以请小心谨慎地确保你在这个方法中实现的绘制代码是线程安全的.(不懂哎)
 */
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx{
    
    //获取图形上下文的位置与大小
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    //floor 向下取整
    NSInteger x = floor(bounds.origin.x / layer.tileSize.width);
    // * [UIScreen mainScreen].scale);
    NSInteger y = floor(bounds.origin.y / layer.tileSize.height);
    // * [UIScreen mainScreen].scale);
    
    //load tile image
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *imageName = [NSString stringWithFormat:@"%@/初雪-%02ld-%02ld.png",filePath,(long)x,(long)y];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imageName];
    
    UIGraphicsPushContext(ctx);
    //绘制
    
    [tileImage drawInRect:bounds];
    UIGraphicsPopContext();
}

/** 切图并保存到沙盒中 */
- (void)cutImageAndSave{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *imageName = [NSString stringWithFormat:@"%@/初雪-00-00.png",filePath];
    UIImage *tileImage = [UIImage imageWithContentsOfFile:imageName];
    NSLog(@"%@",imageName);
    if (tileImage) return;
    
    UIImage *image = [UIImage imageNamed:@"BingWallpaper-2015-11-22.jpg"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    //    [self.view addSubview:imageView];
    CGFloat WH = 256;
    CGSize size = image.size;
    
    //ceil 向上取整
    NSInteger rows = ceil(size.height / WH);
    NSInteger cols = ceil(size.width / WH);
    
    for (NSInteger y = 0; y < rows; ++y) {
        for (NSInteger x = 0; x < cols; ++x) {
            UIImage *subImage = [self captureView:imageView frame:CGRectMake(x*WH, y*WH, WH, WH)];
            NSString *path = [NSString stringWithFormat:@"%@/初雪-%02ld-%02ld.png",filePath,x,y];
            [UIImagePNGRepresentation(subImage) writeToFile:path atomically:YES];
        }
    }
}

/** 切图 */
- (UIImage*)captureView:(UIView *)theView frame:(CGRect)fra{
    //开启图形上下文 将heView的所有内容渲染到图形上下文中
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, fra);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    
    return i;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc {
    [_tiledLayer removeFromSuperlayer];
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
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com