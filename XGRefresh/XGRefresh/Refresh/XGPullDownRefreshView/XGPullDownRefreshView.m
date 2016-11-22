//
//  XGPullDownRefreshView.m
//  XGRefresh
//
//  Created by 小果 on 16/9/28.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "XGPullDownRefreshView.h"

@implementation XGPullDownRefreshView

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect frame = self.frame;
        frame.origin.y = -XGRefreshViewHeight;
        self.frame = frame;
    }else if (self.scroll.isDragging) {
        if (self.scroll.contentOffset.y > XGPullDownRefreshViewChangeHeight == XGRefreshViewStatusPulling) {
            
            self.currentRefreshStatus = XGRefreshViewStatusNormal;
        }else if(self.scroll.contentOffset.y <= XGPullDownRefreshViewChangeHeight && self.currentRefreshStatus == XGRefreshViewStatusNormal){
            
            self.currentRefreshStatus = XGRefreshViewStatusPulling;
        }
    }else{
        if (self.currentRefreshStatus == XGRefreshViewStatusPulling) {
            
            self.currentRefreshStatus = XGRefreshViewStatusRefreshing;
        }
    }
}

@end
