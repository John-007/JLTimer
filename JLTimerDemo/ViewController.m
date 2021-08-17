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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //5s后回调，仅执行一次，并自动销毁
    [[JLTimer shared] addNewTaskWithOnceTime:5 handleBlock:^{
        NSLog(@"Debug -- JLTimerType_ViewController 仅执行一次");
    }];
    
    
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
