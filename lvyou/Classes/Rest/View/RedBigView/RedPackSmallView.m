//
//  RedPackSmallView.m
//  liveios
//
//  Created by imac on 2022/9/21.
//  Copyright © 2022 Shili. All rights reserved.
//

#import "RedPackSmallView.h"
#import "BaseViewController.h"

@implementation RedPackSmallView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)initView {
    
    if ([self.max integerValue] >= 10000) {
        NSString *maxStr = [[BaseViewController alloc] notRounding:[self.max doubleValue]/10000 afterPoint:2];
        self.title.text = [NSString stringWithFormat:@"满%@W%@即可开启",maxStr,[[BaseViewController alloc] moneyname]];
    } else {
        self.title.text = [NSString stringWithFormat:@"满%@%@即可开启",self.max,[[BaseViewController alloc] moneyname]];
    }
    
}

- (void)uploadTimeCount:(NSInteger)count {
    
    self.timeCount.text = [NSString stringWithFormat:@"(%lds后消失)",count];
}


- (void)uploadProgress:(NSString *)count max:(NSString *)max {
    self.get = count;
    self.max = max;
    self.progressView.progress = [count doubleValue] / [max doubleValue];
    if ([count integerValue] >= [max integerValue]) {
        self.progressLab.text = @"已满";
        self.timeCount.hidden = NO;
        self.guizeView.hidden = YES;
        self.openImage.image = [UIImage imageNamed:@"icon_live_red_pack_open"];
    } else {
        if ([count integerValue] > 10000) {
//            double countL = [count doubleValue] / 10000
            self.progressLab.text = [NSString stringWithFormat:@"已送%@W%@",[[BaseViewController alloc] notRounding:[count doubleValue]/10000 afterPoint:2],[[BaseViewController alloc] moneyname]];
        } else {
            self.progressLab.text = [NSString stringWithFormat:@"已送%@%@",count,[[BaseViewController alloc] moneyname]];
        }
        self.guizeView.hidden = NO;
        self.timeCount.hidden = YES;
        self.openImage.image = [UIImage imageNamed:@"icon_live_red_pack_open_un"];
    }
}


- (IBAction)openBtnAction:(id)sender {
    
    if (self.clickMoreRedPcak) {
        self.clickMoreRedPcak([self.get integerValue] >= [self.max integerValue]);
    }
}

@end
