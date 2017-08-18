//
//  WMCalendarDynamicHeader.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "WMCalendar.h"
#import <Foundation/Foundation.h>

#import "WMCalendar.h"
#import "WMCalendarCell.h"
#import "WMCalendarHeaderView.h"
#import "WMCalendarStickyHeader.h"
#import "WMCalendarCollectionView.h"
#import "WMCalendarCollectionViewLayout.h"
#import "WMCalendarScopeHandle.h"
#import "WMCalendarCalculator.h"
#import "WMCalendarTransitionCoordinator.h"
#import "WMCalendarDelegationProxy.h"

@interface WMCalendar (Dynamic)

@property (readonly, nonatomic) WMCalendarCollectionView *collectionView;
@property (readonly, nonatomic) WMCalendarScopeHandle *scopeHandle;
@property (readonly, nonatomic) WMCalendarCollectionViewLayout *collectionViewLayout;
@property (readonly, nonatomic) WMCalendarTransitionCoordinator *transitionCoordinator;
@property (readonly, nonatomic) WMCalendarCalculator *calculator;
@property (readonly, nonatomic) BOOL floatingMode;
@property (readonly, nonatomic) NSArray *visibleStickyHeaders;
@property (readonly, nonatomic) CGFloat preferredHeaderHeight;
@property (readonly, nonatomic) CGFloat preferredWeekdayHeight;
@property (readonly, nonatomic) UIView *bottomBorder;

@property (readonly, nonatomic) NSCalendar *gregorian;
@property (readonly, nonatomic) NSDateComponents *components;
@property (readonly, nonatomic) NSDateFormatter *formatter;

@property (readonly, nonatomic) UIView *contentView;
@property (readonly, nonatomic) UIView *daysContainer;

@property (assign, nonatomic) BOOL needsAdjustingViewFrame;

- (void)invalidateHeaders;
- (void)adjustMonthPosition;
- (void)configureAppearance;

- (BOOL)isPageInRange:(NSDate *)page;
- (BOOL)isDateInRange:(NSDate *)date;

- (CGSize)sizeThatFits:(CGSize)size scope:(WMCalendarScope)scope;

@end

@interface WMCalendarAppearance (Dynamic)

@property (readwrite, nonatomic) WMCalendar *calendar;

@property (readonly, nonatomic) NSDictionary *backgroundColors;
@property (readonly, nonatomic) NSDictionary *titleColors;
@property (readonly, nonatomic) NSDictionary *subtitleColors;
@property (readonly, nonatomic) NSDictionary *borderColors;

@end

@interface WMCalendarWeekdayView (Dynamic)

@property (readwrite, nonatomic) WMCalendar *calendar;

@end

@interface WMCalendarCollectionViewLayout (Dynamic)

@property (readonly, nonatomic) CGSize estimatedItemSize;

@end

@interface WMCalendarDelegationProxy()<WMCalendarDataSource,WMCalendarDelegate,WMCalendarDelegateAppearance>
@end


