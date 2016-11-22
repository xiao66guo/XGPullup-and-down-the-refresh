//
//  UIScrollView+XGRefresh.h
//  XGRefresh
//
//  Created by 小果 on 16/9/28.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGPullupRefreshView.h"
#import "XGPullDownRefreshView.h"
@interface UIScrollView (XGRefresh)

@property (nonatomic, strong) XGPullupRefreshView *upRefreshView;

@property (nonatomic, strong) XGPullDownRefreshView *downRefreshView;

@end
