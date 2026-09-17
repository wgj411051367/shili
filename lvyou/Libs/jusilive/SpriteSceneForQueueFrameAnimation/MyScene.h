//
//  MyScene.h
//  TexturePacker-SpriteKit
//
//  Created by joachim on 23.09.13.
//  Copyright (c) 2013 CodeAndWeb. All rights reserved.
//

#import "MyTextureAtlas.h"
#import <AVFoundation/AVFoundation.h>
#import "SVGA.h"


#import "LHVideoGiftAlphaVideoMetalView.h"
#import "LHVideoGiftAlphaVideoGLView.h"

@interface MyScene : SKScene<SVGAPlayerDelegate>
{
//    NSMutableDictionary *textureAtlasCache;
//    SKSpriteNode *sprite;
     NSMutableArray*animationArr;
     NSArray *dataArr;
    
}

@property (nonatomic, strong) AVPlayer *videoplayer;
@property (nonatomic, strong) AVPlayerItemVideoOutput *videoOutput;
@property (atomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGSize videoSize;

@property (nonatomic, assign) CVPixelBufferRef pixelBuffer;
@property (nonatomic, strong) LHVideoGiftAlphaVideoMetalView *mtView;
@property (nonatomic, strong) LHVideoGiftAlphaVideoGLView *glView;

@property (nonatomic, copy) NSString *mp4dir;
@property (nonatomic, copy) NSString *mp4name;

@property(nonatomic,strong)SVGAParser *parser;
@property(nonatomic,strong)SVGAPlayer *player;
//1.25 添加
@property(nonatomic,strong)MyTextureAtlas *textureAtlasUse;
@property(nonatomic,weak) id parentView;
@property(nonatomic,strong)AVAudioPlayer *backgroundMusicPlayer;
-(void)showCPPGift:(NSDictionary *)info;
- (void)showSVGAParserWithUrl:(NSDictionary *)info; //2018.8.8 添加
- (void)showMP4ParserWithUrl:(NSDictionary *)info; //2021.1.11 添加
- (void)stop;

- (void)showMP4ParserWithUrlName:(NSString *)url; //2021.1.11 添加
@end
