//
//  JLTimer.h
//  Test
//
//  Created by John on 2021/8/12.
//  Copyright © 2021  John. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//此处添加自定义的timerGroup，用于批量管理Timer
typedef enum : NSUInteger {
    JLTimerGroup_A,
    JLTimerGroup_B
} JLTimerGroup;


@interface JLTimer : NSObject

+ (instancetype)shared;

/**
 * 开启计时方法
 * Time   --  N秒后回调block。
 * isRepeat   --  是否重复调用，且结束自动销毁；当isRepeat为true时，重复在指定时间后回调block，且不会自动销毁。
 */
- (NSString*)addNewTaskWithTime:(NSInteger)timeNum
                       isRepeat:(BOOL)isRepeat
                    handleBlock:(void (^)(void))handle;

/**
 * 开启计时方法，通过group统一管理时间停止
 * Time   --  N秒后回调block。
 * group  --  批量管理Timer的组，使用前先在JLTimerType新增指定枚举。
 * isRepeat   --  是否重复调用，且结束自动销毁；当isRepeat为true时，重复在指定时间后回调block，且不会自动销毁。
 */
- (NSString*)addNewTaskWithTime:(NSInteger)timeNum
                          group:(JLTimerGroup)group
                       isRepeat:(BOOL)isRepeat
                    handleBlock:(void (^)(void))handle;


/**
 * 快速创建一次性计时器
 * timeNum   --  timeNum秒后回调block。
 * handle   --  回调的block。
 */
- (NSString*)addNewTaskWithOnceTime:(NSInteger)timeNum
                        handleBlock:(void (^)(void))handle;


/**
 * 开启倒计时事件
 * timeNum   --  每秒回调block，一直回调timeNum秒结束。
 * handle   --  回调的block。
 */
- (NSString*)addCountDownTaskWithTime:(NSInteger)timeNum
                          handleBlock:(void (^)(void))handle;


/**
 * 新增timer监听
 * newBlock  --  新的回调block。
 * timerID   --  需要监听的timerID。
 */
- (void)addNewObserver:(void (^)(void))newBlock with:(NSString*)timerID;


/**
 * 终止全部时间
 */
- (void)stopTimer;


/**
 * 终止指定Group下的所有timer
 * group   --  批量管理Timer的组，使用前先在JLTimerType新增指定枚举。
 */
- (void)stopTimerWithGroup:(JLTimerGroup)group;


/**
 * 终止指定timer
 * timerID   --  需要监听的timerID。
 */
- (void)stopTimerWithID:(NSString*)timerID;



- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end







NS_ASSUME_NONNULL_END
