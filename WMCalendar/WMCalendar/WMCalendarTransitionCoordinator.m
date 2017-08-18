//
//  WMCalendarTransitionCoordinator.m
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/16.
//  Copyright © 2017年 WU. All rights reserved.
//

#import "WMCalendarTransitionCoordinator.h"

#import "WMCalendarExtensions.h"
#import "WMCalendarDynamicHeader.h"
#import <objc/runtime.h>

@interface WMCalendarTransitionCoordinator ()

@property (readonly, nonatomic) WMCalendarTransitionAttributes *transitionAttributes;
@property (strong  , nonatomic) WMCalendarTransitionAttributes *pendingAttributes;
@property (assign  , nonatomic) CGFloat lastTranslation;

- (void)performTransitionCompletionAnimated:(BOOL)animated;
- (void)performTransitionCompletion:(WMCalendarTransition)transition animated:(BOOL)animated;

- (void)performAlphaAnimationFrom:(CGFloat)fromAlpha to:(CGFloat)toAlpha duration:(CGFloat)duration exception:(NSInteger)exception completion:(void(^)())completion;
- (void)performForwardTransition:(WMCalendarTransition)transition fromProgress:(CGFloat)progress;
- (void)performBackwardTransition:(WMCalendarTransition)transition fromProgress:(CGFloat)progress;
- (void)performAlphaAnimationWithProgress:(CGFloat)progress;
- (void)performPathAnimationWithProgress:(CGFloat)progress;

- (void)scopeTransitionDidBegin:(UIPanGestureRecognizer *)panGesture;
- (void)scopeTransitionDidUpdate:(UIPanGestureRecognizer *)panGesture;
- (void)scopeTransitionDidEnd:(UIPanGestureRecognizer *)panGesture;

- (CGRect)boundingRectForScope:(WMCalendarScope)scope page:(NSDate *)page;

- (void)boundingRectWillChange:(CGRect)targetBounds animated:(BOOL)animated;

@end

@implementation WMCalendarTransitionCoordinator

- (instancetype)initWithCalendar:(WMCalendar *)calendar
{
    self = [super init];
    if (self) {
        self.calendar = calendar;
        self.collectionView = self.calendar.collectionView;
        self.collectionViewLayout = self.calendar.collectionViewLayout;
    }
    return self;
}

#pragma mark - Target actions

- (void)handleScopeGesture:(UIPanGestureRecognizer *)sender
{
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            [self scopeTransitionDidBegin:sender];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self scopeTransitionDidUpdate:sender];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self scopeTransitionDidEnd:sender];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            [self scopeTransitionDidEnd:sender];
            break;
        }
        case UIGestureRecognizerStateFailed: {
            [self scopeTransitionDidEnd:sender];
            break;
        }
        default: {
            break;
        }
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.state != WMCalendarTransitionStateIdle) {
        return NO;
    }
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    
    if (gestureRecognizer == self.calendar.scopeGesture && self.calendar.collectionViewLayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        return NO;
    }
    if (gestureRecognizer == self.calendar.scopeHandle.panGesture) {
        CGFloat velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view].y;
        return self.calendar.scope == WMCalendarScopeWeek ? velocity >= 0 : velocity <= 0;
    }
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [[gestureRecognizer valueForKey:@"_targets"] containsObject:self.calendar]) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        BOOL shouldStart = self.calendar.scope == WMCalendarScopeWeek ? velocity.y >= 0 : velocity.y <= 0;
        if (!shouldStart) return NO;
        shouldStart = (ABS(velocity.x)<=ABS(velocity.y));
        if (shouldStart) {
            self.calendar.collectionView.panGestureRecognizer.enabled = NO;
            self.calendar.collectionView.panGestureRecognizer.enabled = YES;
        }
        return shouldStart;
    }
    return YES;
    
#pragma GCC diagnostic pop
    
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return otherGestureRecognizer == self.collectionView.panGestureRecognizer && self.collectionView.decelerating;
}

- (void)scopeTransitionDidBegin:(UIPanGestureRecognizer *)panGesture
{
    if (self.state != WMCalendarTransitionStateIdle) return;
    
    CGPoint velocity = [panGesture velocityInView:panGesture.view];
    switch (self.calendar.scope) {
        case WMCalendarScopeMonth: {
            if (velocity.y < 0) {
                self.state = WMCalendarTransitionStateChanging;
                self.transition = WMCalendarTransitionMonthToWeek;
            }
            break;
        }
        case WMCalendarScopeWeek: {
            if (velocity.y > 0) {
                self.state = WMCalendarTransitionStateChanging;
                self.transition = WMCalendarTransitionWeekToMonth;
            }
            break;
        }
        default:
            break;
    }
    if (self.state != WMCalendarTransitionStateChanging) return;
    
    self.pendingAttributes = self.transitionAttributes;
    self.lastTranslation = [panGesture translationInView:panGesture.view].y;
    
    if (self.transition == WMCalendarTransitionWeekToMonth) {
        [self.calendar fs_setVariable:self.pendingAttributes.targetPage forKey:@"_currentPage"];
        [self prelayoutForWeekToMonthTransition];
        self.collectionView.fs_top = -self.pendingAttributes.focusedRowNumber*self.calendar.collectionViewLayout.estimatedItemSize.height;
        
    }
}

- (void)scopeTransitionDidUpdate:(UIPanGestureRecognizer *)panGesture
{
    if (self.state != WMCalendarTransitionStateChanging) return;
    
    CGFloat translation = [panGesture translationInView:panGesture.view].y;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    switch (self.transition) {
        case WMCalendarTransitionMonthToWeek: {
            CGFloat progress = ({
                CGFloat minTranslation = CGRectGetHeight(self.pendingAttributes.targetBounds) - CGRectGetHeight(self.pendingAttributes.sourceBounds);
                translation = MAX(minTranslation, translation);
                translation = MIN(0, translation);
                CGFloat progress = translation/minTranslation;
                progress;
            });
            [self performAlphaAnimationWithProgress:progress];
            [self performPathAnimationWithProgress:progress];
            break;
        }
        case WMCalendarTransitionWeekToMonth: {
            CGFloat progress = ({
                CGFloat maxTranslation = CGRectGetHeight(self.pendingAttributes.targetBounds) - CGRectGetHeight(self.pendingAttributes.sourceBounds);
                translation = MIN(maxTranslation, translation);
                translation = MAX(0, translation);
                CGFloat progress = translation/maxTranslation;
                progress;
            });
            [self performAlphaAnimationWithProgress:progress];
            [self performPathAnimationWithProgress:progress];
            break;
        }
        default:
            break;
    }
    [CATransaction commit];
    self.lastTranslation = translation;
}

- (void)scopeTransitionDidEnd:(UIPanGestureRecognizer *)panGesture
{
    if (self.state != WMCalendarTransitionStateChanging) return;
    
    self.state = WMCalendarTransitionStateFinishing;
    
    CGFloat translation = [panGesture translationInView:panGesture.view].y;
    CGFloat velocity = [panGesture velocityInView:panGesture.view].y;
    
    switch (self.transition) {
        case WMCalendarTransitionMonthToWeek: {
            CGFloat progress = ({
                CGFloat minTranslation = CGRectGetHeight(self.pendingAttributes.targetBounds) - CGRectGetHeight(self.pendingAttributes.sourceBounds);
                translation = MAX(minTranslation, translation);
                translation = MIN(0, translation);
                CGFloat progress = translation/minTranslation;
                progress;
            });
            if (velocity >= 0) {
                [self performBackwardTransition:self.transition fromProgress:progress];
            } else {
                [self performForwardTransition:self.transition fromProgress:progress];
            }
            break;
        }
        case WMCalendarTransitionWeekToMonth: {
            CGFloat progress = ({
                CGFloat maxTranslation = CGRectGetHeight(self.pendingAttributes.targetBounds) - CGRectGetHeight(self.pendingAttributes.sourceBounds);
                translation = MAX(0, translation);
                translation = MIN(maxTranslation, translation);
                CGFloat progress = translation/maxTranslation;
                progress;
            });
            if (velocity >= 0) {
                [self performForwardTransition:self.transition fromProgress:progress];
            } else {
                [self performBackwardTransition:self.transition fromProgress:progress];
            }
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - Public methods

- (void)performScopeTransitionFromScope:(WMCalendarScope)fromScope toScope:(WMCalendarScope)toScope animated:(BOOL)animated
{
    if (fromScope == toScope) return;
    
    self.transition = ({
        WMCalendarTransition transition = WMCalendarTransitionNone;
        if (fromScope == WMCalendarScopeMonth && toScope == WMCalendarScopeWeek) {
            transition = WMCalendarTransitionMonthToWeek;
        } else if (fromScope == WMCalendarScopeWeek && toScope == WMCalendarScopeMonth) {
            transition = WMCalendarTransitionWeekToMonth;
        }
        transition;
    });
    
    // Start transition
    self.state = WMCalendarTransitionStateFinishing;
    WMCalendarTransitionAttributes *attr = self.transitionAttributes;
    self.pendingAttributes = attr;
    
    switch (self.transition) {
            
        case WMCalendarTransitionMonthToWeek: {
            
            [self.calendar fs_setVariable:attr.targetPage forKey:@"_currentPage"];
            self.calendar.contentView.clipsToBounds = YES;
            
            if (animated) {
                CGFloat duration = 0.3;
                
                [self performAlphaAnimationFrom:1 to:0 duration:0.22 exception:attr.focusedRowNumber completion:^{
                    [self performTransitionCompletionAnimated:animated];
                }];
                
                if (self.calendar.delegate && ([self.calendar.delegate respondsToSelector:@selector(calendar:boundingRectWillChange:animated:)] || [self.calendar.delegate respondsToSelector:@selector(calendarCurrentScopeWillChange:animated:)])) {
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationsEnabled:YES];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationDuration:duration];
                    self.collectionView.fs_top = -attr.focusedRowNumber*self.calendar.collectionViewLayout.estimatedItemSize.height;
                    [self boundingRectWillChange:attr.targetBounds animated:animated];
                    [UIView commitAnimations];
                }
                
            } else {
                
                [self performTransitionCompletionAnimated:animated];
                [self boundingRectWillChange:attr.targetBounds animated:animated];
                
            }
            
            break;
        }
            
        case WMCalendarTransitionWeekToMonth: {
            
            [self.calendar fs_setVariable:attr.targetPage forKey:@"_currentPage"];
            
            [self prelayoutForWeekToMonthTransition];
            
            if (animated) {
                
                CGFloat duration = 0.3;
                
                [self performAlphaAnimationFrom:0 to:1 duration:duration exception:attr.focusedRowNumber completion:^{
                    [self performTransitionCompletionAnimated:animated];
                }];
                
                [CATransaction begin];
                [CATransaction setDisableActions:NO];
                if (self.calendar.delegate && ([self.calendar.delegate respondsToSelector:@selector(calendar:boundingRectWillChange:animated:)] || [self.calendar.delegate respondsToSelector:@selector(calendarCurrentScopeWillChange:animated:)])) {
                    self.collectionView.fs_top = -attr.focusedRowNumber*self.calendar.collectionViewLayout.estimatedItemSize.height;
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationsEnabled:YES];
                    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                    [UIView setAnimationDuration:duration];
                    self.collectionView.fs_top = 0;
                    [self boundingRectWillChange:attr.targetBounds animated:animated];
                    [UIView commitAnimations];
                }
                [CATransaction commit];
                
            } else {
                
                [self performTransitionCompletionAnimated:animated];
                [self boundingRectWillChange:attr.targetBounds animated:animated];
                
            }
            break;
        }
        default:
            break;
    }
    
}

- (void)performBoundingRectTransitionFromMonth:(NSDate *)fromMonth toMonth:(NSDate *)toMonth duration:(CGFloat)duration
{
    if (self.calendar.scope != WMCalendarScopeMonth) return;
    NSInteger lastRowCount = [self.calendar.calculator numberOfRowsInMonth:fromMonth];
    NSInteger currentRowCount = [self.calendar.calculator numberOfRowsInMonth:toMonth];
    if (lastRowCount != currentRowCount) {
        CGFloat animationDuration = duration;
        CGRect bounds = (CGRect){CGPointZero,[self.calendar sizeThatFits:self.calendar.frame.size scope:WMCalendarScopeMonth]};
        self.state = WMCalendarTransitionStateChanging;
        void (^completion)(BOOL) = ^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX(0, duration-animationDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.calendar.needsAdjustingViewFrame = YES;
                [self.calendar setNeedsLayout];
                self.state = WMCalendarTransitionStateIdle;
            });
        };
        if (WMCalendarInAppExtension) {
            // Detect today extension: http://stackoverflow.com/questions/25048026/ios-8-extension-how-to-detect-running
            [self boundingRectWillChange:bounds animated:YES];
            completion(YES);
        } else {
            [UIView animateWithDuration:animationDuration delay:0  options:UIViewAnimationOptionAllowUserInteraction animations:^{
                [self boundingRectWillChange:bounds animated:YES];
            } completion:completion];
        }
        
    }
}

#pragma mark - Private properties

- (void)performTransitionCompletionAnimated:(BOOL)animated
{
    [self performTransitionCompletion:self.transition animated:animated];
}

- (void)performTransitionCompletion:(WMCalendarTransition)transition animated:(BOOL)animated
{
    switch (transition) {
        case WMCalendarTransitionMonthToWeek: {
            [self.calendar.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *obj, NSUInteger idx, BOOL * stop) {
                obj.contentView.layer.opacity = 1;
            }];
            self.collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            self.calendar.calendarHeaderView.scrollDirection = self.collectionViewLayout.scrollDirection;
            self.calendar.needsAdjustingViewFrame = YES;
            [self.collectionView reloadData];
            [self.calendar.calendarHeaderView reloadData];
            break;
        }
        case WMCalendarTransitionWeekToMonth: {
            self.calendar.needsAdjustingViewFrame = YES;
            [self.calendar.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell *obj, NSUInteger idx, BOOL * stop) {
                [CATransaction begin];
                [CATransaction setDisableActions:YES];
                obj.contentView.layer.opacity = 1;
                [CATransaction commit];
                [obj.contentView.layer removeAnimationForKey:@"opacity"];
            }];
            break;
        }
        default:
            break;
    }
    self.state = WMCalendarTransitionStateIdle;
    self.transition = WMCalendarTransitionNone;
    self.calendar.contentView.clipsToBounds = NO;
    self.pendingAttributes = nil;
    [self.calendar setNeedsLayout];
    [self.calendar layoutIfNeeded];
}

- (WMCalendarTransitionAttributes *)transitionAttributes
{
    WMCalendarTransitionAttributes *attributes = [[WMCalendarTransitionAttributes alloc] init];
    attributes.sourceBounds = self.calendar.bounds;
    attributes.sourcePage = self.calendar.currentPage;
    switch (self.transition) {
            
        case WMCalendarTransitionMonthToWeek: {
            
            NSDate *focusedDate = ({
                NSArray<NSDate *> *candidates = ({
                    NSMutableArray *dates = self.calendar.selectedDates.reverseObjectEnumerator.allObjects.mutableCopy;
                    if (self.calendar.today) {
                        [dates addObject:self.calendar.today];
                    }
                    if (self.calendar.currentPage) {
                        [dates addObject:self.calendar.currentPage];
                    }
                    dates.copy;
                });
                NSArray<NSDate *> *visibleCandidates = [candidates filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDate *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    NSIndexPath *indexPath = [self.calendar.calculator indexPathForDate:evaluatedObject scope:WMCalendarScopeMonth];
                    NSInteger currentSection = [self.calendar.calculator indexPathForDate:self.calendar.currentPage scope:WMCalendarScopeMonth].section;
                    return indexPath.section == currentSection;
                }]];
                NSDate *date = visibleCandidates.firstObject;
                date;
            });
            NSInteger focusedRow = [self.calendar.calculator coordinateForIndexPath:[self.calendar.calculator indexPathForDate:focusedDate scope:WMCalendarScopeMonth]].row;
            
            NSDate *currentPage = self.calendar.currentPage;
            NSIndexPath *indexPath = [self.calendar.calculator indexPathForDate:currentPage scope:WMCalendarScopeMonth];
            NSDate *monthHead = [self.calendar.calculator monthHeadForSection:indexPath.section];
            NSDate *targetPage = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitDay value:focusedRow*7 toDate:monthHead options:0];
            
            attributes.focusedRowNumber = focusedRow;
            attributes.focusedDate = focusedDate;
            attributes.targetPage = targetPage;
            attributes.targetBounds = [self boundingRectForScope:WMCalendarScopeWeek page:attributes.targetPage];
            
            break;
        }
        case WMCalendarTransitionWeekToMonth: {
            
            NSInteger focusedRow = 0;
            NSDate *currentPage = self.calendar.currentPage;
            
            NSDate *focusedDate = ({
                NSArray<NSDate *> *candidates = ({
                    NSMutableArray *dates = self.calendar.selectedDates.reverseObjectEnumerator.allObjects.mutableCopy;
                    if (self.calendar.today) {
                        [dates addObject:self.calendar.today];
                    }
                    if (self.calendar.currentPage) {
                        [dates addObject:[self.calendar.gregorian fs_lastDayOfWeek:currentPage]];
                    }
                    dates.copy;
                });
                NSArray<NSDate *> *visibleCandidates = [candidates filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSDate *  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    NSIndexPath *indexPath = [self.calendar.calculator indexPathForDate:evaluatedObject scope:WMCalendarScopeWeek];
                    NSInteger currentSection = [self.calendar.calculator indexPathForDate:self.calendar.currentPage scope:WMCalendarScopeWeek].section;
                    return indexPath.section == currentSection;
                }]];
                NSDate *date = visibleCandidates.firstObject;
                date;
            });
            
            NSDate *firstDayOfMonth = [self.calendar.gregorian fs_firstDayOfMonth:focusedDate];
            attributes.focusedDate = focusedDate;
            firstDayOfMonth = firstDayOfMonth ?: [self.calendar.gregorian fs_firstDayOfMonth:currentPage];
            NSInteger numberOfPlaceholdersForPrev = [self.calendar.calculator numberOfHeadPlaceholdersForMonth:firstDayOfMonth];
            NSDate *firstDateOfPage = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitDay value:-numberOfPlaceholdersForPrev toDate:firstDayOfMonth options:0];
            
            for (int i = 0; i < 6; i++) {
                NSDate *currentRow = [self.calendar.gregorian dateByAddingUnit:NSCalendarUnitWeekOfYear value:i toDate:firstDateOfPage options:0];
                if ([self.calendar.gregorian isDate:currentRow inSameDayAsDate:currentPage]) {
                    focusedRow = i;
                    currentPage = firstDayOfMonth;
                    break;
                }
            }
            attributes.focusedRowNumber = focusedRow;
            attributes.targetPage = currentPage;
            attributes.firstDayOfMonth = firstDayOfMonth;
            
            attributes.targetBounds = [self boundingRectForScope:WMCalendarScopeMonth page:attributes.targetPage];
            
            break;
        }
        default:
            break;
    }
    return attributes;
}

#pragma mark - Private properties

- (WMCalendarScope)representingScope
{
    switch (self.state) {
        case WMCalendarTransitionStateIdle: {
            return self.calendar.scope;
        }
        case WMCalendarTransitionStateChanging:
        case WMCalendarTransitionStateFinishing: {
            return WMCalendarScopeMonth;
        }
    }
}

#pragma mark - Private methods

- (CGRect)boundingRectForScope:(WMCalendarScope)scope page:(NSDate *)page
{
    CGSize contentSize;
    switch (scope) {
        case WMCalendarScopeMonth: {
            if (self.calendar.placeholderType == WMCalendarPlaceholderTypeFillSixRows) {
                contentSize = self.cachedMonthSize;
            } else {
                CGFloat padding = self.calendar.collectionViewLayout.sectionInsets.top + self.calendar.collectionViewLayout.sectionInsets.bottom;
                contentSize = CGSizeMake(self.calendar.fs_width,
                                         self.calendar.preferredHeaderHeight+
                                         self.calendar.preferredWeekdayHeight+
                                         ([self.calendar.calculator numberOfRowsInMonth:page]*self.calendar.collectionViewLayout.estimatedItemSize.height)+
                                         self.calendar.scopeHandle.fs_height+padding);
            }
            break;
        }
        case WMCalendarScopeWeek: {
            contentSize = [self.calendar sizeThatFits:self.calendar.frame.size scope:scope];
            break;
        }
    }
    return (CGRect){CGPointZero,contentSize};
}

- (void)boundingRectWillChange:(CGRect)targetBounds animated:(BOOL)animated
{
    self.calendar.scopeHandle.fs_bottom = CGRectGetMaxY(targetBounds);
    self.calendar.contentView.fs_height = CGRectGetHeight(targetBounds)-self.calendar.scopeHandle.fs_height;
    self.calendar.daysContainer.fs_height = CGRectGetHeight(targetBounds)-self.calendar.preferredHeaderHeight-self.calendar.preferredWeekdayHeight-self.calendar.scopeHandle.fs_height;
    [[self.calendar valueForKey:@"delegateProxy"] calendar:self.calendar boundingRectWillChange:targetBounds animated:animated];
}

- (void)performForwardTransition:(WMCalendarTransition)transition fromProgress:(CGFloat)progress
{
    WMCalendarTransitionAttributes *attr = self.pendingAttributes;
    switch (transition) {
        case WMCalendarTransitionMonthToWeek: {
            
            [self.calendar willChangeValueForKey:@"scope"];
            [self.calendar fs_setUnsignedIntegerVariable:WMCalendarScopeWeek forKey:@"_scope"];
            [self.calendar didChangeValueForKey:@"scope"];
            
            [self.calendar fs_setVariable:attr.targetPage forKey:@"_currentPage"];
            
            self.calendar.contentView.clipsToBounds = YES;
            
            CGFloat currentAlpha = MAX(1-progress*1.1,0);
            CGFloat duration = 0.3;
            [self performAlphaAnimationFrom:currentAlpha to:0 duration:0.22 exception:attr.focusedRowNumber completion:^{
                [self performTransitionCompletionAnimated:YES];
            }];
            
            if (self.calendar.delegate && ([self.calendar.delegate respondsToSelector:@selector(calendar:boundingRectWillChange:animated:)] || [self.calendar.delegate respondsToSelector:@selector(calendarCurrentScopeWillChange:animated:)])) {
                [UIView beginAnimations:@"delegateTranslation" context:"translation"];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:duration];
                self.collectionView.fs_top = -attr.focusedRowNumber*self.calendar.collectionViewLayout.estimatedItemSize.height;
                [self boundingRectWillChange:attr.targetBounds animated:YES];
                [UIView commitAnimations];
            }
            
            break;
        }
        case WMCalendarTransitionWeekToMonth: {
            
            [self.calendar willChangeValueForKey:@"scope"];
            [self.calendar fs_setUnsignedIntegerVariable:WMCalendarScopeMonth forKey:@"_scope"];
            [self.calendar didChangeValueForKey:@"scope"];
            
            [self performAlphaAnimationFrom:progress to:1 duration:0.4 exception:attr.focusedRowNumber completion:^{
                [self performTransitionCompletionAnimated:YES];
            }];
            
            CGFloat duration = 0.3;
            [CATransaction begin];
            [CATransaction setDisableActions:NO];
            
            if (self.calendar.delegate && ([self.calendar.delegate respondsToSelector:@selector(calendar:boundingRectWillChange:animated:)] || [self.calendar.delegate respondsToSelector:@selector(calendarCurrentScopeWillChange:animated:)])) {
                [UIView beginAnimations:@"delegateTranslation" context:"translation"];
                [UIView setAnimationsEnabled:YES];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:duration];
                self.collectionView.fs_top = 0;
                [self boundingRectWillChange:attr.targetBounds animated:YES];
                [UIView commitAnimations];
            }
            [CATransaction commit];
            break;
        }
        default:
            break;
    }
}

- (void)performBackwardTransition:(WMCalendarTransition)transition fromProgress:(CGFloat)progress
{
    switch (transition) {
        case WMCalendarTransitionMonthToWeek: {
            
            [self.calendar willChangeValueForKey:@"scope"];
            [self.calendar fs_setUnsignedIntegerVariable:WMCalendarScopeMonth forKey:@"_scope"];
            [self.calendar didChangeValueForKey:@"scope"];
            
            [self performAlphaAnimationFrom:MAX(1-progress*1.1,0) to:1 duration:0.3 exception:self.pendingAttributes.focusedRowNumber completion:^{
                [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.contentView.layer.opacity = 1;
                    [obj.contentView.layer removeAnimationForKey:@"opacity"];
                }];
                self.pendingAttributes = nil;
                self.state = WMCalendarTransitionStateIdle;
            }];
            
            if (self.calendar.delegate && ([self.calendar.delegate respondsToSelector:@selector(calendar:boundingRectWillChange:animated:)] || [self.calendar.delegate respondsToSelector:@selector(calendarCurrentScopeWillChange:animated:)])) {
                [UIView beginAnimations:@"delegateTranslation" context:"translation"];
                [UIView setAnimationsEnabled:YES];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                self.collectionView.fs_top = 0;
                [self boundingRectWillChange:self.pendingAttributes.sourceBounds animated:YES];
                [UIView commitAnimations];
            }
            break;
        }
        case WMCalendarTransitionWeekToMonth: {
            
            [self.calendar willChangeValueForKey:@"scope"];
            [self.calendar fs_setUnsignedIntegerVariable:WMCalendarScopeWeek forKey:@"_scope"];
            [self.calendar didChangeValueForKey:@"scope"];
            
            [self performAlphaAnimationFrom:progress to:0 duration:0.3 exception:self.pendingAttributes.focusedRowNumber completion:^{
                [self.calendar fs_setVariable:self.pendingAttributes.sourcePage forKey:@"_currentPage"];
                [self performTransitionCompletion:WMCalendarTransitionMonthToWeek animated:YES];
            }];
            
            if (self.calendar.delegate && ([self.calendar.delegate respondsToSelector:@selector(calendar:boundingRectWillChange:animated:)] || [self.calendar.delegate respondsToSelector:@selector(calendarCurrentScopeWillChange:animated:)])) {
                [UIView beginAnimations:@"delegateTranslation" context:"translation"];
                [UIView setAnimationsEnabled:YES];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [UIView setAnimationDuration:0.3];
                self.collectionView.fs_top = (-self.pendingAttributes.focusedRowNumber*self.calendar.collectionViewLayout.estimatedItemSize.height);
                [self boundingRectWillChange:self.pendingAttributes.sourceBounds animated:YES];
                [UIView commitAnimations];
            }
            break;
        }
        default:
            break;
    }
}

- (void)performAlphaAnimationFrom:(CGFloat)fromAlpha to:(CGFloat)toAlpha duration:(CGFloat)duration exception:(NSInteger)exception completion:(void(^)())completion;
{
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(WMCalendarCell *cell, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(self.collectionView.bounds, cell.center)) {
            BOOL shouldPerformAlpha = NO;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            NSInteger row = [self.calendar.calculator coordinateForIndexPath:indexPath].row;
            shouldPerformAlpha = row != exception;
            if (shouldPerformAlpha) {
                CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
                opacity.duration = duration;
                opacity.fromValue = @(fromAlpha);
                opacity.toValue = @(toAlpha);
                opacity.removedOnCompletion = NO;
                opacity.fillMode = kCAFillModeForwards;
                [cell.contentView.layer addAnimation:opacity forKey:@"opacity"];
            }
        }
    }];
    if (completion) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion();
        });
    }
}

- (void)performAlphaAnimationWithProgress:(CGFloat)progress
{
    CGFloat opacity = self.transition == WMCalendarTransitionMonthToWeek ? MAX((1-progress*1.1),0) : progress;
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(WMCalendarCell *cell, NSUInteger idx, BOOL *stop) {
        if (CGRectContainsPoint(self.collectionView.bounds, cell.center)) {
            BOOL shouldPerformAlpha = NO;
            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
            NSInteger row = [self.calendar.calculator coordinateForIndexPath:indexPath].row;
            shouldPerformAlpha = row != self.pendingAttributes.focusedRowNumber;
            if (shouldPerformAlpha) {
                cell.contentView.layer.opacity = opacity;
            }
        }
    }];
}

- (void)performPathAnimationWithProgress:(CGFloat)progress
{
    CGFloat targetHeight = CGRectGetHeight(self.pendingAttributes.targetBounds);
    CGFloat sourceHeight = CGRectGetHeight(self.pendingAttributes.sourceBounds);
    CGFloat currentHeight = sourceHeight - (sourceHeight-targetHeight)*progress - self.calendar.scopeHandle.fs_height;
    CGRect currentBounds = CGRectMake(0, 0, CGRectGetWidth(self.pendingAttributes.targetBounds), currentHeight+self.calendar.scopeHandle.fs_height);
    self.collectionView.fs_top = (-self.pendingAttributes.focusedRowNumber*self.calendar.collectionViewLayout.estimatedItemSize.height)*(self.transition == WMCalendarTransitionMonthToWeek?progress:(1-progress));
    [self boundingRectWillChange:currentBounds animated:NO];
    if (self.transition == WMCalendarTransitionWeekToMonth) {
        self.calendar.contentView.fs_height = targetHeight;
    }
}


- (void)prelayoutForWeekToMonthTransition
{
    self.calendar.contentView.clipsToBounds = YES;
    self.calendar.contentView.fs_height = CGRectGetHeight(self.pendingAttributes.targetBounds)-self.calendar.scopeHandle.fs_height;
    self.collectionViewLayout.scrollDirection = (UICollectionViewScrollDirection)self.calendar.scrollDirection;
    self.calendar.calendarHeaderView.scrollDirection = self.collectionViewLayout.scrollDirection;
    self.calendar.needsAdjustingViewFrame = YES;
    [self.calendar setNeedsLayout];
    [self.collectionView reloadData];
    [self.calendar.calendarHeaderView reloadData];
    [self.calendar layoutIfNeeded];
}

@end

@implementation WMCalendarTransitionAttributes


@end
