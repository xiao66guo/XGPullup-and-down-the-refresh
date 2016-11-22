//
//  XGRefreshView.h
//  XGRefresh
//
//  Created by 小果 on 16/9/29.
//  Copyright © 2016年 小果. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    XGRefreshViewStatusNormal = 0,
    XGRefreshViewStatusPulling = 1,
    XGRefreshViewStatusRefreshing = 2
}XGRefreshViewStatus;

#define XGRefreshViewHeight 60
#define XGRefreshInitialContentOffsetY -64
#define XGPullDownRefreshViewChangeHeight XGRefreshInitialContentOffsetY - XGRefreshViewHeight
@interface XGRefreshView : UIView

@property (nonatomic, copy) void(^refreshingBlock)();


@property (nonatomic, strong) UIScrollView *scroll;
/**
 *  加载动画
 */
@property (nonatomic, strong) UIImageView *animationView;
/**
 *  加载文字
 */
@property (nonatomic, strong) UILabel *refreshLab;
/**
 *  序列动画数组
 */
@property (nonatomic, strong) NSArray *refreshImages;

///**
// *  记录当前的刷新状态
// */
@property (nonatomic, assign) XGRefreshViewStatus currentRefreshStatus;

//// 结束刷新
- (void)endRefreshing;
@end
