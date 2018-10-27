//
//  UICollectionView+LTCollectionViewLayoutCell.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/17.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "UICollectionView+LTCollectionViewLayoutCell.h"
#import <objc/runtime.h>

@implementation UICollectionView (LTCollectionViewLayoutCell)

- (CGFloat)lt_systemFittingHeightForConfiguratedCell:(UICollectionViewCell *)cell {
    
//    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    CGFloat contentViewWidth = CGRectGetWidth(cell.contentView.frame);
    CGFloat fittingHeight = 0;
    if (!cell.lt_enforceFrameLayout && contentViewWidth > 0) {
        
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
        [cell.contentView addConstraint:widthFenceConstraint];
        
        fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [cell.contentView removeConstraint:widthFenceConstraint];
        
        [self lt_debugLog:[NSString stringWithFormat:@"calculate using system fitting size (AutoLayout) - %@", @(fittingHeight)]];
    }
    if (fittingHeight == 0) {
#if DEBUG
        if (cell.contentView.constraints.count > 0) {
            if (!objc_getAssociatedObject(self, _cmd)) {
                NSLog(@"Warning once only: Cannot get a proper cell height (now 0) from '- systemFittingSize:'(AutoLayout). You should check how constraints are built in cell, making it into 'self-sizing' cell.");
                objc_setAssociatedObject(self, _cmd, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
#endif
        fittingHeight = [cell sizeThatFits:CGSizeMake(contentViewWidth, 0)].height;
        
        [self lt_debugLog:[NSString stringWithFormat:@"calculate using sizeThatFits - %@", @(fittingHeight)]];
    }
    
    if (fittingHeight == 0) {
        fittingHeight = 44;
    }
    
    
    return fittingHeight;
}

- (__kindof UICollectionViewCell *)lt_templateCellForReuseIdentifier:(NSString *)identifier  forIndexPath:(NSIndexPath *)indexPath {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    NSMutableDictionary<NSString *, UICollectionViewCell *> *templateCellsByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateCellsByIdentifiers) {
        templateCellsByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateCellsByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UICollectionViewCell *templateCell = templateCellsByIdentifiers[identifier];
    if (!templateCell) {
        
        Class class = NSClassFromString(identifier);
        templateCell = [[class alloc] init];
            NSAssert(templateCell != nil, @"Cell must be registered to table view for identifier - %@", identifier);
            templateCell.lt_isTemplateLayoutCell = YES;
            templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
            templateCellsByIdentifiers[identifier] = templateCell;
            [self lt_debugLog:[NSString stringWithFormat:@"layout cell created - %@", identifier    ]];
    }
    
    return templateCell;
}

- (CGFloat)lt_heightForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration {
    if (!identifier) {
        return 0;
    }
    
    UICollectionViewCell *templateLayoutCell = [self lt_templateCellForReuseIdentifier:identifier forIndexPath:indexPath];
    
    [templateLayoutCell prepareForReuse];
    
    if (configuration) {
        configuration(templateLayoutCell);
    }
    
    return [self lt_systemFittingHeightForConfiguratedCell:templateLayoutCell];
}

- (CGFloat)lt_heightForCellWithIdentifier:(NSString *)identifier cacheByIndexPath:(NSIndexPath *)indexPath configuration:(void (^)(id cell))configuration {
    if (!identifier || !indexPath) {
        return 0;
    }

    if ([self.lt_indexPathHeightCache existsHeightAtIndexPath:indexPath]) {
        [self lt_debugLog:[NSString stringWithFormat:@"hit cache by index path[%@:%@] - %@", @(indexPath.section), @(indexPath.row), @([self.lt_indexPathHeightCache heightForIndexPath:indexPath])]];
        return [self.lt_indexPathHeightCache heightForIndexPath:indexPath];
    }
    
    CGFloat height = [self lt_heightForCellWithIdentifier:identifier forIndexPath:indexPath configuration:configuration];
    [self.lt_indexPathHeightCache cacheHeight:height byIndexPath:indexPath];
    [self lt_debugLog:[NSString stringWithFormat: @"cached by index path[%@:%@] - %@", @(indexPath.section), @(indexPath.row), @(height)]];
    
    return height;
}

- (CGFloat)lt_heightForCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath cacheByKey:(id<NSCopying>)key configuration:(void (^)(id cell))configuration {
    if (!identifier || !key) {
        return 0;
    }

    if ([self.lt_keyedHeightCache existsHeightForKey:key]) {
        CGFloat cachedHeight = [self.lt_keyedHeightCache heightForKey:key];
        [self lt_debugLog:[NSString stringWithFormat:@"hit cache by key[%@] - %@", key, @(cachedHeight)]];
        return cachedHeight;
    }
    
    CGFloat height = [self lt_heightForCellWithIdentifier:identifier forIndexPath:indexPath configuration:configuration];
    [self.lt_keyedHeightCache cacheHeight:height byKey:key];
    [self lt_debugLog:[NSString stringWithFormat:@"cached by key[%@] - %@", key, @(height)]];
    
    return height;
}

@end

@implementation UICollectionViewCell (LTTemplateLayoutCell)

- (BOOL)lt_isTemplateLayoutCell {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLt_isTemplateLayoutCell:(BOOL)isTemplateLayoutCell {
    
    objc_setAssociatedObject(self, @selector(lt_isTemplateLayoutCell), @(isTemplateLayoutCell), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)lt_enforceFrameLayout {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setLt_enforceFrameLayout:(BOOL)enforceFrameLayout {
    objc_setAssociatedObject(self, @selector(lt_enforceFrameLayout), @(enforceFrameLayout), OBJC_ASSOCIATION_RETAIN);
}

@end


