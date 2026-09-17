//
//  TotalPeopleView.m
//  wenxin
//
//  Created by dev on 2019/4/26.
//  Copyright © 2019 Shili. All rights reserved.
//

#import "TotalPeopleView.h"
#import "TotalPeopleTableViewCell.h"
#import "NobleModel.h"
#import "BaseViewController.h"
#import "RankPeopleModel.h"

@interface TotalPeopleView ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger audPage;
    NSInteger guardPage;
    NSInteger guibinPage;
//    NSInteger fansPage;
    
}
@end


@implementation TotalPeopleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initView {
    self.popView.transform = CGAffineTransformMakeTranslation(0, 482);
}

- (IBAction)chooseBtnAction:(UIButton *)sender {
    switch (sender.tag) {
        case 200:
        {
            self.shouhuLab.textColor = [UIColor colorWithHex:0x333333];
            self.shouhuLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            self.shouhuLine.hidden = NO;
            
            
            self.guizuLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.guizuLab.font = [UIFont systemFontOfSize:13];
            self.guizuLine.hidden = YES;
            
            
            self.guanzhongLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.guanzhongLab.font = [UIFont systemFontOfSize:13];
            self.guanzhongLine.hidden = YES;
            
//            self.fansTeamLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
//            self.fansTeamLab.font = [UIFont systemFontOfSize:13];
//            self.fansTeamLine.hidden = YES;
            
            self.shouhuTableView.hidden = NO;
            self.guizuTableView.hidden = YES;
            self.guanzhongTableView.hidden = YES;
//            self.fansTeamTableView.hidden = YES;
            
            if (!_isHost) {
                self.shBtn.hidden = NO;
                self.gzBtn.hidden = YES;
            }
            
        }
            break;
        case 201:
        {
            self.guizuLab.textColor = [UIColor colorWithHex:0x333333];
            self.guizuLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            self.guizuLine.hidden = NO;
            
            self.shouhuLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.shouhuLab.font = [UIFont systemFontOfSize:13];
            self.shouhuLine.hidden = YES;
            
            self.guanzhongLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.guanzhongLab.font = [UIFont systemFontOfSize:13];
            self.guanzhongLine.hidden = YES;
            
//            self.fansTeamLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
//            self.fansTeamLab.font = [UIFont systemFontOfSize:13];
//            self.fansTeamLine.hidden = YES;
            
            self.shouhuTableView.hidden = YES;
            self.guizuTableView.hidden = NO;
            self.guanzhongTableView.hidden = YES;
//            self.fansTeamTableView.hidden = YES;
            
            if (!_isHost) {
                self.shBtn.hidden = YES;
                self.gzBtn.hidden = NO;
            }
            
        }
            break;
        case 202:
        {
            self.guanzhongLab.textColor = [UIColor colorWithHex:0x333333];
            self.guanzhongLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            self.guanzhongLine.hidden = NO;
            
            self.guizuLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.guizuLab.font = [UIFont systemFontOfSize:13];
            self.guizuLine.hidden = YES;
            self.gzBtn.hidden = YES;
            
            self.shouhuLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.shouhuLab.font = [UIFont systemFontOfSize:13];
            self.shouhuLine.hidden = YES;
            self.shBtn.hidden = YES;
            
//            self.fansTeamLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
//            self.fansTeamLab.font = [UIFont systemFontOfSize:13];
//            self.fansTeamLine.hidden = YES;
            
            self.shouhuTableView.hidden = YES;
            self.guizuTableView.hidden = YES;
            self.guanzhongTableView.hidden = NO;
//            self.fansTeamTableView.hidden = YES;
            
            if (!_isHost) {
                self.shBtn.hidden = YES;
                self.gzBtn.hidden = YES;
            }
            
        }
            break;
        case 203:
        {
            
//            self.fansTeamLab.textColor = [UIColor colorWithHex:0x333333];
//            self.fansTeamLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
//            self.fansTeamLine.hidden = NO;
            
            self.guanzhongLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.guanzhongLab.font = [UIFont systemFontOfSize:13];
            self.guanzhongLine.hidden = YES;
            
            self.guizuLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.guizuLab.font = [UIFont systemFontOfSize:13];
            self.guizuLine.hidden = YES;
            self.gzBtn.hidden = YES;
            
            self.shouhuLab.textColor = [UIColor colorWithHex:0x333333 alpha:0.8];
            self.shouhuLab.font = [UIFont systemFontOfSize:13];
            self.shouhuLine.hidden = YES;
            self.shBtn.hidden = YES;
            

            self.shouhuTableView.hidden = YES;
            self.guizuTableView.hidden = YES;
            self.guanzhongTableView.hidden = YES;
//            self.fansTeamTableView.hidden = NO;
            
            if (!_isHost) {
                self.shBtn.hidden = YES;
                self.gzBtn.hidden = YES;
            }
            
        }
            break;
        default:
            break;
    }
    
    if (_isHost) {
        self.shBtn.hidden = YES;
        self.gzBtn.hidden = YES;
        self.buyShouHuBtnHeight.constant = 0;
        self.buyGuizuBtnHeight.constant = 0;
    }
}

- (void)showView:(UIButton *)sender {
    [self chooseBtnAction:sender];
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
//        self.bgView.alpha = 1;
        self.popView.transform = CGAffineTransformIdentity;
    }];
    
//    [self getFansDataURL];
    [self getUserListDataURL:@"&guard=1" andUserList:UserListGuardURL];
    [self getUserListDataURL:@"&guibin=1" andUserList:UserListGuiBinURL];
    [self getUserListDataURL:@"" andUserList:UserListNormalURL];
}

- (void)setFansTeamArr:(NSMutableArray *)fansTeamArr {
//    [self getFansDataURL];
}

- (void)setShouhuArr:(NSMutableArray *)shouhuArr {
    [self getUserListDataURL:@"&guard=1" andUserList:UserListGuardURL];
}

- (void)setGuizuArr:(NSMutableArray *)guizuArr {
    [self getUserListDataURL:@"&guibin=1" andUserList:UserListGuiBinURL];
}

- (void)setGuanzhongArr:(NSMutableArray *)guanzhongArr {
    [self getUserListDataURL:@"" andUserList:UserListNormalURL];
}

- (void)dismissView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(totalPeopleViewDismiss)]) {
        [self.delegate totalPeopleViewDismiss];
    }
    [UIView animateWithDuration:0.3 animations:^{
//        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 482);
        self.popView.transform = CGAffineTransformMakeTranslation(0, 482);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


// 背景点击事件
- (IBAction)cancelBtnAction:(id)sender {
    [self dismissView];
}

#pragma mark - 上拉和下拉刷新
#pragma mark-自定义刷新方法
- (void)setupRefresh
{
    
    if (@available(iOS 11.0, *)){
        self.shouhuTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.guizuTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.guanzhongTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.fansTeamTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    __weak typeof(self) weakself = self;
    MJRefreshNormalHeader *headerGuard = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求数据
        [weakself getUserListDataURL:@"&guard=1" andUserList:UserListGuardURL];
    }];
    self.shouhuTableView.mj_header = headerGuard;
    self.shouhuTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉加载执行方法
        [weakself getMoreUserListDataURL:@"&guard=1" andUserList:UserListGuardURL];
    }];
    
    MJRefreshNormalHeader *headerGuibin = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求数据
        [weakself getUserListDataURL:@"&guibin=1" andUserList:UserListGuiBinURL];
    }];
    self.guizuTableView.mj_header = headerGuibin;
    self.guizuTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉加载执行方法
        [weakself getMoreUserListDataURL:@"&guibin=1" andUserList:UserListGuiBinURL];
    }];
    
    MJRefreshNormalHeader *headerAud = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //请求数据
        [weakself getUserListDataURL:@"" andUserList:UserListNormalURL];
    }];
    self.guanzhongTableView.mj_header = headerAud;
    self.guanzhongTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //上拉加载执行方法
        [weakself getMoreUserListDataURL:@"" andUserList:UserListNormalURL];
    }];
    
//    MJRefreshNormalHeader *headerFans = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        //请求数据
//        [weakself getFansDataURL];
//    }];
//    self.fansTeamTableView.mj_header = headerFans;
//    self.fansTeamTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        //上拉加载执行方法
//        [weakself getMoreFansDataURL];
//    }];
    
    
}

- (void)getUserListDataURL:(NSString *)url andUserList:(UserListURL)type {
    if (type == UserListNormalURL) {
        audPage = 1;
        if (!_guanzhongArr) {
            _guanzhongArr = [[NSMutableArray alloc] init];
        }
    } else if (type == UserListGuiBinURL) {
        guibinPage = 1;
        if (!_guizuArr) {
            _guizuArr = [[NSMutableArray alloc] init];
        }
    } else if (type == UserListGuardURL) {
        if (!_shouhuArr) {
            _shouhuArr = [[NSMutableArray alloc] init];
        }
        guardPage = 1;
    }
    
    [[RootHttpHelper httpHelper] basicGETURL2:[NSString stringWithFormat:@"%@/iumobile/apis/index.php?action=getuserlist%@&roomnumber=%@&pagesize=20&page=1",DATAAPI,url,self.roomnumber] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"code"] integerValue];
        if(code == 200)
        {
            if (type == UserListGuardURL) {
                [_shouhuArr removeAllObjects];
                for (NSDictionary *info in [successData objectForKey:@"user"]){
                    UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                    infoModel.id=[info objectForKey:@"userid"];
                    /// 2.14  用户的头像
                    if (![info.allKeys containsObject:@"avatar"]) {
                        infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[info objectForKey:@"update_avatar_time"]];
                    } else {
                        infoModel.avatar = info[@"avatar"];
                    }
                    
                    infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                    infoModel.nickname=[info objectForKey:@"nickname"];
                    infoModel.total_ticket=[info objectForKey:@"totalpoint"];
                    infoModel.total_send_gift=[info objectForKey:@"totalcost"];
                    infoModel.hometown_city=[info objectForKey:@"city"];
                    infoModel.gender=[info objectForKey:@"gender"];
                    infoModel.haoma=[info objectForKey:@"usernumber"];
                    infoModel.fans_num=@"0";
                    infoModel.follow_num=@"0";
                    infoModel.rank_id=[info objectForKey:@"richlevel"];
                    infoModel.is_follow=@"0";
                    infoModel.yinshen=[info objectForKey:@"yinshen"];
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
                    infoModel.vip_util=[NSString stringWithFormat:@"%f",[[info objectForKey:@"viplevel"] intValue]*(now+10.0)];
                    //守护天数
                    infoModel.guard_time=[info objectForKey:@"guard_time"];
                    [_shouhuArr addObject:infoModel];
                    
                }
                guardPage++;
                self.shouhuLab.text = [NSString stringWithFormat:@"粉丝团(%@)",successData[@"guard_num"]];
                [self.shouhuTableView reloadData];
                [self.shouhuTableView.mj_footer resetNoMoreData];
                [self.shouhuTableView.mj_header endRefreshing];
                [self.shBtn setTitle:@"开通粉丝团" forState:UIControlStateNormal];
                if (successData[@"guard_num"]) {
                    [self.shBtn setTitle:@"粉丝团续费" forState:UIControlStateNormal];
                }
//                for (UserInfoModel *model in _shouhuArr) {
//                    if ([model.id isEqualToString:SharedAppDelegate.userModel.user.id]) {
//                        [self.shBtn setTitle:@"粉丝团续费" forState:UIControlStateNormal];
//                        break;
//                    }
//                }
            }else if (type == UserListGuiBinURL) {
                [_guizuArr removeAllObjects];
                for (NSDictionary *info in [successData objectForKey:@"user"]){
                    NobleModel * infoModel = [[NobleModel alloc] init];
                    infoModel.userid=[info objectForKey:@"userid"];
                    infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                    infoModel.nickname=[info objectForKey:@"nickname"];
                    infoModel.anum=[info objectForKey:@"anum"];
                    infoModel.clantype=[info objectForKey:@"clantype"];
                    infoModel.guizhu=[info objectForKey:@"guizhu"];
                    infoModel.medalname=[info objectForKey:@"medalname"];
                    infoModel.medalvalid=[info objectForKey:@"medalvalid"];
                    infoModel.richlevel=[info objectForKey:@"richlevel"];
                    infoModel.tietiao=[info objectForKey:@"tietiao"];
                    infoModel.totalcost=[info objectForKey:@"totalcost"];
                    infoModel.usernumber=[info objectForKey:@"usernumber"];
                    infoModel.usertype=[info objectForKey:@"usertype"];
                    infoModel.viplevel=[info objectForKey:@"viplevel"];
                    [_guizuArr addObject:infoModel];
                }
                guibinPage++;
                _guizuLab.text = [NSString stringWithFormat:@"贵族(%@)",successData[@"guizhu_num"]];
                [self.guizuTableView reloadData];
                [self.guizuTableView.mj_footer resetNoMoreData];
                [self.guizuTableView.mj_header endRefreshing];
                [self.gzBtn setTitle:@"开通贵族" forState:UIControlStateNormal];
                if ([SharedAppDelegate.userModel.user.guizhu integerValue] > 0) {
                    [self.gzBtn setTitle:@"贵族续费" forState:UIControlStateNormal];
                }
            }else if (type == UserListNormalURL) {
                [_guanzhongArr removeAllObjects];
                for (NSDictionary *info in [successData objectForKey:@"user"]){
                    UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                    infoModel.id=[info objectForKey:@"userid"];
                    /// 2.14  用户的头像
                    infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[info objectForKey:@"update_avatar_time"]];
                    infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                    infoModel.nickname=[info objectForKey:@"nickname"];
                    infoModel.total_ticket=[info objectForKey:@"totalpoint"];
                    infoModel.total_send_gift=[info objectForKey:@"totalcost"];
                    infoModel.hometown_city=[info objectForKey:@"city"];
                    infoModel.gender=[info objectForKey:@"gender"];
                    infoModel.haoma=[info objectForKey:@"usernumber"];
                    infoModel.fans_num=@"0";
                    infoModel.follow_num=@"0";
                    infoModel.rank_id=[info objectForKey:@"richlevel"];
                    infoModel.is_follow=@"0";
                    infoModel.guizhu=[info objectForKey:@"guizhu"];
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
                    infoModel.vip_util=[NSString stringWithFormat:@"%f",[[info objectForKey:@"viplevel"] intValue]*(now+10.0)];
                    [_guanzhongArr addObject:infoModel];
                }
                audPage++;
                _guanzhongLab.text = [NSString stringWithFormat:@"观众(%@)",successData[@"num"]];
                [self.guanzhongTableView reloadData];
                [self.guanzhongTableView.mj_footer resetNoMoreData];
                [self.guanzhongTableView.mj_header endRefreshing];
            }
            
        }
        
    }];
}

- (void)getMoreUserListDataURL:(NSString *)url andUserList:(UserListURL)type {
    NSInteger page = 0;
    if (type == UserListNormalURL) {
        page = audPage;
    } else if (type == UserListGuiBinURL) {
        page = guibinPage;
    } else if (type == UserListGuardURL) {
        page = guardPage;
    }
    
    [[RootHttpHelper httpHelper] basicGETURL2:[NSString stringWithFormat:@"%@/iumobile/apis/index.php?action=getuserlist%@&roomnumber=%@&pagesize=20&page=%ld",DATAAPI,url,self.roomnumber,(long)page] andController:nil andView:nil andParams:nil andSuccess:^(NSDictionary *successData) {
        NSInteger code = [[successData objectForKey:@"code"] integerValue];
        if(code == 200)
        {
            NSArray *temp = [successData objectForKey:@"user"];
            if (type == UserListGuardURL) {
                for (NSDictionary *info in temp){
                    UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                    infoModel.id=[info objectForKey:@"userid"];
                    /// 2.14  用户的头像
                    if (![info.allKeys containsObject:@"avatar"]) {
                        infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[info objectForKey:@"update_avatar_time"]];
                    } else {
                        infoModel.avatar = info[@"avatar"];
                    }
                    infoModel.yinshen=[info objectForKey:@"yinshen"];
                    infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                    infoModel.nickname=[info objectForKey:@"nickname"];
                    infoModel.total_ticket=[info objectForKey:@"totalpoint"];
                    infoModel.total_send_gift=[info objectForKey:@"totalcost"];
                    infoModel.hometown_city=[info objectForKey:@"city"];
                    infoModel.gender=[info objectForKey:@"gender"];
                    infoModel.haoma=[info objectForKey:@"usernumber"];
                    infoModel.fans_num=@"0";
                    infoModel.follow_num=@"0";
                    infoModel.rank_id=[info objectForKey:@"richlevel"];
                    infoModel.is_follow=@"0";
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
                    infoModel.vip_util=[NSString stringWithFormat:@"%f",[[info objectForKey:@"viplevel"] intValue]*(now+10.0)];
                    //粉丝团天数
                    infoModel.guard_time=[info objectForKey:@"guard_time"];
                    [_shouhuArr addObject:infoModel];
                }
                guardPage++;
//                self.shouhuLab.text = [NSString stringWithFormat:@"守护(%lu)",(unsigned long)self.shouhuArr.count];
                self.shouhuLab.text = [NSString stringWithFormat:@"粉丝团(%@)",successData[@"guard_num"]];
                [self.shouhuTableView reloadData];
                if (temp.count < 20) {
                    [self.shouhuTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.shouhuTableView.mj_footer endRefreshing];
                }
                [self.shBtn setTitle:@"开通粉丝团" forState:UIControlStateNormal];
                for (UserInfoModel *model in _shouhuArr) {
                    if ([model.id isEqualToString:SharedAppDelegate.userModel.user.id]) {
                        [self.shBtn setTitle:@"粉丝团续费" forState:UIControlStateNormal];
                        break;
                    }
                }
            }else if (type == UserListGuiBinURL) {
                for (NSDictionary *info in [successData objectForKey:@"user"]){
                    NobleModel * infoModel = [[NobleModel alloc] init];
                    infoModel.userid=[info objectForKey:@"userid"];
                    infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                    infoModel.nickname=[info objectForKey:@"nickname"];
                    infoModel.anum=[info objectForKey:@"anum"];
                    infoModel.clantype=[info objectForKey:@"clantype"];
                    infoModel.guizhu=[info objectForKey:@"guizhu"];
                    infoModel.medalname=[info objectForKey:@"medalname"];
                    infoModel.medalvalid=[info objectForKey:@"medalvalid"];
                    infoModel.richlevel=[info objectForKey:@"richlevel"];
                    infoModel.tietiao=[info objectForKey:@"tietiao"];
                    infoModel.totalcost=[info objectForKey:@"totalcost"];
                    infoModel.usernumber=[info objectForKey:@"usernumber"];
                    infoModel.usertype=[info objectForKey:@"usertype"];
                    infoModel.viplevel=[info objectForKey:@"viplevel"];
                    [_guizuArr addObject:infoModel];
                }
                guibinPage++;
//                _guizuLab.text = [NSString stringWithFormat:@"贵族(%lu)",(unsigned long)_guizuArr.count];
                _guizuLab.text = [NSString stringWithFormat:@"贵族(%@)",successData[@"guizhu_num"]];
                [self.guizuTableView reloadData];
                if (temp.count < 20) {
                    [self.guizuTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.guizuTableView.mj_footer endRefreshing];
                }
                [self.gzBtn setTitle:@"开通贵族" forState:UIControlStateNormal];
                for (NobleModel *model in _guizuArr) {
                    if ([model.userid isEqualToString:SharedAppDelegate.userModel.user.id]) {
                        [self.gzBtn setTitle:@"贵族续费" forState:UIControlStateNormal];
                        break;
                    }
                }
            }else if (type == UserListNormalURL) {
                for (NSDictionary *info in [successData objectForKey:@"user"]){
                    UserInfoModel * infoModel = [[UserInfoModel alloc] init];
                    infoModel.id=[info objectForKey:@"userid"];
                    /// 2.14  用户的头像
                    infoModel.avatar=[[ToolHelper toolHelper] realAvatarUrl:infoModel.id andUpdate:[info objectForKey:@"update_avatar_time"]];
                    infoModel.update_avatar_time=[info objectForKey:@"update_avatar_time"];
                    infoModel.nickname=[info objectForKey:@"nickname"];
                    infoModel.total_ticket=[info objectForKey:@"totalpoint"];
                    infoModel.total_send_gift=[info objectForKey:@"totalcost"];
                    infoModel.hometown_city=[info objectForKey:@"city"];
                    infoModel.gender=[info objectForKey:@"gender"];
                    infoModel.haoma=[info objectForKey:@"usernumber"];
                    infoModel.fans_num=@"0";
                    infoModel.follow_num=@"0";
                    infoModel.rank_id=[info objectForKey:@"richlevel"];
                    infoModel.is_follow=@"0";
                    infoModel.guizhu=[info objectForKey:@"guizhu"];
                    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval now=[dat timeIntervalSince1970] / 1000;
                    infoModel.vip_util=[NSString stringWithFormat:@"%f",[[info objectForKey:@"viplevel"] intValue]*(now+10.0)];
                    [_guanzhongArr addObject:infoModel];
                }
                audPage++;
                _guanzhongLab.text = [NSString stringWithFormat:@"观众(%@)",successData[@"num"]];
                [self.guanzhongTableView reloadData];
                if (temp.count < 20) {
                    [self.guanzhongTableView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self.guanzhongTableView.mj_footer endRefreshing];
                }
            }
            
        }
        
    }];
}

//- (void)getFansDataURL {
//    if (!_fansTeamArr) {
//        _fansTeamArr = [NSMutableArray array];
//    }
//    fansPage = 0;
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];\
//    [params setObject:SharedAppDelegate.userModel.token forKey:@"token"];
//    if (!self.roomnumber) {
//        [params setObject:SharedAppDelegate.userModel.user.haoma forKey:@"roomnumber"];
//    } else {
//        [params setObject:self.roomnumber forKey:@"roomnumber"];
//    }
//    [params setValue:@"20" forKey:@"num"];
//    [params setValue:[NSString stringWithFormat:@"%ld",(long)fansPage] forKey:@"page"];
//    //获取直播间内成员列表
//    [[RootHttpHelper httpHelper] achieveCommonGetURL:fan_list andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
//        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
//        if(code == 200)
//        {
//            [_fansTeamArr removeAllObjects];
//            NSArray *temp = [successData objectForKey:@"data"];
//            for (NSDictionary *dict in temp) {
//                UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dict error:nil];
//                [_fansTeamArr addObject:model];
//            }
//            fansPage++;
//            self.fansTeamLab.text = [NSString stringWithFormat:@"守护(%lu)",(unsigned long)_fansTeamArr.count];
//            [self.fansTeamTableView reloadData];
//            [self.fansTeamTableView.mj_footer resetNoMoreData];
//            [self.fansTeamTableView.mj_header endRefreshing];
//
//        }
//    }];
//}
//
//- (void)getMoreFansDataURL {
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];\
//    [params setObject:SharedAppDelegate.userModel.token forKey:@"token"];
//    if (!self.roomnumber) {
//        [params setObject:SharedAppDelegate.userModel.user.haoma forKey:@"roomnumber"];
//    } else {
//        [params setObject:self.roomnumber forKey:@"roomnumber"];
//    }
//    [params setValue:@"20" forKey:@"num"];
//    [params setValue:[NSString stringWithFormat:@"%ld",(long)fansPage] forKey:@"page"];
//    //获取直播间内成员列表
//    [[RootHttpHelper httpHelper] achieveCommonGetURL:fan_list andController:nil andView:nil andParams:params andSuccess:^(NSDictionary *successData) {
//        NSInteger code = [[successData objectForKey:@"api_code"] integerValue];
//        if(code == 200)
//        {
//            [_fansTeamArr removeAllObjects];
//            NSArray *temp = [successData objectForKey:@"data"];
//            for (NSDictionary *dict in temp) {
//                UserInfoModel *model = [[UserInfoModel alloc] initWithDictionary:dict error:nil];
//                [_fansTeamArr addObject:model];
//            }
//            fansPage++;
//            self.fansTeamLab.text = [NSString stringWithFormat:@"守护(%lu)",(unsigned long)_fansTeamArr.count];
//            [self.fansTeamTableView reloadData];
//            if (temp.count < 20) {
//                [self.fansTeamTableView.mj_footer endRefreshingWithNoMoreData];
//            } else {
//                [self.fansTeamTableView.mj_footer endRefreshing];
//            }
//
//        }
//    }];
//}

#pragma mark - TableView的代理方法
#pragma mark - 分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10) {
        return self.shouhuArr.count;
    } else if (tableView.tag == 11) {
        return self.guizuArr.count;
    } else if (tableView.tag == 12) {
        return self.guanzhongArr.count;
    } else {
//        return self.fansTeamArr.count;
        return 0;
    }
}

#pragma mark - 每个Cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0;
}

#pragma mark - 初始化Cell
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TotalPeopleTableViewCell * rCell = [TotalPeopleTableViewCell cellWithTableView:tableView];
    
    [self configThemeCell:rCell atIndexPath:indexPath type:tableView.tag];
    
    return rCell;
}


#pragma mark - Cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 11) {
        NobleModel *model = self.guizuArr[indexPath.row];
        if ([self.delegate respondsToSelector:@selector(touchUserAvatar:)])
        {
            [self.delegate touchUserAvatar:model.userid];
            [self dismissView];
        }
    } else {
        UserInfoModel *model;
        if (tableView.tag == 10) {
            model = self.shouhuArr[indexPath.row];
        } else if (tableView.tag == 12){
            model = self.guanzhongArr[indexPath.row];
        } else {
//            model = self.fansTeamArr[indexPath.row];
        }
        if (![model.yinshen boolValue]) {
            if ([self.delegate respondsToSelector:@selector(touchUserAvatar:)])
            {
                [self.delegate touchUserAvatar:model.id];
                [self dismissView];
            }
        }
    }
}

#pragma mark - 设置Cell内容
-(void)configThemeCell:(TotalPeopleTableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath type:(NSInteger)type
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    if(type == 11) {
        NobleModel *model = self.guizuArr[indexPath.row];
        cell.nickName.text = model.nickname;
        [cell.avatarImg sd_setImageWithURL:[[[BaseViewController alloc] init] placeCorpsImg:[[ToolHelper toolHelper] realAvatarUrl:model.userid andUpdate:model.update_avatar_time]]];
        NSString *usernumber_name=[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"];
        if (![[[BaseViewController alloc] init] isBlankString:usernumber_name]) {
            if([model.usernumber isEqualToString:@"0"]){
                cell.userId.text = [NSString stringWithFormat:@"直播号 %@",model.usernumber];
            }else{
                cell.userId.text = [NSString stringWithFormat:@"%@ %@",usernumber_name,model.usernumber];
            }
        } else if ([usernumber_name isEqualToString:@""] && ![usernumber_name isKindOfClass:[NSNull class]]) {
            cell.userId.text = [NSString stringWithFormat:@"ID %@",model.usernumber];
        }
        [self showThelevel:model.richlevel and:cell.levelImg and:cell.levelNum];
        [self showTheGuiZu:cell.vipImg With:model.guizhu];//11.6贵族
        cell.vipImg.hidden = NO;
    } else {
        UserInfoModel *model;
        
        
        if (type == 10) {
            model = self.shouhuArr[indexPath.row];
            [cell.vipImg setImage:[UIImage imageNamed:@"icon_live_shouhu"]];
            cell.vipImg.hidden = NO;
        } else if (type == 12){
            model = self.guanzhongArr[indexPath.row];
            cell.vipImg.hidden = YES;
        } else {
//            model = self.fansTeamArr[indexPath.row];
            [self showTheGuiZu:cell.vipImg With:model.guizhu];//11.6贵族
        }
        if (type == 10) {
            cell.userId.text = [NSString stringWithFormat:@"有效期：%@",model.guard_time];
        } else {
            NSString *usernumber_name=[[NSUserDefaults standardUserDefaults]objectForKey:@"usernumber_name"];
            if (![[[BaseViewController alloc] init] isBlankString:usernumber_name]) {
                if([model.haoma isEqualToString:@"0"]){
                    cell.userId.text = [NSString stringWithFormat:@"直播号 %@",model.haoma];
                }else{
                    cell.userId.text = [NSString stringWithFormat:@"%@ %@",usernumber_name,model.haoma];
                }
            } else if ([usernumber_name isEqualToString:@""] && ![usernumber_name isKindOfClass:[NSNull class]]) {
                cell.userId.text = [NSString stringWithFormat:@"ID %@",model.haoma];
            }
        }
        
        
        [self showThelevel:model.rank_id and:cell.levelImg and:cell.levelNum];
        cell.nickName.text = model.nickname;
        [cell.avatarImg sd_setImageWithURL:[[BaseViewController alloc] placeImg:model.avatar]];
        
        if ([model.yinshen boolValue] ) {
            cell.userId.hidden = YES;
            cell.levelImg.hidden = YES;
        } else {
            cell.userId.hidden = NO;
        }
        
    }
}

//显示贵族
- (void)showTheGuiZu:(UIImageView *)imgView With:(NSString *)guizu
{
    if (![self isBlankString:guizu]) {
        int i = [guizu intValue];
        if (i > 0 && i < 7) {
            imgView.hidden = NO;
            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gui%d",i]];
        } else {
            imgView.hidden = YES;
        }
    } else {
        imgView.hidden = YES;
    }
}

- (BOOL)isBlankString:(NSString *)string
{
    if (!string) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}

//显示等级部分
- (void)showThelevel:(NSString *)randid and:(UIImageView *)levelimg and:(UILabel *)levelLab
{
    NSString *realLevel=randid;
    if ([randid containsString:@"_"]) {
        NSArray *tempArr=[randid componentsSeparatedByString:@"_"];
        if (tempArr.count>0) {
            realLevel=tempArr[0];
        }
    }
    RankPeopleModel *rankModel = [[RankPeopleModel alloc] initWithDictionary:[SharedAppDelegate.rankDic objectForKey:realLevel] error:nil];
                [levelimg sd_setImageWithURL:[[[BaseViewController alloc] init] placeCorpsImg:rankModel.img] placeholderImage:nil];
            levelLab.text = realLevel;

    levelLab.hidden=YES;
}
- (IBAction)shouhuBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(totalPeopleViewBuyShouHu)])
    {
        [self.delegate totalPeopleViewBuyShouHu];
        [self dismissView];
    }
    
//    if (self.guizuBtnClick) {
//        self.guizuBtnClick();
//    }
}

- (IBAction)guizuBtnAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(totalPeopleViewBuyGuiZu)])
    {
        [self.delegate totalPeopleViewBuyGuiZu];
        [self dismissView];
    }
    
//    if (self.shouhuBtnClick) {
//        self.shouhuBtnClick();
//    }
}

@end
