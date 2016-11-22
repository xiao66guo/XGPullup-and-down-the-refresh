//
//  XGPullupRefreshView.m
//  XGRefresh
//
//  Created by 小果 on 16/9/28.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGPullupRefreshView.h"

@implementation XGPullupRefreshView

#pragma mark - 调用KVO的方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"]) {
        // 设置刷新控件的位置
        CGRect frame = self.frame;
        frame.origin.y = self.scroll.contentSize.height;
        self.frame = frame;
    }else if ([keyPath isEqualToString:@"contentOffset"]){
        if (self.scroll.isDragging) {
            if (self.scroll.contentOffset.y + self.scroll.frame.size.height < self.scroll.contentSize.height + XGRefreshViewHeight && self.currentRefreshStatus == XGRefreshViewStatusPulling) {
                
                self.currentRefreshStatus = XGRefreshViewStatusNormal;
            }else if (self.scroll.contentOffset.y + self.scroll.frame.size.height >= self.scroll.contentSize.height + XGRefreshViewHeight && self.currentRefreshStatus == XGRefreshViewStatusNormal){
                
                self.currentRefreshStatus = XGRefreshViewStatusPulling;
            }
        }else{
            if (self.currentRefreshStatus == XGRefreshViewStatusPulling) {
                
                self.currentRefreshStatus = XGRefreshViewStatusRefreshing;
            }
        }
    }
}

@end
