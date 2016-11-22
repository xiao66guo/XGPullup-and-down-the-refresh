//
//  UIScrollView+XGRefresh.m
//  XGRefresh
//
//  Created by 小果 on 16/9/28.
//  Copyright © 2016年 小果. All rights reserved.
//

#import "UIScrollView+XGRefresh.h"
#import <objc/runtime.h>

static const char *upRefreshKey = "upRefreshKey";
static const char *downRefreshKey = "downRefreshKey";

@interface UIScrollView ()

@end
@implementation UIScrollView (XGRefresh)

-(void)setUpRefreshView:(XGPullupRefreshView *)upRefreshView{
    objc_setAssociatedObject(self, upRefreshKey, upRefreshView, 1);
}

-(XGPullupRefreshView *)upRefreshView{
    XGPullupRefreshView *upRefreshView = objc_getAssociatedObject(self, upRefreshKey);
    if (nil == upRefreshView) {
        upRefreshView = [[XGPullupRefreshView alloc] init];
        [self addSubview:upRefreshView];
        self.upRefreshView = upRefreshView;
    }
    return upRefreshView;
}

-(void)setDownRefreshView:(XGPullDownRefreshView *)downRefreshView{
    objc_setAssociatedObject(self, downRefreshKey, downRefreshView, 1);
}

-(XGPullDownRefreshView *)downRefreshView{
    XGPullDownRefreshView *downRefreshView = objc_getAssociatedObject(self, downRefreshKey);
    if (nil == downRefreshView) {
        downRefreshView = [[XGPullDownRefreshView alloc] init];
        [self addSubview:downRefreshView];
        
        self.downRefreshView = downRefreshView;
    }
    return downRefreshView;
}
@end
