//
//  JuSiIMClient.m
//
//  Created by 金颖 on 17/1/17.
//  Copyright © 2017年 Shili. All rights reserved.
//

#import "JuSiIMClient.h"
#import "NSData+Zlib.h"
#import "NSData+AES.h"
@implementation JuSiIMClient
@synthesize socket;

// init
-(id)init:(NSString *)url{
    return [self init:url andParams:nil];
}
-(id)init:(NSString *)url andParams:(NSArray *)params{
    if (self=[super init]) {
         NSLog(@"connect to %@",url);
         isConnected=NO;
         socket.delegate = nil;
         [socket close];
         socket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
         socket.delegate=self;
         [socket open];
    }
    return self;
}
-(void)connect
{
    [socket open];
}
-(void)disconnect{
    if (socket) {
        [socket close];
    }
}

-(BOOL)connected{
    return isConnected;
}
//-(void)presence:(NSString *)userid andToken:(NSString *)token{
//    [self invoke:@"presence" withArgs:[NSDictionary dictionaryWithObjectsAndKeys:userid,@"userid",token,@"token", nil]];
//}
#pragma mark - SRWebSocketDelegate
//连上chat服务器
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    isConnected=YES;
    if (_delegate&&[_delegate respondsToSelector:@selector(imConnectedEvent)]) {
        [_delegate imConnectedEvent];
    }
}
//没有连上chat服务器
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"%@",error);
    if (_delegate&&[_delegate respondsToSelector:@selector(imDisconnectedEvent)]) {
        [_delegate imDisconnectedEvent];
    }
    socket = nil;
    isConnected=NO;
}
-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithData:(NSData *)data{
    NSData *gz_result = [data inflate];
    NSString *jsonString=[[NSString alloc] initWithData:gz_result encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [self dictionaryWithJsonString:jsonString];
    if (_delegate&&[_delegate respondsToSelector:@selector(imMsgReceived:andParams:)]) {
        [_delegate imMsgReceived:[dic objectForKey:@"action"] andParams:dic];
    }
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string;
//{
//    //string解压
//}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    //NSLog(@"WebSocket closed because reason===%@",reason);
    if (_delegate&&[_delegate respondsToSelector:@selector(imConnectFailedEvent:description:)]) {
        [_delegate imConnectFailedEvent:(int)code description:reason];
    }
    if (code==SRStatusCodeGoingAway) {
        return;
    }
    socket = nil;
    isConnected=NO;
}
-(void)invoke:(NSString *)method withArgs:(NSDictionary *)args{
    NSMutableDictionary *param=[NSMutableDictionary dictionaryWithDictionary:args];
    [param setObject:method forKey:@"action"];
    [socket sendData:[self json2data:param] error:nil];
}
-(NSData*)json2data:(id)object
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        //加密
        //NSData* plaitData = [NSData AES128EncryptedData:jsonData];
        //NSMutableData *gz_result = [plaitData deflate:9];
        NSMutableData *gz_result = [jsonData deflate:9];
        return gz_result;
    }
    return nil;
}
@end
