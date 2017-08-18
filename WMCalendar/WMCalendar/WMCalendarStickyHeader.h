//
//  WMCalendarStickyHeader.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WMCalendar,WMCalendarAppearance;

@interface WMCalendarStickyHeader : UICollectionReusableView

@property (weak, nonatomic) WMCalendar *calendar;

@property (weak, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSDate *month;

- (void)configureAppearance;

@end
