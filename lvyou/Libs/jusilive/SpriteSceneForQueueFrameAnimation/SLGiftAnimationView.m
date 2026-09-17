//
//  AnimationView.m
//  AnimationFramework
//
//  Created by 金颖 on 17/7/22.
//  Copyright © 2017年 test. All rights reserved.
//

#import "SLGiftAnimationView.h"
#import "ZipArchive.h"
#import "SDWebImage.h"
#import "FlashViewNew.h"
@interface SLGiftAnimationView ()
@property(strong,nonatomic)FlashViewNew *flashView;
@end

@implementation SLGiftAnimationView

- (void)downloadAssetsWith:(NSDictionary *)info{
    _isPlaying=YES;
    NSString *url=[info objectForKey:@"url"];
    NSString *giftid=[info objectForKey:@"giftid"];
    NSString *filename=[info objectForKey:@"filename"];
    NSString *version=[info objectForKey:@"version"];
    NSString *newpwd=[info objectForKey:@"newpwd"];//8.14 添加密码
    //文件目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    //礼物ID目录
    NSString *filePath;
    NSString *zipPath;
    if ([filename isEqualToString:@"-100"]) { //8.17等于-100 取的是原来的礼物id
        filePath = [documentDirectory stringByAppendingPathComponent:giftid];
        zipPath=[documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",giftid]];
    }
    else{
        filePath = [documentDirectory stringByAppendingPathComponent:filename];
        zipPath=[documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.zip",filename]];
    }
    //配置文件地址
    NSString *configFile=[filePath stringByAppendingPathComponent:@"config.ini"];
    BOOL isDir;
    Boolean animation_dir_isexist=[fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (isDir && animation_dir_isexist) {//礼物目录存在
        //对比版本
        NSData *configData=[NSData dataWithContentsOfFile:configFile];
        NSError *err;
        //7.27
        if (configData==nil) {
            _isPlaying=NO; //2018.8.25 添加 有些座驾或者礼物删除或隐藏之后解压时会走到这里 如果不设置会导致后边的礼物走不到playnext里边
            return;
        }
        NSDictionary *configDic=[NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingMutableContainers error:&err];
        if (!err) {
            if ([[configDic objectForKey:@"version"] intValue]==[version intValue]) {
                //文件存在可以播放
                NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:configDic];
                if ([filename isEqualToString:@"-100"]) { //8.17等于-100 取的是原来的礼物id
                    [params setObject:giftid forKey:@"prefix"];
                }
                else{
                    [params setObject:filename forKey:@"prefix"];
                }
                [params setObject:filePath forKey:@"img"];
                
                //判断是帧动画，还是关键帧动画
                if ([configDic objectForKey:@"size_x"]==nil) {
                    //[scene performSelectorOnMainThread:@selector(showCPPGift:) withObject:params waitUntilDone:YES];
                    if ([configDic[@"mode"] isEqualToString:@"svga"]) {
                        [scene performSelectorOnMainThread:@selector(showSVGAParserWithUrl:) withObject:params waitUntilDone:YES]; //8.6 添加
                    } else if ([configDic[@"mode"] isEqualToString:@"mp4"]) {
                        [scene performSelectorOnMainThread:@selector(showMP4ParserWithUrl:) withObject:params waitUntilDone:YES]; //8.6 添加
                    } else{
                        [scene performSelectorOnMainThread:@selector(showCPPGift:) withObject:params waitUntilDone:YES];
                    }
                }
                else{
                    [self performSelectorOnMainThread:@selector(PlayWithNameWithConfig:) withObject:params waitUntilDone:YES];
                }
                return;
            }
        }
           [fileManager removeItemAtPath:filePath error:nil];
    }
    //下载zip
    NSData *zip_data=[NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (zip_data.length!=0) {//下载成功
        [fileManager removeItemAtPath:zipPath error:nil];
        [zip_data writeToFile:zipPath atomically:YES];
        ZipArchive *za = [[ZipArchive alloc] init];
        BOOL pwd;
        if (newpwd!=nil) {
            if ([newpwd intValue]==1) {
                pwd =[za UnzipOpenFile:zipPath Password:pwdConfig];
            }
            else{
                pwd =[za UnzipOpenFile:zipPath Password:@"9jsJmx38dhs_82jdKS"];
            }
        }
        else{
                pwd =[za UnzipOpenFile:zipPath Password:@"9jsJmx38dhs_82jdKS"];
        }
        if (pwd) {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
            BOOL ret = [za UnzipFileTo:filePath overWrite:YES];
            if (!ret) {
                [fileManager removeItemAtPath:filePath error:nil];
                [za UnzipCloseFile];
                _isPlaying=NO;
                return;//解压失败了
            }
        }
        animation_dir_isexist=[fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        if (isDir && animation_dir_isexist) {//礼物目录存在
            //对比版本
            NSData *configData=[NSData dataWithContentsOfFile:configFile];
            NSError *err;
            //7.27
            if (configData==nil) {
                _isPlaying=NO; //2018.8.25 添加 有些座驾或者礼物删除或隐藏之后解压时会走到这里 如果不设置会导致后边的礼物走不到playnext里边
                return;
            }
            NSDictionary *configDic=[NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingMutableContainers error:&err];
            if (!err) {
                if ([[configDic objectForKey:@"version"] intValue]==[version intValue]) {
                    //文件存在可以播放
                    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:configDic];
                    if ([filename isEqualToString:@"-100"]) { //8.17等于-100 取的是原来的礼物id
                        [params setObject:giftid forKey:@"prefix"];
                    }else{
                        [params setObject:filename forKey:@"prefix"];
                    }
                    [params setObject:filePath forKey:@"img"];
                    
                    //判断是帧动画，还是关键帧动画
                    if ([configDic objectForKey:@"size_x"]==nil) {
                        //[scene performSelectorOnMainThread:@selector(showCPPGift:) withObject:params waitUntilDone:YES];
                        if ([configDic[@"mode"] isEqualToString:@"svga"]) {
                            [scene performSelectorOnMainThread:@selector(showSVGAParserWithUrl:) withObject:params waitUntilDone:YES];//8.6 添加
                        } else if ([configDic[@"mode"] isEqualToString:@"mp4"]) {
                            [scene performSelectorOnMainThread:@selector(showMP4ParserWithUrl:) withObject:params waitUntilDone:YES]; //8.6 添加
                        } else {
                            [scene performSelectorOnMainThread:@selector(showCPPGift:) withObject:params waitUntilDone:YES];
                        }
                    }
                    else{
                        [self performSelectorOnMainThread:@selector(PlayWithNameWithConfig:) withObject:params waitUntilDone:YES];
                    }
                    return;
                }
            }
        }
    }
    else{//下载不成功，显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            [self createImg:info];//放在主线程执行
        });
    }
    _isPlaying=NO;
}
- (void)createImg:(NSDictionary *)info
{
    giftimgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    giftimgView.contentMode=UIViewContentModeScaleAspectFit;
    giftimgView.clipsToBounds = YES;
    if ([info objectForKey:@"img"]!=nil) {
         giftimgView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[info objectForKey:@"img"]]]];
//        [giftimgView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"icon_login_head"]];
    }
    //[giftimgView sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"img"]] placeholderImage:nil];
    [self addSubview:giftimgView];
}

//- (void)removeImageWith:(UIImageView *)image
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        //移除图片
//        [image removeFromSuperview];
//    });
//}
-(void)playstop{
    _isPlaying=NO;
    if(_isQueue){
        [self playnext];
    }
}
-(void)playstart{
    _isPlaying=YES;
}
-(void)PlayWithNameWithConfig:(NSDictionary *)config{
    
//-(instancetype) initWithFlashName:(NSString *)flashName andAnimDir:(NSString *)animDir scaleMode:(FlashViewScaleMode)scaleMode designResolution:(CGSize)resolution designScreenOrientation:(FlashViewScreenOrientation) designScreenOrientation currScreenOrientation:(FlashViewScreenOrientation) currScreenOrientation{
    NSString *name=[config objectForKey:@"prefix"];
    NSString *path=[config objectForKey:@"img"];
    //FlashViewNew *flashView = [[FlashViewNew alloc] initWithFlashName:name andAnimDir:path scaleMode:FlashViewScaleModeWidthFit designResolution:CGSizeMake(400, 400) designScreenOrientation:FlashViewScreenOrientationVer currScreenOrientation:FlashViewScreenOrientationVer];
    self.flashView = [[FlashViewNew alloc] initWithFlashName:name andAnimDir:path];
    self.flashView.frame=self.frame;
    [self.flashView setScaleMode:FlashViewScaleModeWidthFit andDesignResolution:CGSizeMake([[config objectForKey:@"size_x"] floatValue], [[config objectForKey:@"size_y"] floatValue])];
    [self addSubview:self.flashView];
    int repeat=[[config objectForKey:@"repeat"] intValue];
    if (_repeatForever) {
        repeat=FlashViewLoopTimeForever;
    }
    [self.flashView play:self.flashView.animNames[0] loopTimes:repeat];
//    __weak FlashViewNew *weakFlashView = flashView;
    NSString *audio_path=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",name]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:audio_path]) {
        [self playBackgroundMusic:audio_path repeat:[[config objectForKey:@"repeat"] intValue]];
    }
    __weak FlashViewNew *weak_self =self.flashView;
    __weak typeof(self)weakself =self;
    self.flashView.onEventBlock = ^(FlashViewEvent evt, id data){
        if (evt == FlashViewEventStop) {
            [weak_self removeFromSuperview];
            [weakself stop];
        }
    };
}
-(void)dealloc{
    NSLog(@"SLGiftAnimationView  dealloc");
    if (self.flashView) { //2018.8.16添加 释放
        [self.flashView stop];
    }
    [self stop];
}
-(void)stop{
    if(_backgroundMusicPlayer){
        [_backgroundMusicPlayer stop];
        _backgroundMusicPlayer=nil;
    }
    if (scene) {  //3.25修改
        [scene stop];
    }
    if (queue) {
        [queue removeAllObjects];
    }
    [self playstop];
}
-(void)initAniView{
    queue=[NSMutableArray array];
    self.userInteractionEnabled=NO;
    SKView *skView = [[SKView alloc] init];//5.21修改
    skView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    skView.allowsTransparency=YES;
    // Create and configure the scene. We use iPad dimensions, and crop the image on iPhone screen
    scene = [MyScene sceneWithSize:CGSizeMake(360, 640)];//9:16的全屏动画
    scene.parentView=self;
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.backgroundColor = [UIColor clearColor];
    // Present the scene.
    [skView presentScene:scene];
     skView.userInteractionEnabled=NO;
    [self addSubview:skView];
}

-(void)playBackgroundMusic:(NSString *)filename repeat:(int)repeat
{
    if (_isSwitchSoundOn==NO) {
        // 不播放声音
        return;
    }
    NSError *error;
    if (_backgroundMusicPlayer) {
        [_backgroundMusicPlayer stop];
         _backgroundMusicPlayer=nil;
    }
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filename] error:&error];// AVAudioPlayer对象要设置成全局的
    _backgroundMusicPlayer.numberOfLoops = repeat;//播放次数 0代表1次
    _backgroundMusicPlayer.volume = 0.8;//音量
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}

- (void)playgame:(NSDictionary *)dic
{
    if (_isQueue) {
        [queue addObject:dic];
        if (!_isPlaying) {
            [self playnext];
        }
    }
    else{
        [self performSelectorInBackground:@selector(downloadAssetsWith:) withObject:dic];
    }
}
-(void)playnext{
    if (self.aniPlaying==YES) {
        
    }
    else{
        [queue removeAllObjects];
    }
    if([queue count]==0){
        return;
    }
    NSDictionary *dic=[queue objectAtIndex:0];
    [self performSelectorInBackground:@selector(downloadAssetsWith:) withObject:dic];
    [queue removeObjectAtIndex:0];
}

-(void)customDrawWithImage:(NSString *)img andRoadpoints:(NSArray *)roadpoints{
    //    int num=arc4random()%10000;
    __block long count = roadpoints.count;
    __block long i=0;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    //通过start参数控制第一次执行的时间，DISPATCH_TIME_NOW表示立即执行
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1* NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (i>=count) {
            if((i-count)>=30){
                dispatch_source_cancel(timer);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSArray *imgs=self.subviews;
                    for (UIView *view in imgs) {
                        if(view.tag==1000){
                            [view removeFromSuperview];
                        }
                    }
                });
            }
        }
        else{
            dispatch_sync(dispatch_get_main_queue(), ^{
                CGPoint point=CGPointMake([roadpoints[i][0] floatValue]*SCREEN_WIDTH,[roadpoints[i][1] floatValue]*SCREEN_HEIGHT);
                UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(point.x-30*ScreenBiLi, point.y-30*ScreenBiLi, 60*ScreenBiLi, 60*ScreenBiLi)];
                imgView.contentMode=UIViewContentModeScaleAspectFit;
                imgView.clipsToBounds=YES;
                imgView.tag=1000;
                [imgView sd_setImageWithURL:[NSURL URLWithString:img]];
                [self addSubview:imgView];
                imgView.alpha=0;
                [UIView animateWithDuration:0.3 animations:^{
                    imgView.alpha=1;
                }];
            });
        }
        
        i++;
        
    });
    NSLog(@"main queue");
    dispatch_resume(timer);
}

-(void)customDrawWithRoadpoints:(NSArray *)roadpoints{
    //    int num=arc4random()%10000;
    __block long count = 0; // 一共需要画多少礼物
    __block long i=0; // 已画总数
    __block long index=0;// 画到了第几个数组
    __block long giftnum=0;// 当前数组里有多少个礼物
    __block long giftnumDraw=0;// 当前数组里已画多少个
    __block NSString *img = @""; // 当前礼物图片
    __block NSArray *pointArr = [NSArray array];
    pointArr = roadpoints[index][@"roadpoints"];
    NSMutableArray *countArr = [NSMutableArray array];
    NSMutableArray *imgsArr = [NSMutableArray array];
    for (NSDictionary *dict in roadpoints) {
        NSArray *arr = dict[@"roadpoints"];
        count += arr.count;
        [countArr addObject:[NSString stringWithFormat:@"%ld",arr.count]];
        [imgsArr addObject:dict[@"giftimg"]];
        
    }
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    //通过start参数控制第一次执行的时间，DISPATCH_TIME_NOW表示立即执行
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1* NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (i>=count) {
            if((i-count)>=30){
                dispatch_source_cancel(timer);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSArray *imgs=self.subviews;
                    for (UIView *view in imgs) {
                        if(view.tag==2000){
                            [view removeFromSuperview];
                        }
                    }
                });
            }
        }
        else{
            NSString *newImage = imgsArr[index];
            if (![newImage isEqualToString:img]) {
                img = newImage;
            }
            dispatch_sync(dispatch_get_main_queue(), ^{
                CGPoint point=CGPointMake([pointArr[giftnumDraw][0] floatValue]*SCREEN_WIDTH,[pointArr[giftnumDraw][1] floatValue]*SCREEN_HEIGHT);
                UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake(point.x-30*ScreenBiLi, point.y-30*ScreenBiLi, 60*ScreenBiLi, 60*ScreenBiLi)];
                imgView.contentMode=UIViewContentModeScaleAspectFit;
                imgView.clipsToBounds=YES;
                imgView.tag=2000;
                [imgView sd_setImageWithURL:[NSURL URLWithString:img]];
                [self addSubview:imgView];
                imgView.alpha=0;
                [UIView animateWithDuration:0.3 animations:^{
                    imgView.alpha=1;
                }];
            });
            
        }
        giftnumDraw++;
        if (index < countArr.count) {
            if (giftnumDraw >= [countArr[index] integerValue]) {
                index++;
                giftnumDraw = 0;
                if (index < roadpoints.count) {
                    pointArr = roadpoints[index][@"roadpoints"];
                }
            }
        }
        
        i++;
        
    });
    NSLog(@"main queue");
    dispatch_resume(timer);
}

@end
