//
//  WMCalendarCollectionViewLayout.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WMCalendar;
@interface WMCalendarCollectionViewLayout : UICollectionViewLayout
@property (weak, nonatomic) WMCalendar *calendar;

@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) UIEdgeInsets sectionInsets;
@property (assign, nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (assign, nonatomic) CGSize headerReferenceSize;
@end
