//
//  WMCalendarExtensions.m
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import "WMCalendarExtensions.h"
#import <objc/runtime.h>
@implementation NSCalendar (FSCalendarExtensions)

- (nullable NSDate *)fs_firstDayOfMonth:(NSDate *)month
{
    if (!month) return nil;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.day = 1;
    return [self dateFromComponents:components];
}

- (nullable NSDate *)fs_lastDayOfMonth:(NSDate *)month
{
    if (!month) return nil;
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:month];
    components.month++;
    components.day = 0;
    return [self dateFromComponents:components];
}

- (nullable NSDate *)fs_firstDayOfWeek:(NSDate *)week
{
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *components = self.fs_privateComponents;
    components.day = - (weekdayComponents.weekday - self.firstWeekday);
    components.day = (components.day-7) % 7;
    NSDate *firstDayOfWeek = [self dateByAddingComponents:components toDate:week options:0];
    firstDayOfWeek = [self dateBySettingHour:0 minute:0 second:0 ofDate:firstDayOfWeek options:0];
    components.day = NSIntegerMax;
    return firstDayOfWeek;
}

- (nullable NSDate *)fs_lastDayOfWeek:(NSDate *)week
{
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *components = self.fs_privateComponents;
    components.day = - (weekdayComponents.weekday - self.firstWeekday);
    components.day = (components.day-7) % 7 + 6;
    NSDate *lastDayOfWeek = [self dateByAddingComponents:components toDate:week options:0];
    lastDayOfWeek = [self dateBySettingHour:0 minute:0 second:0 ofDate:lastDayOfWeek options:0];
    components.day = NSIntegerMax;
    return lastDayOfWeek;
}

- (nullable NSDate *)fs_middleDayOfWeek:(NSDate *)week
{
    if (!week) return nil;
    NSDateComponents *weekdayComponents = [self components:NSCalendarUnitWeekday fromDate:week];
    NSDateComponents *componentsToSubtract = self.fs_privateComponents;
    componentsToSubtract.day = - (weekdayComponents.weekday - self.firstWeekday) + 3;
    NSDate *middleDayOfWeek = [self dateByAddingComponents:componentsToSubtract toDate:week options:0];
    NSDateComponents *components = [self components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:middleDayOfWeek];
    middleDayOfWeek = [self dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    return middleDayOfWeek;
}

- (NSInteger)fs_numberOfDaysInMonth:(NSDate *)month
{
    if (!month) return 0;
    NSRange days = [self rangeOfUnit:NSCalendarUnitDay
                              inUnit:NSCalendarUnitMonth
                             forDate:month];
    return days.length;
}

- (NSDateComponents *)fs_privateComponents
{
    NSDateComponents *components = objc_getAssociatedObject(self, _cmd);
    if (!components) {
        components = [[NSDateComponents alloc] init];
        objc_setAssociatedObject(self, _cmd, components, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return components;
}

@end
@implementation UIView (FSCalendarExtensions)

- (CGFloat)fs_width
{
    return CGRectGetWidth(self.frame);
}

- (void)setFs_width:(CGFloat)fs_width
{
    self.frame = CGRectMake(self.fs_left, self.fs_top, fs_width, self.fs_height);
}

- (CGFloat)fs_height
{
    return CGRectGetHeight(self.frame);
}

- (void)setFs_height:(CGFloat)fs_height
{
    self.frame = CGRectMake(self.fs_left, self.fs_top, self.fs_width, fs_height);
}

- (CGFloat)fs_top
{
    return CGRectGetMinY(self.frame);
}

- (void)setFs_top:(CGFloat)fs_top
{
    self.frame = CGRectMake(self.fs_left, fs_top, self.fs_width, self.fs_height);
}

- (CGFloat)fs_bottom
{
    return CGRectGetMaxY(self.frame);
}

- (void)setFs_bottom:(CGFloat)fs_bottom
{
    self.fs_top = fs_bottom - self.fs_height;
}

- (CGFloat)fs_left
{
    return CGRectGetMinX(self.frame);
}

- (void)setFs_left:(CGFloat)fs_left
{
    self.frame = CGRectMake(fs_left, self.fs_top, self.fs_width, self.fs_height);
}

- (CGFloat)fs_right
{
    return CGRectGetMaxX(self.frame);
}

- (void)setFs_right:(CGFloat)fs_right
{
    self.fs_left = self.fs_right - self.fs_width;
}

@end
