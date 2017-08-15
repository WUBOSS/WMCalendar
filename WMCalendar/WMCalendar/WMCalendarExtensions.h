//
//  WMCalendarExtensions.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSCalendar (FSCalendarExtensions)

- (nullable NSDate *)fs_firstDayOfMonth:(NSDate *)month;
- (nullable NSDate *)fs_lastDayOfMonth:(NSDate *)month;
- (nullable NSDate *)fs_firstDayOfWeek:(NSDate *)week;
- (nullable NSDate *)fs_lastDayOfWeek:(NSDate *)week;
- (nullable NSDate *)fs_middleDayOfWeek:(NSDate *)week;
- (NSInteger)fs_numberOfDaysInMonth:(NSDate *)month;

@end

NS_ASSUME_NONNULL_END
