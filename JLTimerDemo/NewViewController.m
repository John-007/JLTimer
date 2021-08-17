//
//  NewViewController.m
//  JLTimerDemo
//
//  Created by John on 2021/8/16.
//

#import "NewViewController.h"
#import "JLTimer.h"



@interface NewViewController ()

@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,assign) int timeCount;

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeCount = 10;
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.numberLabel];
    self.numberLabel.center = self.view.center;
    
    __weak typeof(self) weakSelf = self;
    //创建计时器，间隔3s，type命名为JLTimerType_ViewController
    [[JLTimer shared] addNewTaskWithTime:1 isRepeat:true type:JLTimerType_NewViewController handleBlock:^{
        NSLog(@"Debug -- JLTimerType_NewViewController 每1秒执行一次");
        if (weakSelf.timeCount == 0) {
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        }
        weakSelf.numberLabel.text = [NSString stringWithFormat:@"%d",weakSelf.timeCount];
        weakSelf.timeCount--;
    }];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 80, 80)];
    [backBtn setBackgroundColor:[UIColor lightGrayColor]];
    [backBtn setTitle:@"<" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(didTouchBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)didTouchBackBtn{
    
    [[JLTimer shared] stopTimerWithType:JLTimerType_NewViewController];
    
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)dealloc{
    NSLog(@"NewViewController -- dealloc");
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
        _numberLabel.font = [UIFont boldSystemFontOfSize:25];
        _numberLabel.textColor = [UIColor brownColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

@end
