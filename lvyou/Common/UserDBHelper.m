// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  UserDBHelper.m
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import "UserDBHelper.h"
#import "AppDelegate.h"

@implementation UserDBHelper
{
    FMDatabase *dataBase;    //主要用于数据库操作
    FMDatabaseQueue *dataBaseQueue;    //主要用于数据操作
}

- (id)init
{
    self = [super init];
    if(self)
    {
        NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbFilePath = [doc stringByAppendingPathComponent:@"User.sqlite"];
        dataBase = [FMDatabase databaseWithPath:dbFilePath];
        dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    }
    return self;
}

/*
 * 初始化方法
 */
+ (UserDBHelper *)userDBHelper
{
    static UserDBHelper *userDBHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        userDBHelper = [[UserDBHelper alloc] init];
    });
    return userDBHelper;
}

/**
 *  数据库升级,使用前需判断是否已升级
 */
- (void)migrateDB
{
    if ([MyAppBuilder intValue]==209)
    {
        [self executeUpdateSql:@"ALTER table message add column owner VARCHAR(20)"];
        [self executeUpdateSql:@"ALTER table grouplist add column owner VARCHAR(20)"];
        [self executeUpdateSql:@"ALTER table message add column inviteType VARCHAR(1)"];
        [self executeUpdateSql:@"ALTER table message add column roomnumber VARCHAR(20)"];
        [self executeUpdateSql:@"ALTER table message add column ticketid VARCHAR(20)"];
        [self executeUpdateSql:@"ALTER table message add column valied VARCHAR(1)"];
    }
}

/**
 *  判断是否存在表
 */
- (BOOL)isTableOK:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = '%@'", tableName];
    int count = [self getDBDataCount:sql];
    if (count > 0)
    {
        [self migrateDB];
        return YES;
    }
    return NO;
}
/**
 *  创建私信数据表
 */
- (void)foundUpMessageTable
{
    
    [self createTableSql:@"create table message (id INTEGER PRIMARY KEY,from_userid VARCHAR(20),to_userid VARCHAR(20),other_userid VARCHAR(20),owner VARCHAR(20),nickname VARCHAR(200),avatar VARCHAR(200),message VARCHAR(500),voice_time VARCHAR(15),datetime VARCHAR(50),isread VARCHAR(1),type VARCHAR(1),isBurn VARCHAR(1),picid VARCHAR(20),isJieTu VARCHAR(1),inviteType VARCHAR(1),roomnumber VARCHAR(20),ticketid VARCHAR(20),valied VARCHAR(1))"];
}

/**
 *  创建私信群聊数据表
 */
- (void)foundUpGroupMessageTable
{
    
    [self createTableSql:@"create table grouplist (id INTEGER PRIMARY KEY,from_userid VARCHAR(20),from_usernumber VARCHAR(20),nickname VARCHAR(200),avatar VARCHAR(200),message VARCHAR(500),datetime VARCHAR(50),isread VARCHAR(1),type VARCHAR(1),roomname VARCHAR(50),owner VARCHAR(20))"];
}

/**
 创建群聊数据表
 */
- (void)foundUpGroupTable
{
    [self createTableSql:@"create table grouplist (id INTEGER PRIMARY KEY,groupid VARCHAR(20),groupimg VARCHAR(200),groupname VARCHAR(200),owner VARCHAR(20))"];
}
/**
 *  创建用户数据表
 */
- (void)foundUpUserTable
{
    
    [self createTableSql:@"create table user (id INTEGER PRIMARY KEY,uid VARCHAR(200),token VARCHAR(200),avatar VARCHAR(200),birthday VARCHAR(200),gender VARCHAR(200),nickname VARCHAR(200),regtime VARCHAR(200),imuid VARCHAR(200),imsig VARCHAR(200),uniqueid VARCHAR(200),anchorrankid VARCHAR(200),balance VARCHAR(200),constellation VARCHAR(200),emotion VARCHAR(200),exp VARCHAR(200),hometowncity VARCHAR(200),hometownprovince VARCHAR(200),job VARCHAR(200),rankid VARCHAR(200),summary VARCHAR(200),ticket VARCHAR(200),totalsendgift VARCHAR(200),totalticket VARCHAR(200),viputil VARCHAR(200),haoma VARCHAR(200),livebanner VARCHAR(200),jusi_userid VARCHAR(200),jusi_token VARCHAR(200),jusi_usernumber VARCHAR(200))"];
}


/// 插入数据库
/// @param from_userid 发信息的人
/// @param to_userid 接收人
/// @param other_userid 接收人
/// @param nickname 接收人名字
/// @param voice_time 语音消息时间
/// @param msg 消息内容
/// @param type 消息类型  0：文字  1：图片 2：语音 3：礼物 4：定位 5：焚阅 6：陪伴房邀请  7:派单通知
/// @param picid 焚阅图片id
/// @param dateTime 时间
/// @param owner 消息的所有人
/// @param inviteType 0：免费1v1  1：派单
/// @param roomnumber 房间号
/// @param ticketid 陪伴房id
/// @param valied 是否允许进入  1：允许 0：不允许
- (void)insertMessage:(NSString *)from_userid toUserid:(NSString *)to_userid otherUserid:(NSString *)other_userid andNickname:(NSString *)nickname andVoice_time:(NSString *)voice_time andMsg:(NSString*)msg andType:(NSString *)type andPicid:(NSString *)picid andDateTime:(NSString *)dateTime andOwner:(NSString *)owner andInviteType:(NSString *)inviteType andRoomnumber:(NSString *)roomnumber andTicketid:(NSString *)ticketid andValied:(NSString *)valied
{
    
    NSString *sql;
//    判断如果发消息的是自己 则不插入未读消息
    if ([from_userid isEqualToString:SharedAppDelegate.userModel.user.id]) {
        if ([type integerValue] == 5) {
            sql= [NSString stringWithFormat:@"INSERT INTO message (from_userid,to_userid,other_userid, message, nickname,voice_time,datetime,isread,type,isBurn,picid,isJieTu,owner,inviteType,roomnumber,ticketid,valied) VALUES ('%@','%@','%@','%@','%@','%ld','%@','1','%@','0',%@,'0','%@','%@','%@','%@','%@')",from_userid,to_userid,other_userid,msg,nickname,[voice_time integerValue],dateTime,type,picid,owner,inviteType,roomnumber,ticketid,valied];
        } else {
            sql= [NSString stringWithFormat:@"INSERT INTO message (from_userid,to_userid,other_userid, message, nickname,voice_time,datetime,isread,type,owner,inviteType,roomnumber,ticketid,valied) VALUES ('%@','%@','%@','%@','%@','%ld','%@','1','%@','%@','%@','%@','%@','%@')",from_userid,to_userid,other_userid,msg,nickname,[voice_time integerValue],dateTime,type,owner,inviteType,roomnumber,ticketid,valied];
        }
    }
    else
    {
        if ([type integerValue] == 5) {
            sql= [NSString stringWithFormat:@"INSERT INTO message (from_userid,to_userid,other_userid, message, nickname,voice_time,datetime,isread,type,isBurn,picid,isJieTu,owner,inviteType,roomnumber,ticketid,valied) VALUES ('%@','%@','%@','%@','%@','%ld','%@','0','%@','0',%@,'0','%@','%@','%@','%@','%@')",from_userid,to_userid,other_userid,msg,nickname,[voice_time integerValue],dateTime,type,picid,owner,inviteType,roomnumber,ticketid,valied];
        } else {
            sql= [NSString stringWithFormat:@"INSERT INTO message (from_userid,to_userid,other_userid, message, nickname,voice_time,datetime,isread,type,owner,inviteType,roomnumber,ticketid,valied) VALUES ('%@','%@','%@','%@','%@','%ld','%@','0','%@','%@','%@','%@','%@','%@')",from_userid,to_userid,other_userid,msg,nickname,[voice_time integerValue],dateTime,type,owner,inviteType,roomnumber,ticketid,valied];
        }
    }
    [self executeUpdateSql:sql];
}

/**
 *  插入私信资料
 */

- (void)insertGroupMessage:(NSString *)from_userid fromUsernumber:(NSString *)from_usernumber andNickname:(NSString *)nickname andMsg:(NSString*)msg andType:(NSString *)type andRoomname:(NSString *)roomname andTime:(NSString *)time
{
    NSString *getUserSql = [NSString stringWithFormat:@"select * from grouplist where datetime='%@' and from_userid='%@' and message='%@'",time,from_userid,msg];
    NSArray *result = [self getDBlist:getUserSql];
    if (result.count ==0) {
        NSString *sql= [NSString stringWithFormat:@"INSERT INTO grouplist (from_userid,from_usernumber, message, nickname,datetime,isread,type,roomname,owner) VALUES ('%@','%@','%@','%@','%@','0','%@','%@','%@')",from_userid,from_usernumber,msg,nickname,time,type,roomname,[AppDelegate appDelegate].userModel.user.id];
        
        [self executeUpdateSql:sql];
    }
    
}

/**
 *  陪伴房更新是否失效
 */
- (void)msgListUploadInvalid:(NSString *)ticketid
{
    [self executeUpdateSql:[NSString stringWithFormat:@"update message set valied='0' where ticketid='%@'",ticketid]];
}

- (void)msgListUploadInvalid:(NSString *)ticketid andValied:(NSString *)valied andParams:(NSDictionary *)params {
    NSString *getUserSql = [NSString stringWithFormat:@"select * from message where ticketid='%@' order by datetime",ticketid];
    NSArray *result = [self getDBlist:getUserSql];
    if (result.count > 0) {
        [self executeUpdateSql:[NSString stringWithFormat:@"update message set valied='%@' where ticketid='%@'",valied,ticketid]];
    } else {
        NSDictionary *body = params[@"body"];
        NSDictionary *userinfo = params[@"userinfo"];
        NSDictionary *inviteinfo = params[@"inviteinfo"];
        NSString *dateTime = params[@"ts"];
        [self insertMessage:userinfo[@"userid"] toUserid:params[@"to"] otherUserid:params[@"to"] andNickname:userinfo[@"name"] andVoice_time:@"" andMsg:body[@"content"] andType:@"6" andPicid:@"-1" andDateTime:dateTime andOwner:[AppDelegate appDelegate].userModel.user.id andInviteType:inviteinfo[@"invite_type"] andRoomnumber:inviteinfo[@"roomnumber"] andTicketid:inviteinfo[@"ticketid"] andValied:inviteinfo[@"valied"]];
    }
    
}

/**
 插入群聊列表

 @param groupid 群聊id
 @param groupimg 群聊的图片
 @param groupname 群聊的名字
 */
- (void)insertGroup:(NSString *)groupid groupimg:(NSString *)groupimg groupname:(NSString *)groupname owner:(NSString *)owner{
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO grouplist (groupid,groupimg,groupname,owner) VALUES ('%@','%@','%@','%@')",groupid,groupimg,groupname,owner];
    [self executeUpdateSql:sql];
}

/**
 删除 圈子
 */
- (void)deleteGroupList:(NSString *)groupid {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM grouplist where groupid='%@'",groupid];
    [self executeUpdateSql:sql];
}

/**
 *  获取群聊列表
 */
- (NSArray *)groupList
{
    NSString *getUserSql = [NSString stringWithFormat:@"select * from grouplist where owner='%@'",[AppDelegate appDelegate].userModel.user.id];
    NSArray *result = [self getDBlist:getUserSql];
    
    return result;
}

/**
 *  获取groupid列表记录
 */
- (NSArray *)msgGroupListByid:(NSString *)userid
{
    NSString *getUserSql = [NSString stringWithFormat:@"select * from message where to_userid='%@' and message!='%@' order by datetime",userid,@""];
    NSArray *result = [self getDBlist:getUserSql];
    [self executeUpdateSql:[NSString stringWithFormat:@"update message set isread='1' where to_userid='%@'",userid]];
    return result;
}

/**
 *  获取群聊最后一条
 */
- (NSArray *)groupLastList
{
    NSString *getUserSql = [NSString stringWithFormat:@"select * from message WHERE to_userid LIKE 'G%%' and from_userid != '%@' and owner='%@' order by datetime DESC LIMIT 1",[AppDelegate appDelegate].userModel.user.id,[AppDelegate appDelegate].userModel.user.id];
    NSArray *result = [self getDBlist:getUserSql];
    
    return result;
}

// 更改群名称
- (void)updateGroupName:(NSString *)groupid andName:(NSString *)name{
    [self executeUpdateSql:[NSString stringWithFormat:@"update message set nickname='%@' where to_userid='%@'",name,groupid]];
    [self executeUpdateSql:[NSString stringWithFormat:@"update grouplist set groupname='%@' where groupid='%@'",name,groupid]];
}

// 更新群头像
- (void)updateGroupId:(NSString *)groupid andImg:(NSString *)img {
    [self executeUpdateSql:[NSString stringWithFormat:@"update grouplist set groupimg='%@' where groupid='%@'",img,groupid]];
}

// 退群
- (void)quiteGroup:(NSString *)groupid {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM message where to_userid='%@'",groupid];
    [self executeUpdateSql:sql];
    
    NSString *sql1 = [NSString stringWithFormat:@"DELETE FROM grouplist where groupid='%@'",groupid];
    [self executeUpdateSql:sql1];
}

/**
 *  插入用户资料
 */
- (void)insertUserProfile:(UserModel *)user
{
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO user (uid, token, avatar, birthday, gender, nickname, regtime, imuid, imsig, uniqueid, anchorrankid, balance, constellation, emotion, exp, hometowncity, hometownprovince, job, rankid, summary, ticket, totalsendgift, totalticket, viputil, haoma, livebanner,jusi_userid,jusi_usernumber,jusi_token) VALUES ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",user.user.id,user.token,user.user.avatar,user.user.birthday,user.user.gender,user.user.nickname,user.user.reg_time,user.user.im_uid,user.user.im_sig,user.user.unique_id,user.user.anchor_rank_id,user.user.balance,user.user.constellation,user.user.emotion,user.user.exp,user.user.hometown_city,user.user.hometown_province,user.user.job,user.user.rank_id,user.user.summary,user.user.ticket,user.user.total_send_gift,user.user.total_ticket,user.user.vip_util,user.user.haoma,user.user.live_banner,user.user.jusi_userid,user.user.jusi_usernumber,user.user.jusi_token];
    
    [self executeUpdateSql:sql];
}

/**
 *  更新用户资料
 */
- (void)updateUserProfile:(UserModel *)user
{
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE user set uid='%@',token='%@',avatar='%@',birthday='%@',gender='%@',nickname='%@',regtime='%@',imuid='%@',imsig='%@',uniqueid='%@',anchorrankid='%@',balance='%@',constellation='%@',emotion='%@',exp='%@',hometowncity='%@',hometownprovince='%@',job='%@',rankid='%@',summary='%@',ticket='%@',totalsendgift='%@',totalticket='%@',viputil='%@',haoma='%@',livebanner='%@',where id = 1",user.user.id,user.token,user.user.avatar,user.user.birthday,user.user.gender,user.user.nickname,user.user.reg_time,user.user.im_uid,user.user.im_sig,user.user.unique_id,user.user.anchor_rank_id,user.user.balance,user.user.constellation,user.user.emotion,user.user.exp,user.user.hometown_city,user.user.hometown_province,user.user.job,user.user.rank_id,user.user.summary,user.user.ticket,user.user.total_send_gift,user.user.total_ticket,user.user.vip_util,user.user.haoma,user.user.live_banner];
    [self executeUpdateSql:sql];
}
/*
 * 删除私信信息
 */
- (void)deleteMsg:(NSString *)userid andToUserid:(NSString *)toUserid
{
    NSString *sql;
    if ([userid isEqualToString:toUserid]) {
        sql = [NSString stringWithFormat:@"DELETE FROM message where owner='%@'",userid];
    } else {
        sql = [NSString stringWithFormat:@"DELETE FROM message where from_userid='%@' and to_userid='%@' or from_userid='%@' and to_userid='%@'",userid,toUserid,toUserid,userid];
    }
    
    [self executeUpdateSql:sql];
}
/*
 * 删除用户信息
 */
- (void)deleteDateSqlName:(NSString *)name
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@",name];
    [self executeUpdateSql:sql];
}

/**
 *  获取用户资料
 */
- (UserModel *)account
{
    NSString *getUserSql = @"select * from user where id = 1";
    NSDictionary *dicData = [self getDBOneData:getUserSql];
    
    UserModel *user = [[UserModel alloc] init];
    UserInfoModel *userinfo = [[UserInfoModel alloc] init];
    
    user.token = [dicData objectForKey:@"token"];
    user.user = userinfo;
    user.user.id = [dicData objectForKey:@"uid"];
    user.user.reg_time = [dicData objectForKey:@"regtime"];
    user.user.nickname = [dicData objectForKey:@"nickname"];
    user.user.gender = [dicData objectForKey:@"gender"];
    user.user.birthday = [dicData objectForKey:@"birthday"];
    user.user.avatar = [dicData objectForKey:@"avatar"];
    user.user.im_uid = [dicData objectForKey:@"imuid"];
    user.user.im_sig = [dicData objectForKey:@"imsig"];
    user.user.unique_id = [dicData objectForKey:@"uniqueid"];
    user.user.anchor_rank_id = [dicData objectForKey:@"anchorrankid"];
    user.user.balance = [dicData objectForKey:@"balance"];
    user.user.constellation = [dicData objectForKey:@"constellation"];
    user.user.emotion = [dicData objectForKey:@"emotion"];
    user.user.exp = [dicData objectForKey:@"exp"];
    user.user.hometown_city = [dicData objectForKey:@"hometowncity"];
    user.user.hometown_province = [dicData objectForKey:@"hometownprovince"];
    user.user.job = [dicData objectForKey:@"job"];
    user.user.rank_id = [dicData objectForKey:@"rankid"];
    user.user.summary = [dicData objectForKey:@"summary"];
    user.user.ticket = [dicData objectForKey:@"ticket"];
    user.user.total_send_gift = [dicData objectForKey:@"totalsendgift"];
    user.user.total_ticket = [dicData objectForKey:@"totalticket"];
    user.user.vip_util = [dicData objectForKey:@"viputil"];
    user.user.haoma = [dicData objectForKey:@"haoma"];
    user.user.live_banner = [dicData objectForKey:@"livebanner"];
    
    user.user.devices = nil;
    user.user.oauths = nil;
    user.user.jusi_token = [dicData objectForKey:@"jusi_token"];
    user.user.jusi_usernumber = [dicData objectForKey:@"jusi_usernumber"];
    user.user.jusi_userid = [dicData objectForKey:@"jusi_userid"];
    return user;
}

/**
 *  获取私信列表
 */
- (NSArray *)msgList
{
    NSString *getUserSql = [NSString stringWithFormat:@"select *,max(datetime) as dt from message where owner='%@' group by other_userid order by dt desc",[AppDelegate appDelegate].userModel.user.id];
    NSArray *result = [self getDBlist:getUserSql];
    
    return result;
}
/**
 *  获取userid列表
 */
- (NSArray *)msgListByid:(NSString *)userid andToUserid:(NSString *)toUserid
{
    NSString *getUserSql = [NSString stringWithFormat:@"select * from message where from_userid='%@' and to_userid='%@' or from_userid='%@' and to_userid='%@' order by datetime",userid,toUserid,toUserid,userid];
    NSArray *result = [self getDBlist:getUserSql];
    [self executeUpdateSql:[NSString stringWithFormat:@"update message set isread='1' where from_userid='%@'",userid]];
    return result;
}

/**
 *  获取未读列表
 */
- (NSArray *)msgUnreadList
{
    NSString *getUserSql = [NSString stringWithFormat:@"select count(*) as unreadnum,from_userid,other_userid from message where isread='0' and owner='%@' group by other_userid",[AppDelegate appDelegate].userModel.user.id];
    NSArray *result = [self getDBlist:getUserSql];
    
    return result;
}
/**
 *  获取未读数量
 */
- (NSString *)msgUnreadNum
{
//     获取未读消息时要把自己发的消息排除掉 <>代表不等于  from_userid<>'%@ 不等于自己
    NSString *getUserSql = [NSString stringWithFormat:@"select count(*) as unreadnum from message where isread='0' and other_userid<>'%@' and owner='%@'",SharedAppDelegate.userModel.user.id,SharedAppDelegate.userModel.user.id];
    NSDictionary *result = [self getDBOneData:getUserSql];
    NSString *num=[result objectForKey:@"unreadnum"];
    if ([num intValue]>99) {
        num=@"99+";
    }
    NSArray *aaa=[self getDBlist:@"select * from message where isread='0'"];
    return num;
}
/**
 *  创建表
 */

- (BOOL)createTableSql:(NSString *)sql
{
    __block unsigned mid = 0;
    [dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        NSLog(@"%@", sql);
        BOOL success = [db executeStatements:sql];
        if(success)
        {
            NSLog(@"sql语句执行成功 %d", success);
        }
        else
        {
            NSLog(@"sql语句执行失败 %d", success);
        }
        
        mid = success;
    }];
    return mid;
}

/**
 *  获得数据
 */
- (NSArray *)getDBlist:(NSString *)sql
{
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    NSLog(@"%@", sql);
    [dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
            
            [list addObject:dictionary];
            return 0;
        }];
    }];
    return list;
}

/**
 *  获得单条数据
 */
- (NSDictionary *)getDBOneData:(NSString *)sql
{
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    NSLog(@"%@", sql);
    [dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
            
            [list addObject:dictionary];
            return 0;
        }];
    }];
    
    if (list.count == 1)
    {
        return [list objectAtIndex:0];
    }
    return nil;
}

/**
 *  统计数量
 */
- (int)getDBDataCount:(NSString *)sql
{
    int count = 0;
    __block NSMutableArray *list = [[NSMutableArray alloc] init];
    NSLog(@"%@", sql);
    [dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeStatements:sql withResultBlock:^int(NSDictionary *dictionary) {
            
            [list addObject:dictionary];
            
            return 0;
        }];
    }];
    
    if (list.count == 1)
    {
        NSDictionary *dict = [list objectAtIndex:0];
        if (dict)
        {
            count = [[dict objectForKey:@"count"] intValue];
        }
    }
    NSLog(@"getDBDataCount count===%d", count);
    return count;
}

/*
 * 更新操作，删除操作
 */
- (void)executeUpdateSql:(NSString *)sql
{
    [dataBaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        BOOL success = [db executeStatements:sql];
        if(success)
        {
            NSLog(@"sql语句执行成功 %d", success);
        }
        else
        {
            NSLog(@"sql语句执行失败 %d", success);
        }
    }];
}

/*
 * 关闭数据库
 */
- (void)closeDatabase
{
    [dataBase close];
}

- (NSString *)selectidForListTo:(NSString *)message {
    NSString *getUserSql = [NSString stringWithFormat:@"select * from message where message='%@'",message];
    NSDictionary *result = [self getDBOneData:getUserSql];
    return result[@"id"];
}

- (void)upDataBurn:(NSString *)picid {
    [self executeUpdateSql:[NSString stringWithFormat:@"update message set isBurn='1' where (id = '%@' and picid='-1') or picid='%@'",picid,picid]];
}

- (void)upDataJieTu:(NSString *)picid {
    [self executeUpdateSql:[NSString stringWithFormat:@"update message set isJieTu='1' where (id = '%@' and picid='-1') or picid='%@'",picid,picid]];
}


-(void)truncateGroupMessage{
    NSString *sql=@"delete from grouplist";
    [self executeUpdateSql:sql];
}

/**
 *  获取群聊私信列表
 */
- (NSArray *)groupMsgList
{
    NSString *sql = [NSString stringWithFormat:@"select * from grouplist order by datetime desc"];
    NSArray *result = [self getDBlist:sql];
    
    return result;
}

@end
