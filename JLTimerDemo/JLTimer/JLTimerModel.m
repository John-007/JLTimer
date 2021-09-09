//
//  JLTimerModel.m
//  Test
//
//  Created by John on 2021/8/12.
//  Copyright © 2021  John. All rights reserved.
//

#import "JLTimerModel.h"

@implementation JLTimerModel

- (instancetype)initWithTimerNum:(NSUInteger)time isRepeat:(BOOL)isRepeat type:(JLTimerType)type handleBlock:(void (^)(void))handle {
    self = [super init];
    if (self) {
        self.timeCount = time;
        self.isRepeat = isRepeat;
        self.type = type;
        self.eventBlock = handle;
    }
    return self;
}

@end
