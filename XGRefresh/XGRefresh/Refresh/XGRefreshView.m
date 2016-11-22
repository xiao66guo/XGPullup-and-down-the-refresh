//
//  XGRefreshView.m
//  XGRefresh
//
//  Created by 小果 on 16/9/29.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGRefreshView.h"

@implementation XGRefreshView
-(instancetype)initWithFrame:(CGRect)frame{
    CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, XGRefreshViewHeight);
    if (self = [super initWithFrame:newFrame]) {
        self.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1.0];
        // 添加控件
        [self addSubview:self.animationView];
        [self addSubview:self.refreshLab];
        
        self.animationView.translatesAutoresizingMaskIntoConstraints = NO;
        self.refreshLab.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 对两个子控件添加约束
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.animationView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-45]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.animationView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.refreshLab attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-40]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.refreshLab attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:3]];
    }
    return self;
}

#pragma mark - 当子控件添加到父控件时会调用该方法
-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        self.scroll = (UIScrollView *)newSuperview;
        // 利用KVO来监听tableView的contentSize的变化
        [self.scroll addObserver:self forKeyPath:@"contentSize" options:0 context:NULL];
        // 利用KVO来监听tableView的contentOffset的变化
        [self.scroll addObserver:self forKeyPath:@"contentOffset" options:0 context:NULL];
    }
}

#pragma mark - 移除监听
-(void)dealloc{
    [self.scroll removeObserver:self forKeyPath:@"contetnSize"];
    [self.scroll removeObserver:self forKeyPath:@"contetnOffset"];
}

#pragma mark - 刷新状态的判断和切换
-(void)setCurrentRefreshStatus:(XGRefreshViewStatus)currentRefreshStatus{
    _currentRefreshStatus = currentRefreshStatus;
    switch (_currentRefreshStatus) {
        case XGRefreshViewStatusNormal:
            self.refreshLab.text = @"加载更多数据";
            self.animationView.image = [UIImage imageNamed:@"normal"];
            break;
        case XGRefreshViewStatusPulling:
            self.refreshLab.text = @"嗨,快点放开我";
            self.animationView.image = [UIImage imageNamed:@"pulling"];
            break;
        case XGRefreshViewStatusRefreshing:
            self.refreshLab.text = @"正在加载数据...";
            // 执行动画
            self.animationView.animationImages = self.refreshImages;
            self.animationView.animationDuration = self.refreshImages.count * 0.2;
            [self.animationView startAnimating];
            
            // 在刷新状态时让刷新控件滞留
            UIEdgeInsets contentInset = self.scroll.contentInset;
            if (self.scroll.contentOffset.y >= XGRefreshInitialContentOffsetY) {
                contentInset.bottom = contentInset.bottom + XGRefreshViewHeight;
            }else{
                contentInset.top = contentInset.top + XGRefreshViewHeight;
            }
            [UIView animateWithDuration:0.5 animations:^{
                self.scroll.contentInset = contentInset;
                
            }completion:^(BOOL finished) {
                
                // 让控制器去加载数据
                if (self.refreshingBlock) {
                    self.refreshingBlock();
                }
            }];
            break;
    }
}

#pragma mark - 停止刷新
-(void)endRefreshing{
    if (self.currentRefreshStatus == XGRefreshViewStatusRefreshing) {
        // 停止刷新
        [self.animationView stopAnimating];
        
        UIEdgeInsets contentInset = self.scroll.contentInset;
        if (self.scroll.contentOffset.y >= XGRefreshInitialContentOffsetY) {
            contentInset.bottom = contentInset.bottom - XGRefreshViewHeight;
        }else{
            contentInset.top= contentInset.top - XGRefreshViewHeight;
        }
        self.scroll.contentInset = contentInset;
        
        self.currentRefreshStatus = XGRefreshViewStatusNormal;
    }
}

#pragma mark - 懒加载
-(UIImageView *)animationView{
    if (nil == _animationView) {
        UIImage *image = [UIImage imageNamed:@"normal"];
        _animationView = [[UIImageView alloc] initWithImage:image];
    }
    return _animationView;
}
-(UILabel *)refreshLab{
    if (nil == _refreshLab) {
        _refreshLab = [[UILabel alloc] init];
        _refreshLab.font = [UIFont boldSystemFontOfSize:20];
        _refreshLab.textColor = [UIColor redColor];
        _refreshLab.text = @"加载更多数据";
        
        // 自适应文字大小
        [_refreshLab sizeToFit];
    }
    return _refreshLab;
}
-(NSArray *)refreshImages{
    if (nil == _refreshImages) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 1; i < 4; i++) {
            NSString *imageName = [NSString stringWithFormat:@"refresh_0%d",i];
            UIImage *image = [UIImage imageNamed:imageName];
            [arrayM addObject:image];
        }
        _refreshImages = [arrayM copy];
    }
    return _refreshImages;
}

@end
