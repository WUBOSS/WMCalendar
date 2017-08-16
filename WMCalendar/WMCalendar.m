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
#import "WMCalendarCollectionViewLayout.h"
#import "WMCalendarCollectionView.h"
#import "WMCalendarCell.h"
#import "WMCalendarConstants.h"
#import "WMCalendarStickyHeader.h"
#import "WMCalendarCalculator.h"
#import "WMCalendarTransitionCoordinator.h"
#import "WMCalendarScopeHandle.h"
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


@property (weak  , nonatomic) UIView                     *contentView;
@property (weak  , nonatomic) UIView                     *daysContainer;
@property (weak  , nonatomic) UIView                     *topBorder;
@property (weak  , nonatomic) UIView                     *bottomBorder;

@property (weak  , nonatomic) WMCalendarCollectionView   *collectionView;
@property (weak  , nonatomic) WMCalendarCollectionViewLayout *collectionViewLayout;
@property (weak  , nonatomic) WMCalendarScopeHandle      *scopeHandle;

@property (strong, nonatomic) WMCalendarTransitionCoordinator *transitionCoordinator;
@property (strong, nonatomic) WMCalendarCalculator       *calculator;
@property (weak  , nonatomic) WMCalendarHeaderTouchDeliver *deliver;

@property (assign, nonatomic) BOOL                       needsAdjustingViewFrame;

@property (assign, nonatomic) BOOL                       needsRequestingBoundingDates;
@property (assign, nonatomic) WMCalendarOrientation      orientation;

@property (assign, nonatomic) CGFloat                    preferredHeaderHeight;
@property (assign, nonatomic) CGFloat                    preferredWeekdayHeight;
@property (assign, nonatomic) CGFloat                    preferredRowHeight;

@property (readonly, nonatomic) BOOL floatingMode;

@property (readonly, nonatomic) WMCalendarOrientation currentCalendarOrientation;
@property (strong, nonatomic) WMCalendarDelegationProxy  *dataSourceProxy;
@property (strong, nonatomic) WMCalendarDelegationProxy  *delegateProxy;


@property (strong, nonatomic) NSMapTable *visibleSectionHeaders;


- (void)configureAppearan;
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

    _rowHeight      = WMCalendarStandardRowHeight*MAX(1,WMCalendarDeviceIsIPad*1.5);
    
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

    UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:contentView];
    self.contentView = contentView;
    
    
    UIView *daysContainer = [[UIView alloc] initWithFrame:CGRectZero];
    daysContainer.backgroundColor = [UIColor clearColor];
    daysContainer.clipsToBounds = YES;
    [contentView addSubview:daysContainer];
    self.daysContainer = daysContainer;
    
    WMCalendarCollectionViewLayout *collectionViewLayout = [[WMCalendarCollectionViewLayout alloc] init];
    collectionViewLayout.calendar = self;
    
    
   WMCalendarCollectionView *collectionView = [[WMCalendarCollectionView alloc] initWithFrame:CGRectZero
                                                                          collectionViewLayout:collectionViewLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.allowsMultipleSelection = NO;
    collectionView.clipsToBounds = YES;
    [collectionView registerClass:[WMCalendarCell class] forCellWithReuseIdentifier:WMCalendarDefaultCellReuseIdentifier];
    [collectionView registerClass:[WMCalendarBlankCell class] forCellWithReuseIdentifier:WMCalendarBlankCellReuseIdentifier];
    [collectionView registerClass:[WMCalendarStickyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"placeholderHeader"];
    [daysContainer addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionViewLayout = collectionViewLayout;
    
    
    if (!WMCalendarInAppExtension) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = WMCalendarStandardLineColor;
        view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin; // Stick to top
        [self addSubview:view];
        self.topBorder = view;
        
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = WMCalendarStandardLineColor;
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin; // Stick to bottom
        [self addSubview:view];
        self.bottomBorder = view;
        
    }
     [self invalidateLayout];
    
    
    self.transitionCoordinator = [[WMCalendarTransitionCoordinator alloc] initWithCalendar:self];
    self.calculator = [[WMCalendarCalculator alloc] initWithCalendar:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}
- (void)invalidateLayout
{
    if (!self.floatingMode) {
        
        if (!_calendarHeaderView) {
            
           WMCalendarHeaderView *headerView = [[WMCalendarHeaderView alloc] initWithFrame:CGRectZero];
            headerView.calendar = self;
            headerView.scrollEnabled = _scrollEnabled;
            [_contentView addSubview:headerView];
            self.calendarHeaderView = headerView;
            
        }
        
        if (!_calendarWeekdayView) {
           WMCalendarWeekdayView *calendarWeekdayView = [[WMCalendarWeekdayView alloc] initWithFrame:CGRectZero];
            calendarWeekdayView.calendar = self;
            [_contentView addSubview:calendarWeekdayView];
            _calendarWeekdayView = calendarWeekdayView;
        }
        
        if (_scrollEnabled) {
            if (!_deliver) {
               WMCalendarHeaderTouchDeliver *deliver = [[WMCalendarHeaderTouchDeliver alloc] initWithFrame:CGRectZero];
                deliver.header = _calendarHeaderView;
                deliver.calendar = self;
                [_contentView addSubview:deliver];
                self.deliver = deliver;
            }
        } else if (_deliver) {
            [_deliver removeFromSuperview];
        }
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        if (self.showsScopeHandle) {
            if (!_scopeHandle) {
               WMCalendarScopeHandle *handle = [[WMCalendarScopeHandle alloc] initWithFrame:CGRectZero];
                handle.calendar = self;
                [self addSubview:handle];
                self.scopeHandle = handle;
                _needsAdjustingViewFrame = YES;
                [self setNeedsLayout];
            }
        } else {
            if (_scopeHandle) {
                [self.scopeHandle removeFromSuperview];
                _needsAdjustingViewFrame = YES;
                [self setNeedsLayout];
            }
        }
#pragma GCC diagnostic pop
        
        _collectionView.pagingEnabled = YES;
        _collectionViewLayout.scrollDirection = (UICollectionViewScrollDirection)self.scrollDirection;
        
    } else {
        
        [self.calendarHeaderView removeFromSuperview];
        [self.deliver removeFromSuperview];
        [self.calendarWeekdayView removeFromSuperview];
        [self.scopeHandle removeFromSuperview];
        
        _collectionView.pagingEnabled = NO;
        _collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    }
    
    _preferredHeaderHeight =WMCalendarAutomaticDimension;
    _preferredWeekdayHeight =WMCalendarAutomaticDimension;
    _preferredRowHeight =WMCalendarAutomaticDimension;
    _needsAdjustingViewFrame = YES;
    [self setNeedsLayout];
}

- (void)orientationDidChange:(NSNotification *)notification
{
    self.orientation = self.currentCalendarOrientation;
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

- (void)setOrientation:(WMCalendarOrientation)orientation
{
    if (_orientation != orientation) {
        _orientation = orientation;
        
        _needsAdjustingViewFrame = YES;
        _preferredWeekdayHeight = WMCalendarAutomaticDimension;
        _preferredRowHeight = WMCalendarAutomaticDimension;
        _preferredHeaderHeight = WMCalendarAutomaticDimension;
        _calendarHeaderView.needsAdjustingMonthPosition = YES;
        _calendarHeaderView.needsAdjustingViewFrame = YES;
        [self setNeedsLayout];
    }
}

- (BOOL)floatingMode
{
    return _scope == WMCalendarScopeMonth && _scrollEnabled && !_pagingEnabled;
}

- (void)configureAppearance
{
    
}

@end
