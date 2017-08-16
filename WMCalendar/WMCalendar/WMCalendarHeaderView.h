//
//  WMCalendarHeaderView.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMCalendar;
@interface WMCalendarHeaderView : UIView
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;
@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;
@property (weak, nonatomic) WMCalendar *calendar;

@property (assign, nonatomic) BOOL scrollEnabled;
@end

@interface WMCalendarHeaderTouchDeliver : UIView

@property (weak, nonatomic) WMCalendar *calendar;
@property (weak, nonatomic) WMCalendarHeaderView *header;

@end
