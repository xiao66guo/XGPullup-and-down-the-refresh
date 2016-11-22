//
//  UIColor+Tools.m
//  
//
//  Created by 小果 on 16-8-5.
//  Copyright (c) 2016年 itcast. All rights reserved.
//

#import "UIColor+Tools.h"

@implementation UIColor (Tools)

// 生成随机颜色
+(UIColor *)xg_randomColor
{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    
    return [self colorWithRed:r green:g blue:b alpha:1.0];
}



@end
