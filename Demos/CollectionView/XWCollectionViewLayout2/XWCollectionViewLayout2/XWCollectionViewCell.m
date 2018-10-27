//
//  XWCollectionViewCell.m
//  XWCollectionViewLayout2
//
//  Created by 温仲斌 on 15/12/31.
//  Copyright © 2015年 温仲斌. All rights reserved.
//

#import "XWCollectionViewCell.h"

@implementation XWCollectionViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ta:)];
//        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)ta:(id)sender {
    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self.layer setMasksToBounds:NO];
    [self.layer setShadowColor:[[UIColor blackColor ] CGColor ] ];
    [self.layer setShadowOpacity:0.5 ];
    [self.layer setShadowRadius:5.0 ];
    [self.layer setShadowOffset:CGSizeMake( 0 , 0 ) ];
    self.layer.cornerRadius = 5.0;
//    self.clipsToBounds = YES;
}

@end
