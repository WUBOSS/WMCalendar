//
//  WMCalendarDelegationProxy.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMCalendar.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMCalendarDelegationProxy : NSProxy
@property (weak  , nonatomic) id delegation;
@property (strong, nonatomic) Protocol *protocol;
@property (strong, nonatomic) NSDictionary<NSString *,NSString *> *deprecations;

- (instancetype)init;
- (SEL)deprecatedSelectorOfSelector:(SEL)selector;

@end
NS_ASSUME_NONNULL_END
