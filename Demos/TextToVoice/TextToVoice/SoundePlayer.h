//
//  SoundePlayer.h
//  TextToVoice
//
//  Created by JoKy_Li on 16/1/18.
//  Copyright © 2016年 IVT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundePlayer : NSObject
@property(nonatomic,assign)float rate;
@property(nonatomic,assign)float volume;
@property(nonatomic,assign)BOOL autoPlay;//自动播放

+ (SoundePlayer *)soundPlayerInstance;
- (void)play:(NSString *)text;


@end
