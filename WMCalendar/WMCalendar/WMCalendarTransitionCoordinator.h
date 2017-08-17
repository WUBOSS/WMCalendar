//
//  WMCalendarTransitionCoordinator.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMCalendar.h"
@interface WMCalendarTransitionCoordinator : NSObject<UIGestureRecognizerDelegate>
- (instancetype)initWithCalendar:(WMCalendar *)calendar;
@property (readonly, nonatomic) WMCalendarScope representingScope;
- (void)handleScopeGesture:(id)sender;
@end
