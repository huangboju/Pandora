# LTTemplateLayoutItem
UICollectionView Automatic Layout Framework

#Features 
*   UICollectionView高度宽度自适应
*   分栏布局

#使用过程：

**1.使用XIB需要将该Cell的ReuseIdentifier注册到UICollectionView，可以使用registerClass或registerNib**

	 [self.collectionView registerClass:[WallterCollectionViewCell class] forCellWithReuseIdentifier:@"WallterCollectionViewCell"];

**2.使用XIB用到UICollectionViewLayout自定义布局时，需要设置XIB如图1.2所示** 

![图1-2](http://upload-images.jianshu.io/upload_images/1231308-39322939363be3a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

**3.宽度自适应使用实现LTCollectionViewDynamicHeightCellLayout代理方法传入对应列数即可** 

	@protocol LTCollectionViewDynamicHeightCellLayoutDelegate <NSObject>

	@required
	- (NSInteger)numberOfColumnWithCollectionView:(UICollectionView *)collectionView
	                         collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout;
	@required
	- (CGFloat)marginOfCellWithCollectionView:(UICollectionView *)collectionView
	                     collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout;
	@required
	- (NSMutableArray <NSMutableArray *> *)indexHeightOfCellWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout;

#GIF演示内容
  
## 两栏布局，实现LTCollectionViewDynamicHeightCellLayout代理方法
![](http://upload-images.jianshu.io/upload_images/1231308-799f1d6dcf41196c.gif?imageMogr2/auto-orient/strip)

## 一栏布局图文布局，可选UICollectionView或LTCollectionViewDynamicHeightCellLayout代理方法实现
![](http://upload-images.jianshu.io/upload_images/1231308-0475c0d9381093e2.gif?imageMogr2/auto-orient/strip)


## 一栏布局图片布局，可选UICollectionView或LTCollectionViewDynamicHeightCellLayout代理方法实现
![](http://upload-images.jianshu.io/upload_images/1231308-161caaffc69b0b89.gif?imageMogr2/auto-orient/strip)

## 两栏图文布局，使用LTCollectionViewDynamicHeightCellLayout代理方法实现
![](http://upload-images.jianshu.io/upload_images/1231308-7ca1b9724203facc.gif?imageMogr2/auto-orient/strip)

## 实现LTCollectionViewDynamicHeightCellLayout代理方法，多栏布局只需要修改一行代码实现
![](http://upload-images.jianshu.io/upload_images/1231308-6876933c6b531d85.gif?imageMogr2/auto-orient/strip)


![演示图](http://upload-images.jianshu.io/upload_images/1231308-e70471750e0a7b66.gif?imageMogr2/auto-orient/strip)

#使用介绍
**1.单栏布局自适应高度（不使用UICollectionViewLayout**

主要代码：

	- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
	{
	    LTFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentitier forIndexPath:indexPath];
	    [self configureCell:cell atIndexPath:indexPath];
	    return cell;
	}

**2.多栏布局自适应高度（实现LTCollectionViewDynamicHeightCellLayout代理方法)**

主要代码


	#pragma mark - LTCollectionViewDynamicHeightCellLayoutDelegate
	- (NSInteger) numberOfColumnWithCollectionView:(UICollectionView *)collectionView
	                          collectionViewLayout:( LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout{
	    return _cellColumn;
	}

	- (CGFloat) marginOfCellWithCollectionView:(UICollectionView *)collectionView
	                      collectionViewLayout:(LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout{
	    return _cellMargin;
	}


	- (NSMutableArray<NSMutableArray *> *)indexHeightOfCellWithCollectionView:(UICollectionView *)collectionView collectionViewLayout:(LTCollectionViewDynamicHeightCellLayout *)collectionViewLayout {
	    return _indexCountBySectionForHeight;
	}


	#pragma mark UICollectionViewDataSource
	- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
	{
	    
	    return self.FeedEntitySections.count;
	}

	- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
	{
	    NSMutableArray<NSNumber *> *indexHeightArray = @[].mutableCopy;
	    for (NSInteger i = 0; i < [self.FeedEntitySections[section] count]; i++) {
	        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
	        CGFloat height= [collectionView lt_heightForCellWithIdentifier:reuseIdentitier cacheByIndexPath:indexPath configuration:^(LTFeedCell *cell) {
	            [self configureCell:cell atIndexPath:indexPath];
	        }];
	        
	        [indexHeightArray addObject:@(height)];
	    }
	    _indexCountBySectionForHeight[section] = indexHeightArray;
	    return [self.FeedEntitySections[section] count];
	}
	

#文章

[UICollectionView高度宽度自适应缓存框架](http://www.jianshu.com/writer#/notebooks/2507585/notes/5025681/preview)

#感谢：

[sunnyxx](https://github.com/forkingdog) <br/>
[青玉伏案](https://github.com/lizelu)
