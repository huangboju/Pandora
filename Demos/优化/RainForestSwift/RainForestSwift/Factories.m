
#import "Factories.h"

@implementation NSAttributedString (Factories)
+ (NSAttributedString *)attributedStringForTitleText:(NSString *)text
{
    NSDictionary *titleAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Heavy" size:30], NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: [NSShadow titleTextShadow], NSParagraphStyleAttributeName: [NSParagraphStyle justifiedParagraphStyle]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:titleAttributes];
}

+ (NSAttributedString *)attributedStringForDescription:(NSString *)text
{
    NSDictionary *descriptionAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-Medium" size:16],
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSBackgroundColorAttributeName: [UIColor clearColor],
                                      NSShadowAttributeName: [NSShadow descriptionTextShadow], NSParagraphStyleAttributeName: [NSParagraphStyle justifiedParagraphStyle]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:descriptionAttributes];
}
@end

@implementation NSParagraphStyle (Factories)
+ (NSParagraphStyle *)justifiedParagraphStyle
{
    NSMutableParagraphStyle *paragraphStlye = [[NSMutableParagraphStyle alloc] init];
    paragraphStlye.alignment = NSTextAlignmentJustified;
    return paragraphStlye;
}

@end

@implementation NSShadow (Factories)
+ (NSShadow *)titleTextShadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
    shadow.shadowOffset = CGSizeMake(0, 2);
    shadow.shadowBlurRadius = 3.0;
    
    return shadow;
}

+ (NSShadow *)descriptionTextShadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    shadow.shadowOffset = CGSizeMake(0, 1);
    shadow.shadowBlurRadius = 3.0;
    
    return shadow;
}
@end