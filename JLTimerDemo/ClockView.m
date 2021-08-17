//
//  ClockView.m
//  JLTimerDemo
//
//  Created by John on 2021/8/16.
//

#import "ClockView.h"
#import "JLTimer.h"

@interface ClockView()

@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,assign) int startNum;

@end

@implementation ClockView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.timeLabel];
        self.timeLabel.frame = self.frame;

        
    }
    return self;
}

- (void)setModel:(ClockModel *)model{
    _model = model;
    
    
    self.startNum = model.startNum;

    __weak typeof(self) weakSelf = self;
    [[JLTimer shared] addNewTaskWithTime:1 isRepeat:true type:model.type handleBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.timeLabel.text = [NSString stringWithFormat:@"%d",strongSelf.startNum];
            strongSelf.startNum++;
        }
    }];
    
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:18];
        _timeLabel.textColor = [UIColor brownColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
