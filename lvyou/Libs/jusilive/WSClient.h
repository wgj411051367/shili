//
//  WSClient.h
//  Shili
//
//  Copyright © Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"

@protocol SLLiveSocketServiceCallback <NSObject>
- (void)resultReceived:(NSString *)method andParams:(NSDictionary *)params;
- (void)connectFailedEvent:(int)code description:(NSString *)description;
@end

@protocol SLLiveSocketDelegate <SLLiveSocketServiceCallback>
- (void)connectedEvent;
- (void)disconnectedEvent;
@end

@interface SLLiveSocket : NSObject <SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *socket;
@property (nonatomic, weak) id<SLLiveSocketDelegate> delegate;

- (instancetype)init:(NSString *)url;
- (instancetype)init:(NSString *)url andParams:(NSArray *)params;

- (void)connect;
- (BOOL)connected;
- (void)disconnect;

- (void)invoke:(NSString *)method withArgs:(NSDictionary *)args;

@end
