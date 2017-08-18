//
//  WMCalendarHeaderView.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMCalendar, WMCalendarAppearance, WMCalendarHeaderLayout, WMCalendarCollectionView;

@interface WMCalendarHeaderView : UIView

@property (weak, nonatomic) WMCalendarCollectionView *collectionView;
@property (weak, nonatomic) WMCalendarHeaderLayout *collectionViewLayout;
@property (weak, nonatomic) WMCalendar *calendar;

@property (assign, nonatomic) CGFloat scrollOffset;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) BOOL scrollEnabled;
@property (assign, nonatomic) BOOL needsAdjustingViewFrame;
@property (assign, nonatomic) BOOL needsAdjustingMonthPosition;

- (void)setScrollOffset:(CGFloat)scrollOffset animated:(BOOL)animated;
- (void)reloadData;
- (void)configureAppearance;

@end


@interface WMCalendarHeaderCell : UICollectionViewCell

@property (weak, nonatomic) UILabel *titleLabel;
@property (weak, nonatomic) WMCalendarHeaderView *header;

@end

@interface WMCalendarHeaderLayout : UICollectionViewFlowLayout

@end

@interface WMCalendarHeaderTouchDeliver : UIView

@property (weak, nonatomic) WMCalendar *calendar;
@property (weak, nonatomic) WMCalendarHeaderView *header;

@end
