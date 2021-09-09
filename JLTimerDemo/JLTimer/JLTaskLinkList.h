//
//  JLTaskLinkList.h
//  JLTimerDemo
//
//  Created by John on 2021/9/6.
//

#import <Foundation/Foundation.h>
#import "JLTimerModel.h"

NS_ASSUME_NONNULL_BEGIN

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
