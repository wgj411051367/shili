//
//  WSClient.m
//  Shili
//
//  Copyright © Shili. All rights reserved.
//

#import "WSClient.h"

@interface SLLiveSocket ()
{
    BOOL _active;
}
@end

@implementation SLLiveSocket

#pragma mark - Lifecycle

- (instancetype)init:(NSString *)url
{
    return [self init:url andParams:nil];
}

- (instancetype)init:(NSString *)url andParams:(NSArray *)params
{
    self = [super init];
    if (self) {
        _active = NO;
        [self openWithURL:url];
    }
    return self;
}

- (void)openWithURL:(NSString *)url
{
    if (_socket) {
        _socket.delegate = nil;
        [_socket close];
    }
    NSURL *target = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:target];
    _socket = [[SRWebSocket alloc] initWithURLRequest:request];
    _socket.delegate = self;
    [_socket open];
}

- (void)connect
{
    [_socket open];
}

- (void)disconnect
{
    if (_socket) {
        [_socket close];
    }
}

- (BOOL)connected
{
    return _active;
}

#pragma mark - Send

- (void)invoke:(NSString *)method withArgs:(NSDictionary *)args
{
    NSMutableDictionary *payload = [NSMutableDictionary dictionaryWithDictionary:args];
    payload[@"action2"] = method;
    NSString *text = [self encodeJSON:payload];
    if (text) {
        [_socket sendString:text error:nil];
    }
}

- (NSString *)encodeJSON:(id)object
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                  options:NSJSONWritingPrettyPrinted
                                                    error:&error];
    if (!data) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    _active = YES;
    if ([_delegate respondsToSelector:@selector(connectedEvent)]) {
        [_delegate connectedEvent];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data
                                              options:NSJSONReadingMutableContainers
                                                error:nil];
    if (![json isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(resultReceived:andParams:)]) {
        [_delegate resultReceived:json[@"action2"] andParams:(NSDictionary *)json];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    if ([_delegate respondsToSelector:@selector(disconnectedEvent)]) {
        [_delegate disconnectedEvent];
    }
    _socket = nil;
    _active = NO;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    if ([_delegate respondsToSelector:@selector(connectFailedEvent:description:)]) {
        [_delegate connectFailedEvent:(int)code description:reason];
    }
    if (code == SRStatusCodeGoingAway) {
        return;
    }
    _socket = nil;
    _active = NO;
}

@end
