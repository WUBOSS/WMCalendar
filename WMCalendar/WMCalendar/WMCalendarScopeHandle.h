//
//  WMCalendarScopeHandle.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMCalendar;
@interface WMCalendarScopeHandle : UIView
@property (weak, nonatomic) UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) WMCalendar *calendar;
- (void)handlePan:(id)sender;
@end
