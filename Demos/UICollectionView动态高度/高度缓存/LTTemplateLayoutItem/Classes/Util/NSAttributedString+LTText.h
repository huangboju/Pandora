//
//  NSAttributedString+LTText.h
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/20.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
@interface NSAttributedString (LTText)
NS_ASSUME_NONNULL_BEGIN


@property (nullable, nonatomic, strong, readwrite) UIColor *color;
- (void)setColor:(nullable UIColor *)color range:(NSRange)range;



@end



@interface NSMutableAttributedString (LTText)

- (void)setAttribute:(NSString *)name value:(nullable id)value range:(NSRange)range;

- (void)removeAttributesInRange:(NSRange)range;

@property (nullable, nonatomic, strong, readwrite) UIFont *font;
- (void)setFont:(nullable UIFont *)font range:(NSRange)range;
@end

NS_ASSUME_NONNULL_END