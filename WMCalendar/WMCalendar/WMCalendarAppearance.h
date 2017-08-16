//
//  WMCalendarAppearance.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMCalendarConstants.h"
#import <UIKit/UIKit.h>
@class WMCalendar;
//日期cell状态
typedef NS_ENUM(NSInteger, WMCalendarCellState) {
    WMCalendarCellStateNormal      = 0,
    WMCalendarCellStateSelected    = 1,
    WMCalendarCellStatePlaceholder = 1 << 1,
    WMCalendarCellStateDisabled    = 1 << 2,
    WMCalendarCellStateToday       = 1 << 3,
    WMCalendarCellStateWeekend     = 1 << 4,
    WMCalendarCellStateTodaySelected = WMCalendarCellStateToday|WMCalendarCellStateSelected
};

typedef NS_ENUM(NSUInteger, WMCalendarSeparators) {
    WMCalendarSeparatorNone          = 0,
    WMCalendarSeparatorInterRows     = 1
};

typedef NS_OPTIONS(NSUInteger, WMCalendarCaseOptions) {
    WMCalendarCaseOptionsHeaderUsesDefaultCase      = 0,
    WMCalendarCaseOptionsHeaderUsesUpperCase        = 1,
    
    WMCalendarCaseOptionsWeekdayUsesDefaultCase     = 0 << 4,
    WMCalendarCaseOptionsWeekdayUsesUpperCase       = 1 << 4,
    WMCalendarCaseOptionsWeekdayUsesSingleUpperCase = 2 << 4,
};

@interface WMCalendarAppearance : NSObject
/**
 * 标题字体
 */
@property (strong, nonatomic) UIFont   *titleFont;

/**
 * 子标题字体
 */
@property (strong, nonatomic) UIFont   *subtitleFont;

/**
 * weekday 字体
 */
@property (strong, nonatomic) UIFont   *weekdayFont;

/**
 * 月份字体
 */
@property (strong, nonatomic) UIFont   *headerTitleFont;

/**
 * 标题字体偏移
 */
@property (assign, nonatomic) CGPoint  titleOffset;

/**
 * 子标题字体偏移
 */
@property (assign, nonatomic) CGPoint  subtitleOffset;

/**
 * 事件偏移
 */
@property (assign, nonatomic) CGPoint eventOffset;

/**
 * 图片偏移
 */
@property (assign, nonatomic) CGPoint imageOffset;

/**
 * 事件点的.颜色
 */
@property (strong, nonatomic) UIColor  *eventDefaultColor;

/**
 * 事件点选中的颜色
 */
@property (strong, nonatomic) UIColor  *eventSelectionColor;

/**
 * weekday 字体颜色
 */
@property (strong, nonatomic) UIColor  *weekdayTextColor;

/**
 * 头部月份标题颜色
 */
@property (strong, nonatomic) UIColor  *headerTitleColor;

/**
 * 头部日期格式 yyyy-MM-dd
 */
@property (strong, nonatomic) NSString *headerDateFormat;

/**
 * 月份边缘透明度
 */
@property (assign, nonatomic) CGFloat  headerMinimumDissolvedAlpha;

/**
 * 日期默认标题颜色
 */
@property (strong, nonatomic) UIColor  *titleDefaultColor;

/**
 * 日期标题选中颜色
 */
@property (strong, nonatomic) UIColor  *titleSelectionColor;

/**
 * 今天日期字体颜色
 */
@property (strong, nonatomic) UIColor  *titleTodayColor;

/**
 * 不是当前月份的标题颜色
 */
@property (strong, nonatomic) UIColor  *titlePlaceholderColor;

/**
 * 周末标题字体颜色
 */
@property (strong, nonatomic) UIColor  *titleWeekendColor;

/**
 * 子标题默认颜色
 */
@property (strong, nonatomic) UIColor  *subtitleDefaultColor;

/**
 * 子标题选中颜色
 */
@property (strong, nonatomic) UIColor  *subtitleSelectionColor;

/**
 * 今天子标题 颜色
 */
@property (strong, nonatomic) UIColor  *subtitleTodayColor;

/**
 * 不是当前月份子标题颜色
 */
@property (strong, nonatomic) UIColor  *subtitlePlaceholderColor;

/**
 * 周末子标题颜色
 */
@property (strong, nonatomic) UIColor  *subtitleWeekendColor;

/**
 * 选中填充颜色
 */
@property (strong, nonatomic) UIColor  *selectionColor;

/**
 * 今天填充颜色
 */
@property (strong, nonatomic) UIColor  *todayColor;

/**
 * 今天选中填充颜色
 */
@property (strong, nonatomic) UIColor  *todaySelectionColor;

/**
 * 默认边框颜色
 */
@property (strong, nonatomic) UIColor  *borderDefaultColor;

/**
 * 默认边框选中颜色
 */
@property (strong, nonatomic) UIColor  *borderSelectionColor;

/**
 * 边框半径 1是圆 0是矩形 中间值是是一个弧度
 */
@property (assign, nonatomic) CGFloat borderRadius;

/**
 * weekday样式 月份样式
 *
 * @see WMCalendarCaseOptions
 */
@property (assign, nonatomic) WMCalendarCaseOptions caseOptions;

/**
 * 日历分割样式
 *
 */
@property (assign, nonatomic) WMCalendarSeparators separators;

#if TARGET_INTERFACE_BUILDER

// For preview only
@property (assign, nonatomic) BOOL      fakeSubtitles;
@property (assign, nonatomic) BOOL      fakeEventDots;
@property (assign, nonatomic) NSInteger fakedSelectedDay;

#endif

@end

/**
 * These functions and attributes are deprecated.
 */
@interface WMCalendarAppearance (Deprecated)

@property (assign, nonatomic) BOOL useVeryShortWeekdaySymbols WMCalendarDeprecated('caseOptions');
@property (assign, nonatomic) CGFloat titleVerticalOffset WMCalendarDeprecated('titleOffset');
@property (assign, nonatomic) CGFloat subtitleVerticalOffset WMCalendarDeprecated('subtitleOffset');
@property (strong, nonatomic) UIColor *eventColor WMCalendarDeprecated('eventDefaultColor');
@property (assign, nonatomic) WMCalendarCellShape cellShape WMCalendarDeprecated('borderRadius');
@property (assign, nonatomic) BOOL adjustsFontSizeToFitContentSize DEPRECATED_MSG_ATTRIBUTE("The attribute \'adjustsFontSizeToFitContentSize\' is not neccesary anymore.");
- (void)invalidateAppearance WMCalendarDeprecated('WMCalendar setNeedsConfigureAppearance');

@end
