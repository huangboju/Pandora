# SLPagingView
[![Build Status](https://travis-ci.org/StefanLage/SLPagingView.svg?branch=master)](https://travis-ci.org/StefanLage/SLPagingView)
[![Version](https://img.shields.io/cocoapods/v/SLPagingView.svg?style=flat)](http://cocoadocs.org/docsets/SLPagingView)
[![License](https://img.shields.io/cocoapods/l/SLPagingView.svg?style=flat)](http://cocoadocs.org/docsets/SLPagingView)

A navigation bar system allowing to do a Tinder like or Twitter like.

<div style="width:100%; height:450px;">
<img src="Demos/TinderLike/tinder.gif" align="left" height="440" width="250" style="margin-left:20px;">
<img src="Demos/TwitterLike/twitter.gif" algin="right" height="440" width="250" style="margin-left:50px;">
</div>

## Requirements

* iOS 7.0+ 
* ARC

## Installation

### CocoaPods

[CocosPods](http://cocosPods.org) is the recommended method to install SLPagingView.

Add the following line to your Podfile:

```ruby
pod 'SLPagingView'
```

And run
```ruby
pod install
```

### Manual

Import SLPagingView folder into your project.


## How to use

Easy to implement:

```` objective-c

	// Make views for the navigation bar
    UIImage *img1 = [UIImage imageNamed:@"gear"];
    img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *img2 = [UIImage imageNamed:@"profile"];
    img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImage *img3 = [UIImage imageNamed:@"chat"];
    img3 = [img3 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    NSArray *titles = @[[[UIImageView alloc] initWithImage:img1], [[UIImageView alloc] initWithImage:img2], [[UIImageView alloc] initWithImage:img3]];
    NSArray *views = @[[self viewWithBackground:orange], [self viewWithBackground:[UIColor yellowColor]], [self viewWithBackground:gray]];
    
    SLPagingViewController *pageViewController = [[SLPagingViewController alloc] initWithNavBarItems:titles
                                                                                    navBarBackground:[UIColor whiteColor]
                                                                                               views:views
                                                                                     showPageControl:NO];

````

Then you can make your own behaviors:

````objective-c

	// Tinder Like
    pageViewController.pagingViewMovingRedefine = ^(UIScrollView *scrollView, NSArray *subviews){
        int i = 0;
        for(UIImageView *v in subviews){
            UIColor *c = gray;
            if(v.frame.origin.x > 45
               && v.frame.origin.x < 145)
                // Left part
                c = [self gradient:v.frame.origin.x
                               top:46
                            bottom:144
                              init:orange
                              goal:gray];
            else if(v.frame.origin.x > 145
                    && v.frame.origin.x < 245)
                // Right part
                c = [self gradient:v.frame.origin.x
                               top:146
                            bottom:244
                              init:gray
                              goal:orange];
            else if(v.frame.origin.x == 145)
                c = orange;
            v.tintColor= c;
            i++;
        }
     };

````

##Other sample

Twitter like behaviors

````objective-c

	// Twitter Like
    pageViewController.pagingViewMovingRedefine = ^(UIScrollView *scrollView, NSArray *subviews){
        CGFloat xOffset = scrollView.contentOffset.x;
        int i = 0;
        for(UILabel *v in subviews){
            CGFloat alpha = 0.0;
            if(v.frame.origin.x < 145)
                alpha = 1 - (xOffset - i*320) / 320;
            else if(v.frame.origin.x >145)
                alpha=(xOffset - i*320) / 320 + 1;
            else if(v.frame.origin.x == 140)
                alpha = 1.0;
            i++;
            v.alpha = alpha;
        }
    };
````

##API

###Set current page

If you want to changed the default page control index (or whatever) you can do it calling:

````objective-c

	-(void)setCurrentIndex:(NSInteger)index animated:(BOOL)animated;
````

###Navigation items style

<img src="Demos/TinderLike/navigation_style.gif" height="440" width="250" style="margin-left:50px;">

You can easily customized the navigation items setting up:


````objective-c

	@property (nonatomic) SLNavigationSideItemsStyle navigationSideItemsStyle;
````


By using one of these values:


````objective-c

	typedef NS_ENUM(NSInteger, SLNavigationSideItemsStyle) {
		SLNavigationSideItemsStyleOnBounds,
		SLNavigationSideItemsStyleClose,
		SLNavigationSideItemsStyleNormal,
		SLNavigationSideItemsStyleFar,
		SLNavigationSideItemsStyleDefault,
		SLNavigationSideItemsStyleCloseToEachOne
	};
````

###Set navigation bar's background color

You can update the background color of the navigation bar using the following method:

````objective-c

	setNavigationBarColor:(UIColor*) color;
````

##Storyboard support

This class can be implemented using Storyboard.
You need to set all identifiers of the segues linked to your SLPagingViewController respecting this syntax: 
` sl_X where X ∈ [0..N] `.

X corresponding to the index of the view, start from 0 and it works in ascending order.

![segue](Demos/TinderStoryboard/segue_params.png)

You can find an example "TinderStoryboard" for more informations.

###Set navigation bar's background color
To set up the navigation bar's background color from the storyboard, you just need to it like all navigation bar.

![segue](Demos/TinderStoryboard/navigation_bar_color.png)

##License
Available under MIT license, please read LICENSE for more informations.