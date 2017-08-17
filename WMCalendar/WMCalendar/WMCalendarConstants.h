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


UIKIT_EXTERN NSString * const WMCalendarDefaultCellReuseIdentifier;
UIKIT_EXTERN NSString * const WMCalendarBlankCellReuseIdentifier;

#if TARGET_INTERFACE_BUILDER
#define WMCalendarDeviceIsIPad NO
#else
#define WMCalendarDeviceIsIPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#endif

#define WMCalendarStandardSelectionColor   WMColorRGBA(31,119,219,1.0)
#define WMCalendarStandardTodayColor       WMColorRGBA(198,51,42 ,1.0)
#define WMCalendarStandardTitleTextColor   WMColorRGBA(14,69,221 ,1.0)
#define WMCalendarStandardEventDotColor    WMColorRGBA(31,119,219,0.75)

#define WMColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define WMCalendarDeprecated(instead) DEPRECATED_MSG_ATTRIBUTE(" Use " # instead " instead")
#define WMCalendarInAppExtension [[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]

#define WMCalendarStandardLineColor        [[UIColor lightGrayColor] colorWithAlphaComponent:0.30]

#define WMCalendarStandardScopeHandleColor [[UIColor lightGrayColor] colorWithAlphaComponent:0.50]
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
CGPoint const CGPointInfinity = {
    .x =  CGFLOAT_MAX,
    .y =  CGFLOAT_MAX
};

