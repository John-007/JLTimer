//
//  JLTimer.h
//  Test
//
//  Created by John on 2021/8/12.
//  Copyright © 2021  John. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//此处添加自定义的timerType，用于停止指定的timer
typedef enum : NSUInteger {
    JLTimerType_Default,
    JLTimerType_CountDown,
    JLTimerType_Once
} JLTimerType;

@interface JLTimer : NSObject

+ (instancetype)shared;

/**
 * 开始计时方法
 * Time   --  N秒后回调block。
 * isRepeat   --  是否重复调用，且结束自动销毁；当isRepeat为true时，重复在指定时间后回调block，且不会自动销毁。
 */
- (NSString*)addNewTaskWithTime:(NSInteger)timeNum
                  isRepeat:(BOOL)isRepeat
               handleBlock:(void (^)(void))handle;

//快速创建一次性计时器
- (NSString*)addNewTaskWithOnceTime:(NSInteger)timeNum
                   handleBlock:(void (^)(void))handle;

//新增倒计时事件
- (NSString*)addCountDownTaskWithTime:(NSInteger)timeNum
                     handleBlock:(void (^)(void))handle;


/**
 * 新增timer监听
 * newBlock  --  新的回调block。
 * timerID   --  需要监听的timerID。
 */
- (void)addNewObserver:(void (^)(void))newBlock with:(NSString*)timerID;


//终止全部时间
- (void)stopTimer;

//终止指定timer
- (void)stopTimerWithID:(NSString*)timerID;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end







NS_ASSUME_NONNULL_END
