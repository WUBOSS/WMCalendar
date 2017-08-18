//
//  WMCalendarTransitionCoordinator.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMCalendar.h"
#import "WMCalendarCollectionView.h"
#import "WMCalendarCollectionViewLayout.h"
#import "WMCalendarScopeHandle.h"

typedef NS_ENUM(NSUInteger, WMCalendarTransition) {
    WMCalendarTransitionNone,
    WMCalendarTransitionMonthToWeek,
    WMCalendarTransitionWeekToMonth
};
typedef NS_ENUM(NSUInteger, WMCalendarTransitionState) {
    WMCalendarTransitionStateIdle,
    WMCalendarTransitionStateChanging,
    WMCalendarTransitionStateFinishing,
};

@interface WMCalendarTransitionCoordinator : NSObject <UIGestureRecognizerDelegate>

@property (weak, nonatomic) WMCalendar *calendar;
@property (weak, nonatomic) WMCalendarCollectionView *collectionView;
@property (weak, nonatomic) WMCalendarCollectionViewLayout *collectionViewLayout;

@property (assign, nonatomic) WMCalendarTransition transition;
@property (assign, nonatomic) WMCalendarTransitionState state;

@property (assign, nonatomic) CGSize cachedMonthSize;

@property (readonly, nonatomic) WMCalendarScope representingScope;

- (instancetype)initWithCalendar:(WMCalendar *)calendar;

- (void)performScopeTransitionFromScope:(WMCalendarScope)fromScope toScope:(WMCalendarScope)toScope animated:(BOOL)animated;
- (void)performBoundingRectTransitionFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth duration:(CGFloat)duration;

- (void)handleScopeGesture:(id)sender;

@end


@interface WMCalendarTransitionAttributes : NSObject

@property (assign, nonatomic) CGRect sourceBounds;
@property (assign, nonatomic) CGRect targetBounds;
@property (strong, nonatomic) NSDate *sourcePage;
@property (strong, nonatomic) NSDate *targetPage;
@property (assign, nonatomic) NSInteger focusedRowNumber;
@property (assign, nonatomic) NSDate *focusedDate;
@property (strong, nonatomic) NSDate *firstDayOfMonth;

@end
