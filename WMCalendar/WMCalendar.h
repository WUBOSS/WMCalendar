//
//  WMCalendar.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/10.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMCalendarCell.h"
#import "WMCalendarConstants.h"
#import "WMCalendarAppearance.h"
#import "WMCalendarWeekdayView.h"
#import "WMCalendarHeaderView.h"
//项目版本号
FOUNDATION_EXPORT double WMCalendarVersionNumber;
//项目版本号字符串数组
FOUNDATION_EXPORT const unsigned char WMCalendarVersionString[];

//日历范围模式
typedef NS_ENUM(NSUInteger, WMCalendarScope) {
    WMCalendarScopeMonth, //显示一个月
    WMCalendarScopeWeek //显示一周
};
//日历滚动方向
typedef NS_ENUM(NSUInteger, WMCalendarScrollDirection) {
    WMCalendarScrollDirectionVertical, //垂直滚动
    WMCalendarScrollDirectionHorizontal//水平滚动
};
//日历占位模式
typedef NS_ENUM(NSUInteger, WMCalendarPlaceholderType) {
    WMCalendarPlaceholderTypeNone          = 0,
    WMCalendarPlaceholderTypeFillHeadTail  = 1,
    WMCalendarPlaceholderTypeFillSixRows   = 2 //六行显示
};
//日历的月份位置
typedef NS_ENUM(NSUInteger, WMCalendarMonthPosition) {
    WMCalendarMonthPositionPrevious, //上个月
    WMCalendarMonthPositionCurrent, //当前月份
    WMCalendarMonthPositionNext,//下个月
    
    WMCalendarMonthPositionNotFound = NSNotFound
};
//参数不为空
NS_ASSUME_NONNULL_BEGIN

@class WMCalendar;

//日历数据源代理
@protocol WMCalendarDataSource <NSObject>

@optional

/**
 * 该日期在日历上显示的标题文本
 */
- (nullable NSString *)calendar:(WMCalendar *)calendar titleForDate:(NSDate *)date;

/**
 * 该日期在日历上显示的子标题文本
 */
- (nullable NSString *)calendar:(WMCalendar *)calendar subtitleForDate:(NSDate *)date;

/**
 * 该日期在日历上显示的图片
 */
- (nullable UIImage *)calendar:(WMCalendar *)calendar imageForDate:(NSDate *)date;

/**
 * 该日历显示的最小日期
 */
- (NSDate *)minimumDateForCalendar:(WMCalendar *)calendar;

/**
 * 该日历显示的最大日期
 */
- (NSDate *)maximumDateForCalendar:(WMCalendar *)calendar;

/**
 * 该日期在日历上显示的cell
 */
- (__kindof WMCalendarCell *)calendar:(WMCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)position;

/**
 * 该日期事件个数
 */
- (NSInteger)calendar:(WMCalendar *)calendar numberOfEventsForDate:(NSDate *)date;

/**
 * This function is deprecated
 */
- (BOOL)calendar:(WMCalendar *)calendar hasEventForDate:(NSDate *)date WMCalendarDeprecated(-calendar:numberOfEventsForDate:);

@end

//日历代理
@protocol WMCalendarDelegate <NSObject>

@optional

/**
 是否允许日期选中
 */
- (BOOL)calendar:(WMCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)monthPosition;

/**
 日期被选中
 */
- (void)calendar:(WMCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)monthPosition;

/**
 是否允许日期被取消选中
 */
- (BOOL)calendar:(WMCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)monthPosition;

/**
 日期被取消选中
 */
- (void)calendar:(WMCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)monthPosition;


/**
 日历大小将要改变
 */
- (void)calendar:(WMCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated;

/**
    日期cell将要展示
 
 */
- (void)calendar:(WMCalendar *)calendar willDisplayCell:(WMCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)monthPosition;

/**
 日历当前页改变
 */
- (void)calendarCurrentPageDidChange:(WMCalendar *)calendar;

/**
 过期方法
 */
- (void)calendarCurrentScopeWillChange:(WMCalendar *)calendar animated:(BOOL)animated WMCalendarDeprecated(-calendar:boundingRectWillChange:animated:);
- (void)calendarCurrentMonthDidChange:(WMCalendar *)calendar WMCalendarDeprecated(-calendarCurrentPageDidChange:);
- (BOOL)calendar:(WMCalendar *)calendar shouldSelectDate:(NSDate *)date WMCalendarDeprecated(-calendar:shouldSelectDate:atMonthPosition:);
- (void)calendar:(WMCalendar *)calendar didSelectDate:(NSDate *)date WMCalendarDeprecated(-calendar:didSelectDate:atMonthPosition:);
- (BOOL)calendar:(WMCalendar *)calendar shouldDeselectDate:(NSDate *)date WMCalendarDeprecated(-calendar:shouldDeselectDate:atMonthPosition:);
- (void)calendar:(WMCalendar *)calendar didDeselectDate:(NSDate *)date WMCalendarDeprecated(-calendar:didDeselectDate:atMonthPosition:);

@end

/**
 * WMCalendarDelegateAppearance 确定了日期组件上的字体和颜色，如果你需要为特殊的日期特别的显示，请使用这个.
   全局的设置可以使用WMCalendarAppearance 
 *
 * @see WMCalendarAppearance
 */
@protocol WMCalendarDelegateAppearance <WMCalendarDelegate>

@optional

/**
 * 该日期的填充颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance fillDefaultColorForDate:(NSDate *)date;

/**
 * 该日期选中的填充颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date;

/**
 * 该日期默认标题颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date;

/**
 *该日期标题选中颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date;

/**
 * 该日期默认子标题颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance subtitleDefaultColorForDate:(NSDate *)date;

/**
 * 该日期子标题选中颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance subtitleSelectionColorForDate:(NSDate *)date;

/**
 * 该日期默认事件颜色
 */
- (nullable NSArray<UIColor *> *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date;

/**
 * 该日期事件选中颜色
 */
- (nullable NSArray<UIColor *> *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance eventSelectionColorsForDate:(NSDate *)date;

/**
 * 该日期默认边框颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date;

/**
 * 该日期默认边框选中颜色
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date;

/**
 * 该日期标题偏移量
 */
- (CGPoint)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance titleOffsetForDate:(NSDate *)date;

/**
 * 该日期子标题偏移量
 */
- (CGPoint)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance subtitleOffsetForDate:(NSDate *)date;

/**
 * 该日期图片偏移量
 */
- (CGPoint)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance imageOffsetForDate:(NSDate *)date;

/**
 * 该日期事件偏移量
 */
- (CGPoint)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance eventOffsetForDate:(NSDate *)date;


/**
 * 日期边框半径
 */
- (CGFloat)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance borderRadiusForDate:(NSDate *)date;

/**
 * 过期方法
 */
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance fillColorForDate:(NSDate *)date WMCalendarDeprecated(-calendar:appearance:fillDefaultColorForDate:);
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date WMCalendarDeprecated(-calendar:appearance:fillSelectionColorForDate:);
- (nullable UIColor *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance eventColorForDate:(NSDate *)date WMCalendarDeprecated(-calendar:appearance:eventDefaultColorsForDate:);
- (nullable NSArray *)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance eventColorsForDate:(NSDate *)date WMCalendarDeprecated(-calendar:appearance:eventDefaultColorsForDate:);
- (WMCalendarCellShape)calendar:(WMCalendar *)calendar appearance:(WMCalendarAppearance *)appearance cellShapeForDate:(NSDate *)date WMCalendarDeprecated(-calendar:appearance:borderRadiusForDate:);
@end


//xib文件可预览
IB_DESIGNABLE
@interface WMCalendar : UIView
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;//xib可预览该属性变化
/**
 * 日历代理
 */

@property (weak, nonatomic) IBOutlet id<WMCalendarDelegate> delegate;

/**
 * 日历数据源代理
 */
@property (weak, nonatomic) IBOutlet id<WMCalendarDataSource> dataSource;


/**
 * 今天有一个特殊的标记
 */
@property (nullable, strong, nonatomic) NSDate *today;

/**
 * 日历当前页
 *
 * week模式显示的是一周，month显示的是一个月
 */
@property (strong, nonatomic) NSDate *currentPage;

/**
 * weekday month 本地化 使用自己的语言
 *
 * e.g. 中国使用:
 *
 *    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
 */
@property (copy, nonatomic) NSLocale *locale;

/**
 * 日历的滚动方向
 *
 * e.g.垂直滚动
 *
 *    calendar.scrollDirection = WMCalendarScrollDirectionVertical;
 */
@property (assign, nonatomic) WMCalendarScrollDirection scrollDirection;

/**
 * scope改变会触发内部frame改变, 在
 *
 *    - (void)calendar:(WMCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated;确保你的界面调整
 */
@property (assign, nonatomic) WMCalendarScope scope;



/**
日期范围滑动事件vertical滚动无效
 
 @deprecated Use -handleScopeGesture: instead
 
 e.g.
 
 UIPanGestureRecognizer *scopeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:calendar action:@selector(handleScopeGesture:)];
 [calendar addGestureRecognizer:scopeGesture];
 
 @see DIYExample
 @see WMCalendarScopeExample
 */
@property (readonly, nonatomic) UIPanGestureRecognizer *scopeGesture WMCalendarDeprecated(handleScopeGesture:);



/**
 * 长按手势
 *
 * e.g.
 *
 *    calendar.swipeToChooseGesture.enabled = YES;
 */
@property (readonly, nonatomic) UILongPressGestureRecognizer *swipeToChooseGesture;


/**
 * 日历占位模式 默认 WMCalendarPlaceholderTypeFillSixRows.
 *
 * e.g.隐藏所有的占位
 *
 *    calendar.placeholderType = WMCalendarPlaceholderTypeNone;
 */
#if TARGET_INTERFACE_BUILDER
@property (assign, nonatomic) IBInspectable NSUInteger placeholderType;
#else
@property (assign, nonatomic) WMCalendarPlaceholderType placeholderType;
#endif

/**
 日历第一天索引，2从星期一开始
 */
@property (assign, nonatomic) IBInspectable NSUInteger firstWeekday;

/**
    日历头部显示的高度  如果0会移除头部.
 */
@property (assign, nonatomic) IBInspectable CGFloat headerHeight;

/**
    weekday的显示高度 
 */
@property (assign, nonatomic) IBInspectable CGFloat weekdayHeight;

/**
   日历的 WeekdayView
 */
@property (strong, nonatomic) WMCalendarWeekdayView *calendarWeekdayView;

/**
    日历的 header view
 */
@property (strong, nonatomic) WMCalendarHeaderView *calendarHeaderView;

/**
    是否允许用户选择日期
 */
@property (assign, nonatomic) IBInspectable BOOL allowsSelection;

/**
    是否允许用户多选.
 */
@property (assign, nonatomic) IBInspectable BOOL allowsMultipleSelection;

/**
    是否允许自动分页
 */
@property (assign, nonatomic) IBInspectable BOOL pagingEnabled;

/**
    是否可以滚动
 */
@property (assign, nonatomic) IBInspectable BOOL scrollEnabled;


@property (assign, nonatomic) IBInspectable BOOL showsScopeHandle WMCalendarDeprecated(handleScopeGesture:);

/**
    paging enabled 是 NO.的行高;
 */
@property (assign, nonatomic) IBInspectable CGFloat rowHeight;

/**
 字体颜色配置
 */
@property (readonly, nonatomic) WMCalendarAppearance *appearance;

/**
展示的最小日期
 */
@property (readonly, nonatomic) NSDate *minimumDate;

/**
 展示的最大日期
 */
@property (readonly, nonatomic) NSDate *maximumDate;

/**
 选中的日期
 */
@property (nullable, readonly, nonatomic) NSDate *selectedDate;

/**
 选择的日期数组
 */
@property (readonly, nonatomic) NSArray<NSDate *> *selectedDates;

/**
 刷新日历
 */
- (void)reloadData;

/**
 改变日历scope  会触发`-calendar:boundingRectWillChange:animated`
 */
- (void)setScope:(WMCalendarScope)scope animated:(BOOL)animated;

/**
 选中某个日期
 @param  date 日历的一个日期
 */
- (void)selectDate:(nullable NSDate *)date;

/**
 选中日期是否跳到这个日期
 
 @param date 日历的一个日期
 @param scrollToDate YES会跳到那个日期.
 */
- (void)selectDate:(nullable NSDate *)date scrollToDate:(BOOL)scrollToDate;

/**
 
 取消选中日期
 @param date 日历的一个日期
 */
- (void)deselectDate:(NSDate *)date;

/**
 设置当前日期页
 
 @param currentPage 日历的一个日期
 @param animated YES会跳到那个日期.
 */
- (void)setCurrentPage:(NSDate *)currentPage animated:(BOOL)animated;

/**
 为日历cell注册类
 
 @param cellClass 显示的cell类
 @param identifier 重用标记
 */
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

/**
 用标记重用cell
 
 @param identifier 重用标记
 @param date cell的日期.
 @return WMCalendarCell.
 */
- (__kindof WMCalendarCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)position;

/**
 返回日期对应的cell
 
 @param date cell的日期.
 @param position 月份的方向
 @return WMCalendarCell
 */
- (nullable WMCalendarCell *)cellForDate:(NSDate *)date atMonthPosition:(WMCalendarMonthPosition)position;


/**
 Returns cell的日期.
 
 @param cell 选择的cell.
 @return cell的日期.
 */
- (nullable NSDate *)dateForCell:(WMCalendarCell *)cell;

/**
 Returns WMCalendarMonthPosition
 
 @param cell 选择的cell
 @return cell的WMCalendarMonthPosition.
 */
- (WMCalendarMonthPosition)monthPositionForCell:(WMCalendarCell *)cell;


/**
 Returns 日历上显示的cell
 
 @return 日历上显示的cell 如果没有返回空
 */
- (NSArray<__kindof WMCalendarCell *> *)visibleCells;

/**
 Returns 日期对应的frame
 
 @param date A date is the calendar.
 */
- (CGRect)frameForDate:(NSDate *)date;

/**
 添加轻扫手势
 
 @param sender A UIPanGestureRecognizer instance which controls the scope of the calendar
 */
- (void)handleScopeGesture:(UIPanGestureRecognizer *)sender;


@end
IB_DESIGNABLE
@interface WMCalendar (IBExtension)

#if TARGET_INTERFACE_BUILDER

@property (assign, nonatomic) IBInspectable CGFloat  titleTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  subtitleTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  weekdayTextSize;
@property (assign, nonatomic) IBInspectable CGFloat  headerTitleTextSize;

@property (strong, nonatomic) IBInspectable UIColor  *eventDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *eventSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *weekdayTextColor;

@property (strong, nonatomic) IBInspectable UIColor  *headerTitleColor;
@property (strong, nonatomic) IBInspectable NSString *headerDateFormat;
@property (assign, nonatomic) IBInspectable CGFloat  headerMinimumDissolvedAlpha;

@property (strong, nonatomic) IBInspectable UIColor  *titleDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleTodayColor;
@property (strong, nonatomic) IBInspectable UIColor  *titlePlaceholderColor;
@property (strong, nonatomic) IBInspectable UIColor  *titleWeekendColor;

@property (strong, nonatomic) IBInspectable UIColor  *subtitleDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleSelectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleTodayColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitlePlaceholderColor;
@property (strong, nonatomic) IBInspectable UIColor  *subtitleWeekendColor;

@property (strong, nonatomic) IBInspectable UIColor  *selectionColor;
@property (strong, nonatomic) IBInspectable UIColor  *todayColor;
@property (strong, nonatomic) IBInspectable UIColor  *todaySelectionColor;

@property (strong, nonatomic) IBInspectable UIColor *borderDefaultColor;
@property (strong, nonatomic) IBInspectable UIColor *borderSelectionColor;

@property (assign, nonatomic) IBInspectable CGFloat borderRadius;
@property (assign, nonatomic) IBInspectable BOOL    useVeryShortWeekdaySymbols;

@property (assign, nonatomic) IBInspectable BOOL      fakeSubtitles;
@property (assign, nonatomic) IBInspectable BOOL      fakeEventDots;
@property (assign, nonatomic) IBInspectable NSInteger fakedSelectedDay;

#endif

@end
#pragma mark - Deprecate

@interface WMCalendar (Deprecated)
@property (assign, nonatomic) CGFloat lineHeightMultiplier WMCalendarDeprecated(rowHeight);
@property (assign, nonatomic) IBInspectable BOOL showsPlaceholders WMCalendarDeprecated('placeholderType');
@property (strong, nonatomic) NSString *identifier DEPRECATED_MSG_ATTRIBUTE("Changing calendar identifier is NOT RECOMMENDED. ");

// Use NSCalendar.
- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day WMCalendarDeprecated([NSDateFormatter dateFromString:]);
- (NSInteger)yearOfDate:(NSDate *)date WMCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)monthOfDate:(NSDate *)date WMCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)dayOfDate:(NSDate *)date WMCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)weekdayOfDate:(NSDate *)date WMCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSInteger)weekOfDate:(NSDate *)date WMCalendarDeprecated(NSCalendar component:fromDate:]);
- (NSDate *)dateByAddingYears:(NSInteger)years toDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingYears:(NSInteger)years fromDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateByAddingMonths:(NSInteger)months toDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingMonths:(NSInteger)months fromDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks toDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingWeeks:(NSInteger)weeks fromDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateByAddingDays:(NSInteger)days toDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (NSDate *)dateBySubstractingDays:(NSInteger)days fromDate:(NSDate *)date WMCalendarDeprecated([NSCalendar dateByAddingUnit:value:toDate:options:]);
- (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toCalendarUnit:(WMCalendarUnit)unit WMCalendarDeprecated([NSCalendar -isDate:equalToDate:toUnitGranularity:]);
- (BOOL)isDateInToday:(NSDate *)date WMCalendarDeprecated([NSCalendar -isDateInToday:]);


@end



NS_ASSUME_NONNULL_END
