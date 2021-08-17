//
//  ClockModel.h
//  JLTimerDemo
//
//  Created by John on 2021/8/16.
//

#import <Foundation/Foundation.h>
#import "JLTimer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClockModel : NSObject

@property (nonatomic,assign) int startNum;
@property (nonatomic,assign) JLTimerType type;

@end

NS_ASSUME_NONNULL_END
