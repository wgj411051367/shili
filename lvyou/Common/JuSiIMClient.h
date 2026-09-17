//
//  JuSiIMClient.h
//  qunxing
//
//  Created by 金颖 on 17/1/17.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
@protocol IJuSiIMServiceCallback <NSObject>
-(void)imMsgReceived:(NSString *)method andParams:(NSDictionary *)params;
-(void)imConnectFailedEvent:(int)code description:(NSString *)description;
@end
@protocol IJuSiIMClientDelegate <IJuSiIMServiceCallback>
-(void)imConnectedEvent;
-(void)imDisconnectedEvent;
@end
@interface JuSiIMClient : NSObject<SRWebSocketDelegate>
//1.19
{
    BOOL isConnected;
}
@property (nonatomic,strong)SRWebSocket *socket;
@property (nonatomic, weak)id <IJuSiIMClientDelegate> delegate;
//@property (nonatomic, assign, getter = getDelegates, setter = addDelegate:)id <IJuSiIMClientDelegate> delegate;
// init
-(id)init:(NSString *)url;
-(id)init:(NSString *)url andParams:(NSArray *)params;

-(void)connect;
//-(void)connect:(NSString *)url;
//-(void)connect:(NSString *)url andParams:(NSArray *)params;
-(BOOL)connected;
-(void)disconnect;

// invoke
-(void)invoke:(NSString *)method withArgs:(NSDictionary *)args;
@end
