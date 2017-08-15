//
//  WMCalendarConstants.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
CG_EXTERN CGFloat const WMCalendarStandardHeaderHeight;
CG_EXTERN CGFloat const WMCalendarStandardWeekdayHeight;
CG_EXTERN CGFloat const WMCalendarStandardMonthlyPageHeight;
CG_EXTERN CGFloat const WMCalendarStandardWeeklyPageHeight;
CG_EXTERN CGFloat const WMCalendarStandardCellDiameter;
CG_EXTERN CGFloat const WMCalendarStandardSeparatorThickness;
CG_EXTERN CGFloat const WMCalendarAutomaticDimension;
CG_EXTERN CGFloat const WMCalendarDefaultBounceAnimationDuration;
CG_EXTERN CGFloat const WMCalendarStandardRowHeight;
CG_EXTERN CGFloat const WMCalendarStandardTitleTextSize;
CG_EXTERN CGFloat const WMCalendarStandardSubtitleTextSize;
CG_EXTERN CGFloat const WMCalendarStandardWeekdayTextSize;
CG_EXTERN CGFloat const WMCalendarStandardHeaderTextSize;
CG_EXTERN CGFloat const WMCalendarMaximumEventDotDiameter;
CG_EXTERN CGFloat const WMCalendarStandardScopeHandleHeight;


#if TARGET_INTERFACE_BUILDER
#define FSCalendarDeviceIsIPad NO
#else
#define FSCalendarDeviceIsIPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#endif

#define WMCalendarDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")
WMCalendarDeprecated('borderRadius')
typedef NS_ENUM(NSUInteger, WMCalendarCellShape) {
    WMCalendarCellShapeCircle    = 0,
    WMCalendarCellShapeRectangle = 1
};
typedef NS_ENUM(NSUInteger, WMCalendarUnit) {
    WMCalendarUnitMonth = NSCalendarUnitMonth,
    WMCalendarUnitWeekOfYear = NSCalendarUnitWeekOfYear,
    WMCalendarUnitDay = NSCalendarUnitDay
};

