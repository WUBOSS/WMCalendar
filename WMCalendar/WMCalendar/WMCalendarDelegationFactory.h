//
//  WMCalendarDelegationFactory.h
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMCalendarDelegationProxy.h"
@interface WMCalendarDelegationFactory : NSObject
+ (WMCalendarDelegationProxy *)dataSourceProxy;
+ (WMCalendarDelegationProxy *)delegateProxy;

@end
