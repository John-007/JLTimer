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
@property (nonatomic,strong) NSMutableDictionary *timerTaskDict;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray *stopTypeArray;

@property (nonatomic,strong) JLTaskLinkList *linkList;

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

//新增事件
- (void)addNewTaskWithTime:(NSInteger)timeNum
                  isRepeat:(BOOL)isRepeat
                      type:(JLTimerType)type
               handleBlock:(void (^)(void))handle {
    
    if ([self.timer isValid] == true) {
        //当前总计时未运行
        [self fire];
        
        //初次创建需要找平fire后到真正启动的时间差
    }

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:isRepeat type:type handleBlock:handle];
    
    //添加进链表
    [self timerTaskDictAddNodeList:model withSerialID:self.serialID];
    
}

- (void)addNewTaskWithOnceTime:(NSInteger)timeNum
               handleBlock:(void (^)(void))handle {

    if ([self.timer isValid] == true) {
        //当前总计时未运行
        [self fire];
        
        //初次创建需要找平fire后到真正启动的时间差
    }

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:false type:-1 handleBlock:handle];

    //添加进链表
    [self timerTaskDictAddNodeList:model withSerialID:self.serialID];

}

//- (void)addNewTaskWithOnceTime:(NSInteger)timeNum
//               handleBlock:(void (^)(void))handle {
//
//    if ([self.timer isValid] == true) {
//        //当前总计时未运行
//        [self fire];
//    }
//
//    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:false type:-1 handleBlock:handle];
//
//    //添加进字典表
//    [self timerTaskDictAddModel:model withSerialID:self.serialID];
//
//}
//- (void)addNewTaskWithOnceTime:(NSInteger)timeNum
//               handleBlock:(void (^)(void))handle {
//
//    if ([self.timer isValid] == true) {
//        //当前总计时未运行
//        [self fire];
//    }
//
//    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:false type:-1 handleBlock:handle];
//
//    //添加进字典表
//    [self timerTaskDictAddModel:model withSerialID:self.serialID];
//
//}


//终止所有时间
- (void)stopTimer{
    
//    self.stopTypeArray = nil;
//    self.timerTaskDict = nil;
    [self.linkList releaseLinkList];
    [self.timer invalidate];
    self.timer = nil;
    
}

//终止指定type
- (void)stopTimerWithType:(JLTimerType)type{
    NSLog(@"指定的 JLTimerType = %lu 被移除",(unsigned long)type);
    [self.stopTypeArray addObject:[NSNumber numberWithInteger:type]];
    
}

//接管timer
- (void)takeOverTimerWithType:(JLTimerType)type{
    
    
    
}


#pragma mark 内部方法



//启动总计时
- (void)fire{
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//将model添加进链表
- (void)timerTaskDictAddNodeList:(JLTimerModel*)model withSerialID:(NSInteger)serialID{
    
    NSInteger targetSerialID = serialID + model.timeCount*100;
    //添加进链表
    JLTaskNode *node = [[JLTaskNode alloc] initNodeWith:model andSerialID:targetSerialID];
    [self.linkList insertNode:node];

}

////将model添加进事件字典表
//- (void)timerTaskDictAddModel:(JLTimerModel*)model withSerialID:(NSInteger)serialID{
//
//    NSString *timeStr = [NSString stringWithFormat:@"%ld",serialID + model.timeCount*100];
//    NSMutableArray *dataArr = self.timerTaskDict[timeStr];
//
//    //添加进数组
//    if (dataArr == nil) {
//        dataArr = [NSMutableArray arrayWithObject:model];
//        self.timerTaskDict[timeStr] = dataArr;
//    }else{
//        [dataArr addObject:model];
//    }
//}


- (void)runTimer{
    
    self.serialID++;
    
    
    if (self.linkList.headNode == nil) {
        NSLog(@"计时器销毁");
        [self.timer invalidate];
        self.timer = nil;
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
                    [self timerTaskDictAddNodeList:model withSerialID:self.serialID];
                }
            }
            
            //执行完毕，移除当前Node
            [self.linkList removeFirstNode];
        }
    }
}


//- (void)runTimer_new{
//
//    self.serialID++;
//
//    if (self.timerTaskDict.count > 0) {
//        //判断需要执行那些handle
//
////        NSLog(@"isTime");
//        NSString *nowSerialID = [NSString stringWithFormat:@"%ld",self.serialID];
//        NSMutableArray *dataArr = self.timerTaskDict[nowSerialID];
//
//
//        if (dataArr != nil) {
//
//            for (JLTimerModel *model in dataArr) {
//
//                //判断是否在终止数组中
//                if ([self.stopTypeArray containsObject:[NSNumber numberWithInteger:model.type]]) {
//                    [self.stopTypeArray removeObject:[NSNumber numberWithInteger:model.type]];
//                    continue;
//                }
//
//                //执行
//                NSLog(@"isTime");
//                model.eventBlock();
//
//                //若需要重复，赋值给下一次
//                if (model.isRepeat == true) {
//                    [self timerTaskDictAddModel:model withSerialID:self.serialID];
//                }
//            }
//
//            //执行完毕，移除当前ID
//            self.timerTaskDict[nowSerialID] = nil;
//
//        }
//
//    }else{
//
////        NSLog(@"计时器销毁");
////        [self.timer invalidate];
////        self.timer = nil;
//    }
//
//
//}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1/100.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSMutableDictionary *)timerTaskDict{
    if (!_timerTaskDict) {
        _timerTaskDict = [NSMutableDictionary dictionary];
    }
    return _timerTaskDict;
}

- (NSMutableArray *)stopTypeArray{
    if (!_stopTypeArray) {
        _stopTypeArray = [NSMutableArray array];
    }
    return _stopTypeArray;
}

- (NSMutableArray *)runningTypeArray{
    if (!_runningTypeArray) {
        _runningTypeArray = [NSMutableArray array];
    }
    return _runningTypeArray;
}

- (JLTaskLinkList *)linkList{
    if (!_linkList) {
        _linkList = [[JLTaskLinkList alloc] init];
    }
    return _linkList;
}

@end

