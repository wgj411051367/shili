//
//  OpenShouHuView.m
//  liveios
//
//  Created by dev on 2019/5/8.
//  Copyright © 2019 Shili. All rights reserved.
//

#import "OpenShouHuView.h"
#import "shouHuModel.h"
#import "BaseViewController.h"

@interface OpenShouHuView()
{
    NSString *type;
}

@end

@implementation OpenShouHuView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)initArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    if (!_dayLabArr) {
        _dayLabArr = [NSMutableArray array];
    }
    if (!_moneyLabArr) {
        _moneyLabArr = [NSMutableArray array];
    }
    if (!_givingArr) {
        _givingArr = [NSMutableArray array];
    }
    
    [_btnArr addObject:_shouHuBtn1];
    [_btnArr addObject:_shouHuBtn2];
    [_btnArr addObject:_shouHuBtn3];
    [_btnArr addObject:_shouHuBtn4];
    
    [_dayLabArr addObject:_shouHuDayLab1];
    [_dayLabArr addObject:_shouHuDayLab2];
    [_dayLabArr addObject:_shouHuDayLab3];
    [_dayLabArr addObject:_shouHuDayLab4];
    
    _shouHuDayLab1.attributedText = [self avDayRichText:_shouHuDayLab1.text andColor:[UIColor colorWithHex:0x6580FE]];
    _shouHuDayLab2.attributedText = [self avDayRichText:_shouHuDayLab2.text andColor:[UIColor colorWithHex:0x656565]];
    _shouHuDayLab3.attributedText = [self avDayRichText:_shouHuDayLab3.text andColor:[UIColor colorWithHex:0x656565]];
    _shouHuDayLab4.attributedText = [self avDayRichText:_shouHuDayLab4.text andColor:[UIColor colorWithHex:0x656565]];
    
    [_moneyLabArr addObject:_shouHuMoneyLab1];
    [_moneyLabArr addObject:_shouHuMoneyLab2];
    [_moneyLabArr addObject:_shouHuMoneyLab3];
    [_moneyLabArr addObject:_shouHuMoneyLab4];
    
    [_givingArr addObject:_shouHuGivingLab1];
    [_givingArr addObject:_shouHuGivingLab2];
    [_givingArr addObject:_shouHuGivingLab3];
    [_givingArr addObject:_shouHuGivingLab4];
}

- (void)setShouHuArr:(NSArray *)shouHuArr {
    _shouHuArr = shouHuArr;
    for (int i = 0; i < shouHuArr.count; i++) {
        shouHuModel *model = shouHuArr[i];
        UILabel *dayLab = _dayLabArr[i];
        UILabel *moneyLab = _moneyLabArr[i];
        UILabel *givingLab = _givingArr[i];
        
        dayLab.attributedText = [self avDayRichText:model.name andColor:i==0?[UIColor colorWithHex:0x6580FE]:[UIColor colorWithHex:0x656565]];
        moneyLab.text = [model.price stringByAppendingString:[[[BaseViewController alloc] init] moneyname]];
        givingLab.text = model.extra;
        if (i == 0) {
            _timeLimitLab.attributedText = [self avValidityRuichText:[self dateChange:model.validity]];
            type = model.id;
        }
        
    }
}


- (IBAction)dismissShouHuView:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
    
}

- (void)showView {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}


- (IBAction)buyBtnAction:(id)sender {
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
    if (type!=nil) { //1.15
        [params setObject:type forKey:@"type"];
    }
    else
    {
        [params setObject:@"" forKey:@"type"];
    }
    
    if (self.buyBtnClick) {
        self.buyBtnClick(params);
    }
    
    
}




- (IBAction)selectShouHuAction:(UIButton *)sender {
    
    for (UIButton *btn in _btnArr) {
        if (btn.tag == sender.tag) {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_live_shouhu_se"] forState:UIControlStateNormal];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:@"icon_live_shouhu_un"] forState:UIControlStateNormal];
        }
    }
    
    for (UILabel *lab in _dayLabArr) {
        if (lab.tag == sender.tag) {
            lab.textColor = [UIColor colorWithHex:0x6580FE];
            
        } else {
            lab.textColor = [UIColor colorWithHex:0x656565];
        }
    }
    
    for (UILabel *lab in _moneyLabArr) {
        if (lab.tag == sender.tag) {
            lab.textColor = [UIColor colorWithHex:0x292929];
        } else {
            lab.textColor = [UIColor colorWithHex:0x292929 alpha:0.49];
        }
    }
    
    shouHuModel *model = _shouHuArr[sender.tag];
    _timeLimitLab.attributedText = [self avValidityRuichText:[self dateChange:model.validity]];
    type = model.id;
    
}

- (NSString *)dateChange:(NSString *)str {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [fmt dateFromString:str];
    fmt.dateFormat = @"yyyy/MM/dd";
    return [fmt stringFromDate:date];
}

- (NSMutableAttributedString *)avDayRichText:(NSString *)str andColor:(UIColor *)color{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINAlternate-Bold" size:35] range:NSMakeRange(0, str.length-1)];
    [attriString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINAlternate-Bold" size:20] range:NSMakeRange(str.length-1, 1)];
    
    [attriString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, str.length)];
    
    [attriString addAttribute:NSKernAttributeName value:@(1.5) range:NSMakeRange(0, str.length)];
    return attriString;
}

- (NSAttributedString *)avValidityRuichText:(NSString *)str {
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:str];
    [attriString addAttribute:NSKernAttributeName value:@(1) range:NSMakeRange(0, str.length)];
    return attriString;
}

@end
