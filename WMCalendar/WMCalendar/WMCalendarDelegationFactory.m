//
//  WMCalendarDelegationFactory.m
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import "WMCalendarDelegationFactory.h"
#define WMCalendarSelectorEntry(SEL1,SEL2) NSStringFromSelector(@selector(SEL1)):NSStringFromSelector(@selector(SEL2))
@implementation WMCalendarDelegationFactory
+ (WMCalendarDelegationProxy *)dataSourceProxy
{
    WMCalendarDelegationProxy *delegation = [[WMCalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(WMCalendarDataSource);
    delegation.deprecations = @{WMCalendarSelectorEntry(calendar:numberOfEventsForDate:, calendar:hasEventForDate:)};
    return delegation;
}

+ (WMCalendarDelegationProxy *)delegateProxy
{
    WMCalendarDelegationProxy *delegation = [[WMCalendarDelegationProxy alloc] init];
    delegation.protocol = @protocol(WMCalendarDelegateAppearance);
    delegation.deprecations = @{
                                WMCalendarSelectorEntry(calendarCurrentPageDidChange:, calendarCurrentMonthDidChange:),
                                WMCalendarSelectorEntry(calendar:shouldSelectDate:atMonthPosition:, calendar:shouldSelectDate:),
                                WMCalendarSelectorEntry(calendar:didSelectDate:atMonthPosition:, calendar:didSelectDate:),
                                WMCalendarSelectorEntry(calendar:shouldDeselectDate:atMonthPosition:, calendar:shouldDeselectDate:),
                                WMCalendarSelectorEntry(calendar:didDeselectDate:atMonthPosition:, calendar:didDeselectDate:)
                                };
    return delegation;
}


@end
#undef WMCalendarSelectorEntry
