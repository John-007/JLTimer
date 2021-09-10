//
//  JLTaskLinkList.h
//  JLTimerDemo
//
//  Created by John on 2021/9/6.
//

#import <Foundation/Foundation.h>

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



@interface JLTaskNode : NSObject

@property (nonatomic, assign) NSInteger serialID;
@property (nonatomic, strong) NSMutableArray *taskArr;
@property (nonatomic, strong) JLTaskNode *next;

- (instancetype)initNodeWith:(JLTimerModel*)model andSerialID:(NSInteger)serialID;

@end


@interface JLTaskLinkList : NSObject

@property (nonatomic, strong) JLTaskNode *headNode;

- (void)insertNode:(JLTaskNode *)node;
- (void)removeFirstNode;
- (void)releaseLinkList;
@end

NS_ASSUME_NONNULL_END
