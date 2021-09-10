//
//  ShoppingCartVC.m
//  JLTimerDemo
//
//  Created by John on 2021/9/7.
//

#import "ShoppingCartVC.h"
#import "ShoppingCartTableViewCell.h"
#import "ShoppingVC.h"
#import "JLTimer.h"

@interface ShoppingCartVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tabV;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation ShoppingCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiBuild];
}

- (void)uiBuild{

    self.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view addSubview:self.tabV];
    self.tabV.frame = self.view.bounds;
    [self.tabV registerClass:[ShoppingCartTableViewCell class] forCellReuseIdentifier:@"ShoppingCartTableViewCell"];
    
    
    self.dataArr = @[@8,@18,@28,@22,@16,@8,@18,@28,@22,@16];
//    self.dataArr = @[@8];
    [self.tabV reloadData];
    

}


//delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShoppingCartTableViewCell" forIndexPath:indexPath];
    cell.timeCount = [self.dataArr[indexPath.row] integerValue];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShoppingVC *vc = [[ShoppingVC alloc] init];
    ShoppingCartTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.timerID = cell.timerID;
    [self.navigationController pushViewController:vc animated:true];
}


- (UITableView *)tabV{
    if (!_tabV) {
        _tabV = [[UITableView alloc] init];
        _tabV.delegate = self;
        _tabV.dataSource = self;
    }
    return _tabV;
}

@end
