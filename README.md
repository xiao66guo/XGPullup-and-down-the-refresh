# XGPullup-and-down-the-refresh
一套完全自定义的上拉、下拉刷新框架源码，只需导入一个头文件即可

下拉刷新代码：
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

上拉刷新代码：
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
