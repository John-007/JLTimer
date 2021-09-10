//
//  ShoppingVC.h
//  JLTimerDemo
//
//  Created by John on 2021/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShoppingVC : UIViewController

@property (nonatomic,copy) void (^eventBlock)(void);

@property (nonatomic,strong) NSString *timerID;

@end

NS_ASSUME_NONNULL_END
