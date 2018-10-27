//
//  LTSingleCollectionViewLayoutViewController.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/21.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "LTSingleCollectionViewLayoutViewController.h"
#import "UICollectionView+LTCollectionViewLayoutCell.h"
#import "LTFeedCell.h"
#import <pthread.h>
#import "YYFPSLabel.h"
#import "UIView+LTadd.h"

#define CELL_COLUMN 1
#define CELL_MARGIN 2
#define kCellPadding 12

static NSString * const reuseIdentitier = @"LTFeedCell";

typedef NSMutableArray <NSMutableArray<NSNumber *> *> IndexCountBySection;

@interface LTSingleCollectionViewLayoutViewController ()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIActionSheetDelegate, LTCollectionViewDynamicHeightCellLayoutDelegate>

@property (nonatomic, copy) NSArray *photoEntityFromFeedJSONData;
@property (nonatomic, strong) NSMutableArray *FeedEntitySections;

@property (nonatomic, strong) IndexCountBySection *indexCountBySectionForHeight;
@property (strong, nonatomic) LTCollectionViewDynamicHeightCellLayout *customizeLayout;

@property (nonatomic) NSInteger cellColumn;
@property (nonatomic) CGFloat cellMargin;

@property (nonatomic, strong) YYFPSLabel *fpsLabel;

@end

@implementation LTSingleCollectionViewLayoutViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _indexCountBySectionForHeight = [NSMutableArray array];
    
    [self initCollectionData];
    
    [self buildData];
    
    [self initDelegate];
    
    [self initData];
    
    [self initFpsLabel];
    
}

- (void)initDelegate {
    _customizeLayout = (LTCollectionViewDynamicHeightCellLayout *) self.collectionViewLayout;
    _customizeLayout.dynamicLayoutDelegate = self;
}

- (void)initCollectionData {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[LTFeedCell class] forCellWithReuseIdentifier:@"LTFeedCell"];
}

- (void)initFpsLabel {
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.bottom = self.view.frame.size.height - kCellPadding;
    _fpsLabel.left = kCellPadding;
    _fpsLabel.alpha = 1.0;
    [self.view addSubview:_fpsLabel];
    
}

- (void) buildData {
    NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *feedDicts = rootDict[@"feed"];
    
    NSMutableArray *entities = @[].mutableCopy;
    [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [entities addObject:[[LTFeedEntity alloc] initWithDictionary:obj]];
    }];
    self.photoEntityFromFeedJSONData = entities;
    self.FeedEntitySections = @[].mutableCopy;
    [self.FeedEntitySections addObject:self.photoEntityFromFeedJSONData.mutableCopy];
    
}

- (void)initData {
    _cellColumn = CELL_COLUMN;
    _cellMargin = CELL_MARGIN;
}

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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LTFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentitier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
    
}

- (void)configureCell:(LTFeedCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.lt_enforceFrameLayout = NO;
    cell.entity = self.FeedEntitySections[indexPath.section][indexPath.row];
    
}
- (IBAction)refreshAction:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.indexCountBySectionForHeight removeAllObjects];
        [self.FeedEntitySections removeAllObjects];
        [self.FeedEntitySections addObject:self.photoEntityFromFeedJSONData.mutableCopy];
        [self.collectionView reloadData];
        [sender endRefreshing];
    });
    
}

- (IBAction)rightAction:(id)sender {
    [[[UIActionSheet alloc]
      initWithTitle:@"Actions"
      delegate:self
      cancelButtonTitle:@"Cancel"
      destructiveButtonTitle:nil
      otherButtonTitles:
      @"Insert a row",
      @"Insert a section",
      @"Delete a section", nil]
     showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    SEL selectors[] = {
        @selector(insertRow),
        @selector(insertSection),
        @selector(deleteSection)
    };
    
    if (buttonIndex < sizeof(selectors) / sizeof(SEL)) {
        void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[buttonIndex]];
        imp(self, selectors[buttonIndex]);
    }
}

- (LTFeedEntity *)randomEntity {
    NSUInteger randomNumber = arc4random_uniform((int32_t)self.photoEntityFromFeedJSONData.count);
    LTFeedEntity *randomEntity = self.photoEntityFromFeedJSONData[randomNumber];
    return randomEntity;
}

- (void)insertRow {
    [self.indexCountBySectionForHeight removeAllObjects];
    if (self.FeedEntitySections.count == 0) {
        [self insertSection];
    } else {
        [self.FeedEntitySections[0] insertObject:self.randomEntity atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
    }
    
}

- (void)insertSection {
    [self.indexCountBySectionForHeight removeAllObjects];
    [self.FeedEntitySections insertObject:@[self.randomEntity].mutableCopy atIndex:0];
    [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:0]];
    
}

- (void)deleteSection {
    [self.indexCountBySectionForHeight removeAllObjects];
    if (self.FeedEntitySections.count > 0) {
        [self.FeedEntitySections removeObjectAtIndex:0];
        [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:0]];
    }
    
}

@end