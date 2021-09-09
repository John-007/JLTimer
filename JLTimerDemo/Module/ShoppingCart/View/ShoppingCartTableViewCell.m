//
//  ShoppingCartTableViewCell.m
//  JLTimerDemo
//
//  Created by John on 2021/9/7.
//

#import "ShoppingCartTableViewCell.h"
#import "JLTimer.h"

@interface ShoppingCartTableViewCell ()

@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,assign) NSInteger timeNum;

@end

@implementation ShoppingCartTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier] ;
    
    [self uiBuild];
    return  self;
    
}

- (void)uiBuild{
    [self.contentView addSubview:self.timeLab];
    self.timeLab.frame = CGRectMake(20, 0, 150, 66);

}

- (void)setTimeCount:(NSInteger)timeCount{
    _timeCount = timeCount;
    self.timeNum = timeCount;
    self.timeLab.text = [NSString stringWithFormat:@"还有%ld秒结束抢购",(long)self.timeNum];
    
    self.eventBlock = [[JLTimer shared] addCountDownTaskWithTime:timeCount handleBlock:^{
        self.timeNum--;
        
        if (self.timeNum == 0){
            self.timeLab.text = @"抢购已结束";
        }else{
            self.timeLab.text = [NSString stringWithFormat:@"还有%ld秒结束抢购",(long)self.timeNum];
        }
    }];
}


- (UILabel *)timeLab{
    
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLab;
}

@end
