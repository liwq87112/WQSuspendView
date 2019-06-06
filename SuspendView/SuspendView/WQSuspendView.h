//
//  WQSuspendView.h
//  SuspendView
//
//  Created by 李文强 on 2019/6/6.
//  Copyright © 2019年 WenqiangLI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, WQSuspendViewType) {
    WQSuspendViewTypeNone = 0,
    WQSuspendViewTypeLeft,
    WQSuspendViewTypeRight,
};

@interface WQSuspendView : UIView

@property (nonatomic, copy) void (^ClickBlock)(void);

+ (void)show;
+ (void)showWithType:(WQSuspendViewType)type;
+ (void)remove;

@end

NS_ASSUME_NONNULL_END
