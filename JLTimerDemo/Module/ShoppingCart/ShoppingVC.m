//
//  ShoppingVC.m
//  JLTimerDemo
//
//  Created by John on 2021/9/7.
//

#import "ShoppingVC.h"
#import "JLTimer.h"

@interface ShoppingVC ()

@end

@implementation ShoppingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    [[JLTimer shared] addNewObserver:^{
        NSLog(@"123");
    } with:self.timerID];
}


@end
