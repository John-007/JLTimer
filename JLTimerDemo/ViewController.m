//
//  ViewController.m
//  JLTimerDemo
//
//  Created by John on 2021/8/16.
//

#import "ViewController.h"
#import "NewViewController.h"
#import "JLTimer.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
//    [[JLTimer shared] addNewTaskWithOnceTime:5 handleBlock:^{
//        NSLog(@"Debug -- JLTimerType_ViewController 仅执行一次");
//    }];
    int64_t delayInSeconds = 3.0;      // 延迟的时间
    /*
     *@parameter 1,时间参照，从此刻开始计时
     *@parameter 2,延时多久，此处为秒级，还有纳秒等。10ull * NSEC_PER_MSEC
     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //5s后回调，仅执行一次，并自动销毁
        NSLog(@"Debug -- JLTimerType_ViewController 开始");
        
        [[JLTimer shared] addNewTaskWithTime:5 isRepeat:false type:JLTimerType_ViewController handleBlock:^{
            NSLog(@"Debug -- JLTimerType_ViewController 仅执行一次");
        }];
        
        NSLog(@"Debug -- NormalTimer 开始");
        NSTimer *normalTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(runNormalTimer) userInfo:nil repeats:NO];
    });

   

    
    UIButton *presentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [presentBtn setBackgroundColor:[UIColor lightGrayColor]];
    [presentBtn setTitle:@"点击跳转下一页" forState:UIControlStateNormal];
    [presentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [presentBtn addTarget:self action:@selector(didTouchPresentBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:presentBtn];
    presentBtn.center = self.view.center;
    
    
    UIButton *stopTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
    [stopTimeBtn setBackgroundColor:[UIColor lightGrayColor]];
    [stopTimeBtn setTitle:@"停止NewViewController的Timer" forState:UIControlStateNormal];
    [stopTimeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [stopTimeBtn addTarget:self action:@selector(didTouchStopTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopTimeBtn];
    stopTimeBtn.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    
}

- (void)runNormalTimer{
    NSLog(@"Debug -- NormalTimer 仅执行一次");
}



- (void)didTouchPresentBtn{
    
    NewViewController *newVC = [[NewViewController alloc] init];
    newVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:newVC animated:true completion:^{
        
    }];
    
}

- (void)didTouchStopTimeBtn{
    
    [[JLTimer shared] stopTimerWithType:JLTimerType_NewViewController];
    
}


@end
