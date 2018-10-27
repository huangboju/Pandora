//
//  GBPing.h
//  GBPing
//
//  Created by Luka Mirosevic on 05/11/2012.
//  Copyright (c) 2012 Goonbee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GBPingSummary.h"

@class GBPingSummary;
@protocol GBPingDelegate;

typedef void(^StartupCallback)(BOOL success, NSError * _Nullable error);

@interface GBPing : NSObject

@property (weak, nonatomic) _Nullable id <GBPingDelegate>      delegate;

@property (copy, nonatomic) NSString                * _Nullable host;
@property (assign, atomic) NSTimeInterval           pingPeriod;
@property (assign, atomic) NSTimeInterval           timeout;
@property (assign, atomic) NSUInteger               payloadSize;
@property (assign, atomic) NSUInteger               ttl;
@property (assign, atomic, readonly) BOOL           isPinging;
@property (assign, atomic, readonly) BOOL           isReady;

@property (assign, atomic) BOOL                     debug;

@property (strong, atomic) dispatch_semaphore_t _Nullable semaphore;

-(void)setupWithBlock:(StartupCallback _Nullable )callback;
-(void)setupWithIPAddress:(NSString *_Nonnull) IPAdress Block:(StartupCallback _Nullable )callback;
-(void)startPinging;
-(void)stop;

@end

@protocol GBPingDelegate <NSObject>

@optional

-(void)ping:(GBPing * _Nonnull)pinger didFailWithError:(NSError * _Nonnull)error;

-(void)ping:(GBPing * _Nonnull)pinger didSendPingWithSummary:(GBPingSummary * _Nonnull)summary;
-(void)ping:(GBPing * _Nonnull)pinger didFailToSendPingWithSummary:(GBPingSummary * _Nonnull)summary error:(NSError * _Nonnull)error;
-(void)ping:(GBPing * _Nonnull)pinger didTimeoutWithSummary:(GBPingSummary * _Nonnull)summary;
-(void)ping:(GBPing * _Nonnull)pinger didReceiveReplyWithSummary:(GBPingSummary * _Nonnull)summary;
-(void)ping:(GBPing * _Nonnull)pinger didReceiveUnexpectedReplyWithSummary:(GBPingSummary * _Nonnull)summary;

@end
