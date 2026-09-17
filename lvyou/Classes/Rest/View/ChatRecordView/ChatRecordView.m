//
//  ChatRecordView.m
//  liveios
//
//  Created by dev on 2020/4/21.
//  Copyright © 2020 Shili. All rights reserved.
//

#import "ChatRecordView.h"

@implementation ChatRecordView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bottomHeight.constant = iphoneX?34:0;
}

- (IBAction)closeBtnAction:(id)sender {
    if (self.closeBtnClick) {
        self.closeBtnClick();
    }
}


@end
