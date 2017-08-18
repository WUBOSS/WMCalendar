//
//  WMCalendarConstants.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - Constants

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

UIKIT_EXTERN NSInteger const WMCalendarDefaultHourComponent;

UIKIT_EXTERN NSString * const WMCalendarDefaultCellReuseIdentifier;
UIKIT_EXTERN NSString * const WMCalendarBlankCellReuseIdentifier;
UIKIT_EXTERN NSString * const WMCalendarInvalidArgumentsExceptionName;

CG_EXTERN CGPoint const CGPointInfinity;
CG_EXTERN CGSize const CGSizeAutomatic;

#if TARGET_INTERFACE_BUILDER
#define WMCalendarDeviceIsIPad NO
#else
#define WMCalendarDeviceIsIPad [[UIDevice currentDevice].model hasPrefix:@"iPad"]
#endif

#define WMCalendarStandardSelectionColor   FSColorRGBA(31,119,219,1.0)
#define WMCalendarStandardTodayColor       FSColorRGBA(198,51,42 ,1.0)
#define WMCalendarStandardTitleTextColor   FSColorRGBA(14,69,221 ,1.0)
#define WMCalendarStandardEventDotColor    FSColorRGBA(31,119,219,0.75)

#define WMCalendarStandardLineColor        [[UIColor lightGrayColor] colorWithAlphaComponent:0.30]
#define WMCalendarStandardSeparatorColor   [[UIColor lightGrayColor] colorWithAlphaComponent:0.60]
#define WMCalendarStandardScopeHandleColor [[UIColor lightGrayColor] colorWithAlphaComponent:0.50]

#define FSColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define WMCalendarInAppExtension [[[NSBundle mainBundle] bundlePath] hasSuffix:@".appex"]

#define WMCalendarFloor(c) floorf(c)
#define WMCalendarRound(c) roundf(c)
#define WMCalendarCeil(c) ceilf(c)
#define WMCalendarMod(c1,c2) fmodf(c1,c2)

#define WMCalendarHalfRound(c) (WMCalendarRound(c*2)*0.5)
#define WMCalendarHalfFloor(c) (WMCalendarFloor(c*2)*0.5)
#define WMCalendarHalfCeil(c) (WMCalendarCeil(c*2)*0.5)

#define WMCalendarUseWeakSelf __weak __typeof__(self) WMCalendarWeakSelf = self;
#define WMCalendarUseStrongSelf __strong __typeof__(self) self = WMCalendarWeakSelf;


#pragma mark - Deprecated

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

static inline void WMCalendarSliceCake(CGFloat cake, NSInteger count, CGFloat *pieces) {
    CGFloat total = cake;
    for (int i = 0; i < count; i++) {
        NSInteger remains = count - i;
        CGFloat piece = WMCalendarRound(total/remains*2)*0.5;
        total -= piece;
        pieces[i] = piece;
    }
}
