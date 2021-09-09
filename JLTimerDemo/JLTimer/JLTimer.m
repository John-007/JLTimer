//
//  JLTimer.m
//  Test
//
//  Created by John on 2021/8/12.
//  Copyright © 2021  John. All rights reserved.
//

#import "JLTimer.h"
#import "JLTimerModel.h"
#import "JLTaskLinkList.h"

@interface JLTimer()

@property (nonatomic,assign) NSInteger serialID;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray *stopTypeArray;

@property (nonatomic,strong) JLTaskLinkList *linkList;

@property (nonatomic,assign) NSInteger startTime;
@property (nonatomic,assign) NSInteger realStartTime;

@end

@implementation JLTimer


#pragma mark 初始化

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    static JLTimer *manager = nil;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[JLTimer alloc] init];
        }
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化serialID
        self.serialID = 0;
    }
    return self;
}


#pragma mark 外部方法

//新增计时事件
- (void)addNewTaskWithTime:(NSInteger)timeNum
                  isRepeat:(BOOL)isRepeat
                      type:(JLTimerType)type
               handleBlock:(void (^)(void))handle {
    
    [self dealWithTimer];

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:isRepeat type:type handleBlock:handle];
    
    //添加进链表
    [self addToNodeList:model withSerialID:self.serialID];
    
}

//新增一次性计时事件
- (void)addNewTaskWithOnceTime:(NSInteger)timeNum
                   handleBlock:(void (^)(void))handle {


    [self dealWithTimer];

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:false type:JLTimerType_Once handleBlock:handle];

    //添加进链表
    [self addToNodeList:model withSerialID:self.serialID];

}

//新增倒计时事件
- (void (^)(void))addCountDownTaskWithTime:(NSInteger)timeNum
                     handleBlock:(void (^)(void))handle {
    
    [self dealWithTimer];
    
    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:1 isRepeat:true type:JLTimerType_CountDown handleBlock:handle];
    model.countDown = timeNum;
    
    //添加进链表
    [self addToNodeList:model withSerialID:self.serialID];
    
    return handle;
}


//终止指定type
- (void)stopTimerWithType:(JLTimerType)type{
    NSLog(@"指定的 JLTimerType = %lu 被移除",(unsigned long)type);
    [self.stopTypeArray addObject:[NSNumber numberWithInteger:type]];
    
}

//终止所有时间
- (void)stopTimer{
    
    self.serialID = 0;
    self.stopTypeArray = nil;
    [self.linkList releaseLinkList];
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"计时器销毁");
}

//接管timer
- (void)takeOverTimerWithType:(JLTimerType)type{
    
    
    
}


#pragma mark 内部方法

//处理初次创建timer
- (void)dealWithTimer{
    
    if (self.timer == nil) {
        NSLog(@"创建计时器");
        //当前总计时未运行
        self.timer = [NSTimer timerWithTimeInterval:1/100.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        
        //初次创建需要找平时间差
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        self.startTime = (now - (int)now)*100;
    }
}


//将model添加进链表
- (void)addToNodeList:(JLTimerModel*)model withSerialID:(NSInteger)serialID{
    
    NSInteger targetSerialID = serialID + model.timeCount*100;
    //添加进链表
    JLTaskNode *node = [[JLTaskNode alloc] initNodeWith:model andSerialID:targetSerialID];
    [self.linkList insertNode:node];

}

- (void)runTimer{
    
    if (self.serialID == 0) {
        //初次创建需要找平时间差
        NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
        self.realStartTime = (now - (int)now)*100;
        if (self.realStartTime < self.startTime) {
            self.realStartTime +=  100;
        }
        self.serialID = self.realStartTime - self.startTime;
        NSLog(@"初次找平：%ld",(long)self.serialID);
    }
    
    
    if (self.linkList.headNode == nil) {
        
        [self stopTimer];
        return;
        
    }else{

        if (self.linkList.headNode.serialID == self.serialID) {
            for (int i = 0; i < self.linkList.headNode.taskArr.count; i++) {
                JLTimerModel *model = self.linkList.headNode.taskArr[i];
                
                //判断是否在终止数组中
                if ([self.stopTypeArray containsObject:[NSNumber numberWithInteger:model.type]]) {
                    [self.stopTypeArray removeObject:[NSNumber numberWithInteger:model.type]];
                    continue;
                }

                //执行
                model.eventBlock();
                

                //若需要重复，赋值至下一次
                if (model.isRepeat == true) {
                    
                    //判断是否是倒计时类型
                    if (model.type == JLTimerType_CountDown) {
                        model.countDown--;
//                        NSLog(@"model.countDown -- %ld",(long)model.countDown);
                        if (model.countDown == 0) {
                            continue;
                        }
                    }
                    
                    [self addToNodeList:model withSerialID:self.serialID];
                }
            }
            
            //执行完毕，移除当前Node
            [self.linkList removeFirstNode];
        }
    }
    
    self.serialID++;
}

- (NSMutableArray *)stopTypeArray{
    if (!_stopTypeArray) {
        _stopTypeArray = [NSMutableArray array];
    }
    return _stopTypeArray;
}

- (JLTaskLinkList *)linkList{
    if (!_linkList) {
        _linkList = [[JLTaskLinkList alloc] init];
    }
    return _linkList;
}

@end

