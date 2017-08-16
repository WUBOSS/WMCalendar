//
//  WMCalendarCalculator.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<UIKit/UIKit.h>
#import "WMCalendar.h"
struct WMCalendarCoordinate {
    NSInteger row;
    NSInteger column;
};
typedef struct WMCalendarCoordinate WMCalendarCoordinate;
@class WMCalendar;
@interface WMCalendarCalculator : NSObject
@property (weak  , nonatomic) WMCalendar *calendar;

@property (readonly, nonatomic) NSInteger numberOfSections;

- (instancetype)initWithCalendar:(WMCalendar *)calendar;

- (NSDate *)safeDateForDate:(NSDate *)date;

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath scope:(WMCalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date;
- (NSIndexPath *)indexPathForDate:(NSDate *)date scope:(WMCalendarScope)scope;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)position;
- (NSIndexPath *)indexPathForDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)position scope:(WMCalendarScope)scope;

- (NSDate *)pageForSection:(NSInteger)section;
- (NSDate *)weekForSection:(NSInteger)section;
- (NSDate *)monthForSection:(NSInteger)section;
- (NSDate *)monthHeadForSection:(NSInteger)section;

- (NSInteger)numberOfHeadPlaceholdersForMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInMonth:(NSDate *)month;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (WMCalendarMonthPosition)monthPositionForIndexPath:(NSIndexPath *)indexPath;
- (WMCalendarCoordinate)coordinateForIndexPath:(NSIndexPath *)indexPath;

- (void)reloadSections;
@end
