//
//  XGViewController.m
//  XGRefresh
//
//  Created by 小果 on 16/9/28.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGViewController.h"
#import "XGRefresh.h"
static NSString *cellID = @"cell";
static NSUInteger count = 0;
@interface XGViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation XGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册Cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.dataSource = [self loadData:@"dataSource.json"];
    
    // 给tableView添加一个没有大小的footView，用来把刷新控件后面的分割线去掉
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    
    __weak typeof(self) weakSelf = self;
    
    // 下拉加载数据的方法
    [weakSelf.tableView.downRefreshView setRefreshingBlock:^{
        // 加载数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSString *fileName = [NSString stringWithFormat:@"dataSource%zd.json",count % 9];
            NSArray *newDataSource = [weakSelf loadData:fileName];
            NSMutableArray *source = [NSMutableArray arrayWithArray:weakSelf.dataSource];
            
            [source insertObjects:newDataSource atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newDataSource.count)]];
            
            weakSelf.dataSource = source;
            [weakSelf.tableView reloadData];
            
            // 让刷新控件停止刷新
            [weakSelf.tableView.downRefreshView endRefreshing];
            
            count ++;
        });

    }];
    // 上拉加载数据的方法
    [weakSelf.tableView.upRefreshView setRefreshingBlock:^{
       // 加载数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSString *fileName = [NSString stringWithFormat:@"dataSource%zd.json",count % 9];
            NSArray *newDataSource = [weakSelf loadData:fileName];
            NSMutableArray *source = [NSMutableArray arrayWithArray:weakSelf.dataSource];
            [source addObjectsFromArray:newDataSource];
            
            weakSelf.dataSource = source;
            [weakSelf.tableView reloadData];
            
            NSIndexPath *lastRow = [NSIndexPath indexPathForRow:weakSelf.dataSource.count -1  inSection:0];
            
            // 让刷新控件停止刷新
            [weakSelf.tableView.upRefreshView endRefreshing];
            [weakSelf.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            count ++;
        });
    }];
}

#pragma mark - 加载数据
-(NSArray *)loadData:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    NSData *datas = [NSData dataWithContentsOfFile:path];
    NSArray *dataArray = [NSJSONSerialization JSONObjectWithData:datas options:0 error:nil];
    
    return dataArray;
}

#pragma mark -  tableView的数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor randomColor];
    }
    cell.contentView.alpha = 0.8;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:25];
    cell.textLabel.text = self.dataSource[indexPath.row][@"name"];
    
    return cell;
}
@end
