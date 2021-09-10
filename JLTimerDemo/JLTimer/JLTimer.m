//
//  JLTimer.m
//  Test
//
//  Created by John on 2021/8/12.
//  Copyright © 2021  John. All rights reserved.
//

#import "JLTimer.h"
#import "JLTaskLinkList.h"


@interface JLTimer()

@property (nonatomic,assign) NSInteger            serialID;                   //流水ID
@property (nonatomic,strong) NSTimer             *timer;                      //唯一运行的timer
@property (nonatomic,strong) NSMutableArray      *shouldStopTimerIDArray;     //需要停止的timer数组
@property (nonatomic,strong) NSMutableDictionary *newObserverDict;            //存放监听者的字典
@property (nonatomic,strong) JLTaskLinkList      *linkList;                   //总链表
@property (nonatomic,strong) NSMutableDictionary *timerGroupDict;             //存放timer组的字典

//用于时间找平
@property (nonatomic,assign) NSInteger            startTime;
@property (nonatomic,assign) NSInteger            realStartTime;



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
- (NSString*)addNewTaskWithTime:(NSInteger)timeNum
                       isRepeat:(BOOL)isRepeat
                    handleBlock:(void (^)(void))handle {
    
    [self dealWithTimer];

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:isRepeat type:JLTimerType_Default handleBlock:handle];
    
    //添加进链表
    [self addToNodeList:model withSerialID:self.serialID];
    
    return [self getTimerID:handle];
}

//新增计时事件，带有组管理
- (NSString*)addNewTaskWithTime:(NSInteger)timeNum
                          group:(JLTimerGroup)group
                       isRepeat:(BOOL)isRepeat
                    handleBlock:(void (^)(void))handle {
    
    
    NSMutableArray *contentArr = [NSMutableArray array];
    
    NSNumber *num = [self getGroupNumber:group];
    if ([self.timerGroupDict.allKeys containsObject:num]){
        contentArr = self.timerGroupDict[num];
    }
    //加入对应ID的监听数组
    [contentArr addObject:[self getTimerID:handle]];
    
    return [self addNewTaskWithTime:timeNum isRepeat:isRepeat handleBlock:handle];
    
}


//新增一次性计时事件
- (NSString*)addNewTaskWithOnceTime:(NSInteger)timeNum
                        handleBlock:(void (^)(void))handle {


    [self dealWithTimer];

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:false type:JLTimerType_Default handleBlock:handle];

    //添加进链表
    [self addToNodeList:model withSerialID:self.serialID];

    return [self getTimerID:handle];
}

//新增倒计时事件
- (NSString*)addCountDownTaskWithTime:(NSInteger)timeNum
                          handleBlock:(void (^)(void))handle {
    
    [self dealWithTimer];
    
    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:1 isRepeat:true type:JLTimerType_CountDown handleBlock:handle];
    model.countDown = timeNum;
    //添加进链表
    [self addToNodeList:model withSerialID:self.serialID];

    return [self getTimerID:model.eventBlock];
}


//终止指定timer
- (void)stopTimerWithID:(NSString*)timerID{
    
    [self.shouldStopTimerIDArray addObject:timerID];
    
    [self removeTimerObserverFor:timerID];
    
}


//终止指定Group下的所有timer
- (void)stopTimerWithGroup:(JLTimerGroup)group{
    
    NSNumber *num = [self getGroupNumber:group];
    for (NSString* timerID in self.timerGroupDict[num]) {
        [self stopTimerWithID:timerID];
    }
}


//终止所有时间
- (void)stopTimer{
    
    self.serialID = 0;
    self.shouldStopTimerIDArray = nil;
    [self.linkList releaseLinkList];
    [self.timer invalidate];
    self.timer = nil;
    
    NSLog(@"计时器销毁");
}





//新增监听timer
- (void)addNewObserver:(void (^)(void))newBlock with:(NSString *)timerID{
    
    NSMutableArray *contentArr = [NSMutableArray array];
    
    if ([self.newObserverDict.allKeys containsObject:timerID]){
        contentArr = self.newObserverDict[timerID];
    }
    //加入对应ID的监听数组
    [contentArr addObject:newBlock];
}


#pragma mark 内部方法


//将model添加进链表
- (void)addToNodeList:(JLTimerModel*)model withSerialID:(NSInteger)serialID{
    
    NSInteger targetSerialID = serialID + model.timeCount*100;
    //添加进链表
    JLTaskNode *node = [[JLTaskNode alloc] initNodeWith:model andSerialID:targetSerialID];
    [self.linkList insertNode:node];

}


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

//处理Timer的观察者
- (void)dealWithObserver:(JLTimerModel*)model{
    
    if (self.newObserverDict.count == 0) {
        return;
    }
    
    NSString *keyStr = [self getTimerID:model.eventBlock];
    if ([self.newObserverDict.allKeys containsObject:keyStr]) {
        
        for ( void(^eventBlock)(void) in self.newObserverDict[keyStr]) {
            eventBlock();
        }
        
    }
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
                
                NSString *timerID = [self getTimerID:model.eventBlock];
                
                
                if ([self.shouldStopTimerIDArray containsObject:timerID]) {
                    [self.shouldStopTimerIDArray removeObject:timerID];
                    continue;
                }
                
                
                
                //执行Block
                model.eventBlock();
                
                
                //处理Timer的监听业务
                [self dealWithObserver:model];

                
                //处理Timer的循环添加
                if (model.isRepeat == true) {
                    //需要重复，赋值至下一次
                    
                    //判断是否是倒计时类型
                    if (model.type == JLTimerType_CountDown) {
                        model.countDown--;
                        if (model.countDown == 0) {
                            
                            //时间到，结束当前timer，清空其监听
                            [self removeTimerObserverFor:timerID];
                            
                            continue;
                        }
                    }
                    
                    //添加至下一次调用
                    [self addToNodeList:model withSerialID:self.serialID];
                    
                    
                }else{
                    
                    //不需要重复，清空指定timer的监听
                    [self removeTimerObserverFor:timerID];
                }
            }
            
            //执行完毕，移除当前Node
            [self.linkList removeFirstNode];
        }
    }
    
    self.serialID++;
}


//清空指定timer的监听
- (void)removeTimerObserverFor:(NSString*)timerID{
    
    if ([self.newObserverDict.allKeys containsObject:timerID]){
        [self.newObserverDict removeObjectForKey:timerID];
    }
}


- (NSString*)getTimerID:(void (^)(void))handle{
    return [NSString stringWithFormat:@"%@",handle];
}

- (NSNumber*)getGroupNumber:(JLTimerGroup)group{
    
    return [NSNumber numberWithInteger:group];
}


- (NSMutableArray *)shouldStopTimerIDArray{
    if (!_shouldStopTimerIDArray) {
        _shouldStopTimerIDArray = [NSMutableArray array];
    }
    return _shouldStopTimerIDArray;
}

- (JLTaskLinkList *)linkList{
    if (!_linkList) {
        _linkList = [[JLTaskLinkList alloc] init];
    }
    return _linkList;
}

- (NSMutableDictionary *)newObserverDict{
    if (!_newObserverDict) {
        _newObserverDict = [NSMutableDictionary dictionary];
    }
    return _newObserverDict;
}

- (NSMutableDictionary *)timerGroupDict{
    if (!_timerGroupDict) {
        _timerGroupDict = [NSMutableDictionary dictionary];
    }
    return _timerGroupDict;
}

@end
