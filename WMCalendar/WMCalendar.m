//
//  WMCalendar.m
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/10.
//  Copyright © 2017年 WU. All rights reserved.
//

#import "WMCalendar.h"
#import "WMCalendarDynamicHeader.h"
#import "WMCalendarExtensions.h"
#import "WMCalendarDelegationFactory.h"

typedef NS_ENUM(NSUInteger, WMCalendarOrientation) {
    WMCalendarOrientationLandscape,
    WMCalendarOrientationPortrait
};
@interface WMCalendar ()<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray  *_selectedDates;
}

@property (strong, nonatomic) NSCalendar *gregorian;
@property (strong, nonatomic) NSDateComponents *components;
@property (strong, nonatomic) NSDateFormatter *formatter;
@property (strong, nonatomic) NSTimeZone *timeZone;


@property (assign, nonatomic) BOOL                       needsAdjustingViewFrame;

@property (assign, nonatomic) BOOL                       needsRequestingBoundingDates;
@property (assign, nonatomic) WMCalendarOrientation      orientation;

@property (assign, nonatomic) CGFloat                    preferredHeaderHeight;
@property (assign, nonatomic) CGFloat                    preferredWeekdayHeight;
@property (assign, nonatomic) CGFloat                    preferredRowHeight;

@property (readonly, nonatomic) WMCalendarOrientation currentCalendarOrientation;
@property (strong, nonatomic) WMCalendarDelegationProxy  *dataSourceProxy;
@property (strong, nonatomic) WMCalendarDelegationProxy  *delegateProxy;


@property (strong, nonatomic) NSMapTable *visibleSectionHeaders;
@end
@implementation WMCalendar
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    _appearance = [[WMCalendarAppearance alloc] init];
    _appearance.calendar = self;
    _gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _components = [[NSDateComponents alloc] init];
    _formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = @"yyyy-MM-dd";
    _locale = [NSLocale currentLocale];
    _timeZone = [NSTimeZone localTimeZone];
    _firstWeekday = 1;
    [self invalidateDateTools];
    _today = [self.gregorian dateBySettingHour:0 minute:0 second:0 ofDate:[NSDate date] options:0];
    _currentPage = [self.gregorian fs_firstDayOfMonth:_today];
    
    
    _minimumDate = [self.formatter dateFromString:@"1970-01-01"];
    _maximumDate = [self.formatter dateFromString:@"2099-12-31"];
    _headerHeight     = WMCalendarAutomaticDimension;
    _weekdayHeight    = WMCalendarAutomaticDimension;

    _rowHeight      = WMCalendarStandardRowHeight*MAX(1, FSCalendarDeviceIsIPad*1.5);
    
    _preferredHeaderHeight  = WMCalendarAutomaticDimension;
    _preferredWeekdayHeight = WMCalendarAutomaticDimension;
    _preferredRowHeight     = WMCalendarAutomaticDimension;
    
    _scrollDirection = WMCalendarScrollDirectionHorizontal;
    _scope = WMCalendarScopeMonth;
    _selectedDates = [NSMutableArray arrayWithCapacity:1];
    _visibleSectionHeaders = [NSMapTable weakToWeakObjectsMapTable];
    _pagingEnabled = YES;
    _scrollEnabled = YES;
    _needsAdjustingViewFrame = YES;
    _needsRequestingBoundingDates = YES;
    _orientation = self.currentCalendarOrientation;
    _placeholderType = WMCalendarPlaceholderTypeFillSixRows;
    _dataSourceProxy = [WMCalendarDelegationFactory dataSourceProxy];
    _delegateProxy = [WMCalendarDelegationFactory delegateProxy];

    
    
}
- (void)invalidateDateTools
{
    _gregorian.locale = _locale;
    _gregorian.timeZone = _timeZone;
    _gregorian.firstWeekday = _firstWeekday;
    _components.calendar = _gregorian;
    _components.timeZone = _timeZone;
    _formatter.calendar = _gregorian;
    _formatter.timeZone = _timeZone;
    _formatter.locale = _locale;
}
- (WMCalendarOrientation)currentCalendarOrientation
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize nativeSize = [UIScreen mainScreen].currentMode.size;
    CGSize sizeInPoints = [UIScreen mainScreen].bounds.size;
    WMCalendarOrientation orientation = scale * sizeInPoints.width == nativeSize.width ? WMCalendarOrientationPortrait : WMCalendarOrientationLandscape;
    return orientation;
}

@end
