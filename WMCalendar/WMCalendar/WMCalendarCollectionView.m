//
//  WMCalendarCollectionView.m
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import "WMCalendarCollectionView.h"

#import "WMCalendarExtensions.h"
#import "WMCalendarConstants.h"

@interface WMCalendarCollectionView ()

- (void)initialize;

@end

@implementation WMCalendarCollectionView

@synthesize scrollsToTop = _scrollsToTop, contentInset = _contentInset;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.scrollsToTop = NO;
    self.contentInset = UIEdgeInsetsZero;
    
#ifdef __IPHONE_9_0
    if ([self respondsToSelector:@selector(setSemanticContentAttribute:)]) {
        self.semanticContentAttribute = UISemanticContentAttributeForceLeftToRight;
    }
#endif
    
#ifdef __IPHONE_10_0
    SEL selector = NSSelectorFromString(@"setPrefetchingEnabled:");
    if (selector && [self respondsToSelector:selector]) {
        [self fs_performSelector:selector withObjects:@NO, nil];
    }
#endif
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    [super setContentInset:UIEdgeInsetsZero];
    if (contentInset.top) {
        self.contentOffset = CGPointMake(self.contentOffset.x, self.contentOffset.y+contentInset.top);
    }
}

- (void)setScrollsToTop:(BOOL)scrollsToTop
{
    [super setScrollsToTop:NO];
}

@end


@implementation WMCalendarSeparator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WMCalendarStandardSeparatorColor;
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    self.frame = layoutAttributes.frame;
}

@end



