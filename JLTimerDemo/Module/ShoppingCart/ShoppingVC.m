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

//- (void (^)(void))eventBlock{
//    if (!_eventBlock) {
//        _eventBlock = ^{
//            NSLog(@"123");
//        };
//    }
//    return _eventBlock;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
