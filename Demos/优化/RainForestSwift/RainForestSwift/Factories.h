
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSParagraphStyle (Factories)
+ (NSParagraphStyle *)justifiedParagraphStyle;
@end

@interface NSShadow (Factories)
+ (NSShadow *)titleTextShadow;
+ (NSShadow *)descriptionTextShadow;
@end

@interface NSAttributedString (Factories)
+ (NSAttributedString *)attributedStringForTitleText:(NSString *)text;
+ (NSAttributedString *)attributedStringForDescription:(NSString *)text;
@end

