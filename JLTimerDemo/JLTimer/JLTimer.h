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
    JLTimerType_CountDown = -2,
    JLTimerType_Once = -1,
    JLTimerType_ViewController = 0,
    JLTimerType_ShoppingCart,
    JLTimerType_NewViewController,
    JLTimerType_ShoppingCartA,
    JLTimerType_ShoppingCartB,
    JLTimerType_ShoppingCartC,
} JLTimerType;


@interface JLTimer : NSObject

@property (nonatomic,strong) NSMutableArray *runningTypeArray;

+ (instancetype)shared;

/**
 * 开始计时方法
 * Time   --  N秒后回调block。
 * isRepeat   --  是否重复调用，且结束自动销毁；当isRepeat为true时，重复在指定时间后回调block，且不会自动销毁。
 * type   --    当前计时的Type，相当于当前创建Timer的ID，用于stopTimerWithType（停止该type的Timer）方法。当isRepeat为false时，使用default即可（用其它的也行，反正执行一次以后会自行销毁）；当isRepeat为true时，请自行新增Type。
 */
- (void)addNewTaskWithTime:(NSInteger)timeNum
                  isRepeat:(BOOL)isRepeat
                      type:(JLTimerType)type
               handleBlock:(void (^)(void))handle;

//快速创建一次性计时器
- (void)addNewTaskWithOnceTime:(NSInteger)timeNum
                   handleBlock:(void (^)(void))handle;

//新增倒计时事件
- (void (^)(void))addCountDownTaskWithTime:(NSInteger)timeNum
                     handleBlock:(void (^)(void))handle;


//终止全部时间
- (void)stopTimer;
//终止指定type
- (void)stopTimerWithType:(JLTimerType)type;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
