//
//  LTWallEntity.m
//  LTTemplateLayoutItem
//
//  Created by lmj  on 16/8/19.
//  Copyright © 2016年 linmingjun. All rights reserved.
//

#import "LTWallEntity.h"

@implementation LTWallEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _identifier = [self uniqueIdentifier];
        _imageName = dictionary[@"imageName"];
    }
    return self;
}

- (NSString *)uniqueIdentifier
{
    static NSInteger counter = 0;
    return [NSString stringWithFormat:@"unique-id-%@", @(counter++)];
}


@end
