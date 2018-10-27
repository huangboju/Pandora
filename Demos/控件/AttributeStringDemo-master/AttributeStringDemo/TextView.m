//
//  TextView.m
//  AttributeStringDemo
//
//  Created by caiiiac on 15/8/10.
//  Copyright (c) 2015年 sun3d. All rights reserved.
//

#import "TextView.h"

@implementation TextView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    NSMutableAttributedString * attributeStr = [[NSMutableAttributedString alloc] initWithString:@"绘图风格（居中，换行模式，间距等诸多风格），value是NSParagraphStyle对象"];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;
    paragraphStyle.headIndent = 4.0;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.lineSpacing = 2.0;
    NSDictionary * attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
    [attributeStr setAttributes:attributes range:NSMakeRange(0, attributeStr.length)];
    [attributeStr drawInRect:self.bounds];

}


@end
