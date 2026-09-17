// ////////////////////////////////////////////////////////////////////////////
//
// Copyright (c)  Shili Technology Co., Ltd.
// All rights reserved.
// http://www.shili.com
//
// ///////////////////////////////////////////////////////////////////////////
//
//  UserDBHelper.h
//  beibei
//
//  Created by dev on 16/6/15.
//  Copyright © 2016年 Shili. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FMResultSet.h"
#import "Constants.h"
#import "UserModel.h"

@interface UserDBHelper : NSObject

/*
 * 初始化方法
 */
+ (UserDBHelper *)userDBHelper;

/**
 *  数据库升级,使用前需判断是否已升级
 */
- (void)migrateDB;

/*
 * 判断是否存在表
 */
- (BOOL)isTableOK:(NSString *)tableName;

/*
 * 创建表
 */
- (BOOL)createTableSql:(NSString *)sql;

/*
 * 获得数据
 */
- (NSArray *)getDBlist:(NSString *)sql;

/*
 * 获得单条数据
 */
- (NSDictionary *)getDBOneData:(NSString *)sql;

/*
 * 统计数量
 */
- (int)getDBDataCount:(NSString *)sql;

//未读私信数量
- (NSString *)msgUnreadNum;
/*
 * 更新操作，删除操作
 */
- (void)executeUpdateSql:(NSString *)sql;

/*
 * 关闭数据库
 */
- (void)closeDatabase;

/**
 *  创建用户数据表
 */
- (NSArray *)msgUnreadList;
- (NSArray *)msgList;
- (NSArray *)msgListByid:(NSString *)userid andToUserid:(NSString *)toUserid;

- (void)deleteMsg:(NSString *)userid andToUserid:(NSString *)toUserid;
- (void)foundUpUserTable;
- (void)foundUpGroupTable;
- (void)foundUpMessageTable;

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
- (void)insertMessage:(NSString *)from_userid toUserid:(NSString *)to_userid otherUserid:(NSString *)other_userid andNickname:(NSString *)nickname andVoice_time:(NSString *)voice_time andMsg:(NSString*)msg andType:(NSString *)type andPicid:(NSString *)picid andDateTime:(NSString *)dateTime andOwner:(NSString *)owner andInviteType:(NSString *)inviteType andRoomnumber:(NSString *)roomnumber andTicketid:(NSString *)ticketid andValied:(NSString *)valied;

/**
 *  陪伴房更新是否失效
 */
- (void)msgListUploadInvalid:(NSString *)ticketid;
- (void)msgListUploadInvalid:(NSString *)ticketid andValied:(NSString *)valied andParams:(NSDictionary *)params;
/**
 *  插入用户资料
 */
- (void)insertUserProfile:(UserModel *)user;

/**
 插入群聊列表

 @param groupid 群聊id
 @param groupimg 群聊的图片
 @param groupname 群聊的名字
 */
- (void)insertGroup:(NSString *)groupid groupimg:(NSString *)groupimg groupname:(NSString *)groupname owner:(NSString *)owner;

/**
 删除 圈子
 */
- (void)deleteGroupList:(NSString *)groupid;
/**
 *  获取群聊列表
 */
- (NSArray *)groupList;
/**
 *  获取groupid列表记录
 */
- (NSArray *)msgGroupListByid:(NSString *)userid;
/**
 *  获取群聊最后一条
 */
- (NSArray *)groupLastList;

- (void)updateGroupName:(NSString *)groupid andName:(NSString *)name;
- (void)updateGroupId:(NSString *)groupid andImg:(NSString *)img;

// 退群
- (void)quiteGroup:(NSString *)groupid;
/**
 *  更新用户资料
 */
- (void)updateUserProfile:(UserModel *)user;

/*
 * 删除用户信息
 */
- (void)deleteDateSqlName:(NSString *)name;

/**
 *  获取用户资料
 */
- (UserModel *)account;

- (NSString *)selectidForListTo:(NSString *)message;
- (void)upDataBurn:(NSString *)picid;
- (void)upDataJieTu:(NSString *)picid;



-(void)truncateGroupMessage;
/**
 *  获取群聊私信列表
 */
- (NSArray *)groupMsgList;
/**
 *  插入私信资料
 */

- (void)insertGroupMessage:(NSString *)from_userid fromUsernumber:(NSString *)from_usernumber andNickname:(NSString *)nickname andMsg:(NSString*)msg andType:(NSString *)type andRoomname:(NSString *)roomname andTime:(NSString *)time;

/**
 *  创建私信群聊数据表
 */
- (void)foundUpGroupMessageTable;
@end
