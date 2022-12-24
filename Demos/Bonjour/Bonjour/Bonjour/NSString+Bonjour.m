//
//  NSString+Bonjour.m
//  Bonjour
//
//  Created by 黄伯驹 on 2017/8/26.
//  Copyright © 2017年 黄伯驹. All rights reserved.
//

#import "NSString+Bonjour.h"

@implementation NSString (Bonjour)
- (NSString*) transmogrify {
    
    NSString* tmp = [NSString stringWithString:self];
    const char *ostr = [tmp UTF8String];
    const char *cstr = ostr;
    char *ptr = (char*) ostr;
    
    while (*cstr) {
        char c = *cstr++;
        if (c == '\\')
        {
            c = *cstr++;
            if (isdigit(cstr[-1]) && isdigit(cstr[0]) && isdigit(cstr[1]))
            {
                NSInteger v0 = cstr[-1] - '0';						// then interpret as three-digit decimal
                NSInteger v1 = cstr[ 0] - '0';
                NSInteger v2 = cstr[ 1] - '0';
                NSInteger val = v0 * 100 + v1 * 10 + v2;
                if (val <= 255) { c = (char)val; cstr += 2; }	// If valid three-digit decimal value, use it
            }
        }
        *ptr++ = c;
    }
    ptr--;
    *ptr = 0;
    return [NSString stringWithUTF8String:ostr];
}

@end
