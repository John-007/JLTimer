//
//  ViewController.m
//  JLTimerDemo
//
//  Created by John on 2021/8/16.
//

#import "ViewController.h"
#import "JLTimer.h"
#import "ShoppingCartVC.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
//    NSLog(@"Debug -- JLTimerType_ViewController 开始");
//
//    [[JLTimer shared] addNewTaskWithOnceTime:1 handleBlock:^{
//        NSLog(@"Debug -- JLTimerType_ViewController 仅执行一次");
//    }];
//    NSTimer *normalTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runNormalTimer) userInfo:nil repeats:NO];
//
//    NSLog(@"Debug -- NormalTimer 开始");
    

   

    
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
    
    ShoppingCartVC *newVC = [[ShoppingCartVC alloc] init];
    [self.navigationController pushViewController:newVC animated:true];

}

- (void)didTouchStopTimeBtn{
    

    [[JLTimer shared] stopTimerWithGroup:JLTimerGroup_ShoppingCart];
    
}


@end
