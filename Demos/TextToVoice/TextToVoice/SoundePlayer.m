//
//  SoundePlayer.m
//  TextToVoice
//
//  Created by JoKy_Li on 16/1/18.
//  Copyright © 2016年 IVT. All rights reserved.
//

#import "SoundePlayer.h"
static SoundePlayer *soundPlayer = nil;

@interface SoundePlayer()
{
    NSMutableDictionary *soundSet;
    NSString *path;
}
@property(nonatomic,assign)float pitchMultuplier;//音调
- (void)setDefault;
- (void)writeSoundSet;

@end

@implementation SoundePlayer
+ (SoundePlayer *)soundPlayerInstance
{
    if(soundPlayer == nil)
        
    {
        soundPlayer = [[SoundePlayer alloc] init];
        [soundPlayer initSoundSet];

        NSLog(@"%@",[AVSpeechSynthesisVoice speechVoices]);
    }
    return  soundPlayer;
}
- (void)initSoundSet
{
    path = [[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"SoundSet.plist"];
    soundSet = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    if (soundSet == nil) {
        soundSet = [NSMutableDictionary dictionary];
        [soundPlayer setDefault];
        [soundPlayer writeSoundSet];
    }else
    {
        self.autoPlay = [[soundSet valueForKeyPath:@"autoPlay"] boolValue];
        self.volume = [[soundSet valueForKeyPath:@"volume"] floatValue];
        self.rate  = [[soundSet valueForKeyPath:@"rate"] floatValue];
        self.pitchMultuplier = [[soundSet valueForKeyPath:@"pitchMultuplier"] floatValue];
    }
}

//声音
- (void)play:(NSString *)text
{
    if (text != nil) {
        AVSpeechSynthesizer *player = [[AVSpeechSynthesizer alloc] init];
        //设置朗读的字符
        AVSpeechUtterance *u = [[AVSpeechUtterance alloc] initWithString:text];
        //zh-CN: zh-HK: zh-TW
        u.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        u.volume = self.volume;
        u.rate = self.rate;
        u.pitchMultiplier = self.pitchMultuplier;
        [player speakUtterance:u];
    }
}

- (void)setDefault
{
    self.volume = 0.7;
    self.rate = 0.5;
    self.pitchMultuplier = 1.0;
}

//将设置写入配置文件
- (void)writeSoundSet
{
    [soundSet setValue:[NSNumber numberWithBool:self.autoPlay] forKey:@"autoPlay"];
    [soundSet setValue:[NSNumber numberWithFloat:self.volume] forKey:@"volume"];
    
    [soundSet setValue:[NSNumber numberWithFloat:self.rate] forKey:@"rate"];
    [soundSet setValue:[NSNumber numberWithFloat:self.pitchMultuplier] forKey:@"pitchMultuplier"];
    [soundSet writeToFile:path atomically:YES];
    
}
@end
