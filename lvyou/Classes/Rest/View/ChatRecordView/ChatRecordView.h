//
//  ChatRecordView.h
//  liveios
//
//  Created by dev on 2020/4/21.
//  Copyright © 2020 Shili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYTCShowLiveMessageView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatRecordView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet YYTCShowLiveMessageView *chatRecordMessageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (nonatomic, copy) void (^closeBtnClick)(void);
@end

NS_ASSUME_NONNULL_END
