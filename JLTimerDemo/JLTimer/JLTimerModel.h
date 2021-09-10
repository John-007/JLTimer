//
//  JLTimerModel.h
//  Test
//
//  Created by John on 2021/8/12.
//  Copyright © 2021  John. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLTimer.h"


NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JLTimerType_Default,
    JLTimerType_CountDown
} JLTimerType;


@interface JLTimerModel : NSObject

@property (nonatomic,assign) BOOL isRepeat;
@property (nonatomic,assign) NSInteger timeCount;
@property (nonatomic,assign) JLTimerType type;
//倒计时属性，统计还剩下几次
@property (nonatomic,assign) NSInteger countDown;
//流水ID
@property (nonatomic,assign) NSInteger serialID;
//要执行的动作
@property (nonatomic,copy) void(^eventBlock)(void);

- (instancetype)initWithTimerNum:(NSUInteger)time isRepeat:(BOOL)isRepeat type:(JLTimerType)type handleBlock:(void(^)(void))handle;

@end

NS_ASSUME_NONNULL_END
