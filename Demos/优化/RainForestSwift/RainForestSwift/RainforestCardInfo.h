
#import <Foundation/Foundation.h>

@interface RainforestCardInfo : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *animalDescription;
@property (strong, nonatomic) NSURL *imageURL;

+ (NSArray<RainforestCardInfo *> *)birdCards;
+ (NSArray<RainforestCardInfo *> *)mammalCards;
+ (NSArray<RainforestCardInfo *> *)reptileCards;

+ (NSArray<RainforestCardInfo *> *)allAnimals;

@end
