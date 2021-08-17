//
//  JLTimer.m
//  Test
//
//  Created by John on 2021/8/12.
//  Copyright © 2021  John. All rights reserved.
//

#import "JLTimer.h"
#import "JLTimerModel.h"


@interface JLTimer()

@property (nonatomic,assign) NSInteger serialID;
@property (nonatomic,strong) NSMutableDictionary *timerTaskDict;

@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSMutableArray *stopTypeArray;

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
    }

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:isRepeat type:type handleBlock:handle];
    
    //添加进字典表
    [self timerTaskDictAddModel:model withSerialID:self.serialID];
    
}

- (void)addNewTaskWithOnceTime:(NSInteger)timeNum
               handleBlock:(void (^)(void))handle {
    
    if ([self.timer isValid] == true) {
        //当前总计时未运行
        [self fire];
    }

    JLTimerModel *model = [[JLTimerModel alloc] initWithTimerNum:timeNum isRepeat:false type:-1 handleBlock:handle];
    
    //添加进字典表
    [self timerTaskDictAddModel:model withSerialID:self.serialID];
    
}


//终止所有时间
- (void)stopTimer{
    
    self.stopTypeArray = nil;
    self.timerTaskDict = nil;
    [self.timer invalidate];
    self.timer = nil;
    
}

//终止指定type
- (void)stopTimerWithType:(JLTimerType)type{
    NSLog(@"指定的 JLTimerType = %lu 被移除",(unsigned long)type);
    [self.stopTypeArray addObject:[NSNumber numberWithInteger:type]];
    
}



#pragma mark 内部方法

//启动总计时
- (void)fire{
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//将model添加进事件字典表
- (void)timerTaskDictAddModel:(JLTimerModel*)model withSerialID:(NSInteger)serialID{
    
    NSString *timeStr = [NSString stringWithFormat:@"%ld",serialID + model.timeCount*60];
    NSMutableArray *dataArr = self.timerTaskDict[timeStr];
    
    //添加进数组
    if (dataArr == nil) {
        dataArr = [NSMutableArray arrayWithObject:model];
        self.timerTaskDict[timeStr] = dataArr;
    }else{
        [dataArr addObject:model];
    }
    
}


- (void)runTimer{
    
    self.serialID++;
    
    if (self.timerTaskDict.count > 0) {
        //判断需要执行那些handle
        
        NSString *nowSerialID = [NSString stringWithFormat:@"%ld",self.serialID];
        NSMutableArray *dataArr = self.timerTaskDict[nowSerialID];
        
        if (dataArr != nil) {
            
            for (JLTimerModel *model in dataArr) {
                
                if ([self.stopTypeArray containsObject:[NSNumber numberWithInteger:model.type]]) {
                    [self.stopTypeArray removeObject:[NSNumber numberWithInteger:model.type]];
                    continue;
                }
                
                //执行
                model.eventBlock();
                
                //若需要重复，赋值给下一次
                if (model.isRepeat == true) {
                    [self timerTaskDictAddModel:model withSerialID:self.serialID];
                }
            }
            
            //执行完毕，移除当前ID
            self.timerTaskDict[nowSerialID] = nil;
            
        }
        
    }else{
        
        NSLog(@"计时器销毁");
        [self.timer invalidate];
        self.timer = nil;
    }

}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1/60.0 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
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

@end

