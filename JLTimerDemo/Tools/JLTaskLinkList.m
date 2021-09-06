//
//  JLTaskLinkList.m
//  JLTimerDemo
//
//  Created by John on 2021/9/6.
//

#import "JLTaskLinkList.h"

@implementation JLTaskNode

- (instancetype)initNodeWith:(JLTimerModel*)model andSerialID:(NSInteger)serialID{
    if (self = [super init]) {
        _taskArr = [NSMutableArray arrayWithObject:model];
        _serialID = serialID;
    }
    return self;
}

@end



@interface JLTaskLinkList ()



@end

@implementation JLTaskLinkList

- (void)insertNode:(JLTaskNode *)node{
    
    if (self.headNode == nil){
        self.headNode = node;
        return;
    }
    
    
    //从头比对
    BOOL isContinue = true;
    JLTaskNode *currentNode = self.headNode;
    JLTaskNode *lastNode = [[JLTaskNode alloc] init];
    
    while (isContinue) {
        
        if (node.serialID < currentNode.serialID){
            node.next = currentNode;
            lastNode.next = node;
            
            isContinue = false;
        }else if (node.serialID == currentNode.serialID){
            [currentNode.taskArr addObjectsFromArray:node.taskArr];
            
            isContinue = false;
        }else if (node.serialID > currentNode.serialID){
            lastNode = currentNode;
            currentNode = currentNode.next;
        }
        
    }
    
}

- (void)removeFirstNode{
    
    JLTaskNode *currentNode = self.headNode;
    self.headNode = self.headNode.next;
    currentNode = nil;
}

- (void)releaseLinkList{
    
    BOOL isContinue = true;
    JLTaskNode *currentNode;
    
    while (isContinue) {
        currentNode = self.headNode;
        self.headNode = self.headNode.next;
        currentNode = nil;
        
        if (self.headNode == nil){
            isContinue = false;
        }
    }
}

@end
