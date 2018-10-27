//
//  NSAttributedString+LTText.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/20.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "NSAttributedString+LTText.h"
#import <CoreFoundation/CoreFoundation.h>
@implementation NSAttributedString (LTText)





@end

@implementation NSMutableAttributedString (LTText)

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index {
    if (!attributeName) return nil;
    if (self.length == 0) return nil;
    if (self.length > 0 && index == self.length) index--;
    return [self attribute:attributeName atIndex:index effectiveRange:NULL];
}

- (void)setAttributes:(NSDictionary *)attributes {
    if (attributes == (id)[NSNull null]) attributes = nil;
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    [attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self setAttribute:key value:obj];
    }];
}

- (void)setAttribute:(NSString *)name value:(id)value {
    [self setAttribute:name value:value range:NSMakeRange(0, self.length)];
}


- (void)setAttribute:(NSString *)name value:(id)value range:(NSRange)range {
    if (!name || [NSNull isEqual:name]) return;
    if (value && ![NSNull isEqual:value]) [self addAttribute:name value:value range:range];
    else [self removeAttribute:name range:range];
}

- (void)setColor:(UIColor *)color range:(NSRange)range {
    [self setAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
    [self setAttribute:NSForegroundColorAttributeName value:color range:range];
}






#define kSystemVersion [UIDevice systemVersion]






- (void)setFont:(UIFont *)font range:(NSRange)range {
    /*
     In iOS7 and later, UIFont is toll-free bridged to CTFontRef,
     although Apple does not mention it in documentation.
     
     In iOS6, UIFont is a wrapper for CTFontRef, so CoreText can alse use UIfont,
     but UILabel/UITextView cannot use CTFontRef.
     
     We use UIFont for both CoreText and UIKit.
     */
    [self setAttribute:NSFontAttributeName value:font range:range];
}

@end