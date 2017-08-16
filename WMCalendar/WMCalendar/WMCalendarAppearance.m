//
//  WMCalendarAppearance.m
//  WMCalendar
//
//  Created by zhanshu1 on 2017/8/15.
//  Copyright © 2017年 WU. All rights reserved.
//

#import "WMCalendarAppearance.h"
#import "WMCalendarDynamicHeader.h"
#import "WMCalendarExtensions.h"
#import "WMCalendar.h"
@interface WMCalendarAppearance ()

@property (weak  , nonatomic) WMCalendar *calendar;

@property (strong, nonatomic) NSMutableDictionary *backgroundColors;
@property (strong, nonatomic) NSMutableDictionary *titleColors;
@property (strong, nonatomic) NSMutableDictionary *subtitleColors;
@property (strong, nonatomic) NSMutableDictionary *borderColors;

@end
@implementation WMCalendarAppearance
-(instancetype)init{
    self=[super init];
    if(self){
        
        _titleFont=[UIFont systemFontOfSize:WMCalendarStandardTitleTextSize];
        _subtitleFont = [UIFont systemFontOfSize:WMCalendarStandardSubtitleTextSize];
        _weekdayFont = [UIFont systemFontOfSize:WMCalendarStandardWeekdayTextSize];
        _headerTitleFont = [UIFont systemFontOfSize:WMCalendarStandardHeaderTextSize];
        
        _headerTitleColor = WMCalendarStandardTitleTextColor;
        _headerDateFormat = @"MMMM yyyy";
        _headerMinimumDissolvedAlpha = 0.2;
        _weekdayTextColor = WMCalendarStandardTitleTextColor;
        _caseOptions = WMCalendarCaseOptionsHeaderUsesDefaultCase|WMCalendarCaseOptionsWeekdayUsesDefaultCase;
        
        
        _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _backgroundColors[@(WMCalendarCellStateNormal)]      = [UIColor clearColor];
        _backgroundColors[@(WMCalendarCellStateSelected)]    = WMCalendarStandardSelectionColor;
        _backgroundColors[@(WMCalendarCellStateDisabled)]    = [UIColor clearColor];
        _backgroundColors[@(WMCalendarCellStatePlaceholder)] = [UIColor clearColor];
        _backgroundColors[@(WMCalendarCellStateToday)]       = WMCalendarStandardTodayColor;
        
        _titleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _titleColors[@(WMCalendarCellStateNormal)]      = [UIColor blackColor];
        _titleColors[@(WMCalendarCellStateSelected)]    = [UIColor whiteColor];
        _titleColors[@(WMCalendarCellStateDisabled)]    = [UIColor grayColor];
        _titleColors[@(WMCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _titleColors[@(WMCalendarCellStateToday)]       = [UIColor whiteColor];
        
        
        _subtitleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _subtitleColors[@(WMCalendarCellStateNormal)]      = [UIColor darkGrayColor];
        _subtitleColors[@(WMCalendarCellStateSelected)]    = [UIColor whiteColor];
        _subtitleColors[@(WMCalendarCellStateDisabled)]    = [UIColor lightGrayColor];
        _subtitleColors[@(WMCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _subtitleColors[@(WMCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _borderColors = [NSMutableDictionary dictionaryWithCapacity:2];
        _borderColors[@(WMCalendarCellStateSelected)] = [UIColor clearColor];
        _borderColors[@(WMCalendarCellStateNormal)] = [UIColor clearColor];
        
        _borderRadius = 1.0;
        _eventDefaultColor = WMCalendarStandardEventDotColor;
        _eventSelectionColor = WMCalendarStandardEventDotColor;
        
#if TARGET_INTERFACE_BUILDER
        _fakeEventDots = YES;
#endif
    }
    return self;
}
- (void)setTitleFont:(UIFont *)titleFont
{
    if (![_titleFont isEqual:titleFont]) {
        _titleFont = titleFont;
        [self.calendar configureAppearance];
    }
}
- (void)setSubtitleFont:(UIFont *)subtitleFont
{
    if (![_subtitleFont isEqual:subtitleFont]) {
        _subtitleFont = subtitleFont;
        [self.calendar configureAppearance];
    }
}
- (void)setWeekdayFont:(UIFont *)weekdayFont
{
    if (![_weekdayFont isEqual:weekdayFont]) {
        _weekdayFont = weekdayFont;
        [self.calendar configureAppearance];
    }
}

- (void)setHeaderTitleFont:(UIFont *)headerTitleFont
{
    if (![_headerTitleFont isEqual:headerTitleFont]) {
        _headerTitleFont = headerTitleFont;
        [self.calendar configureAppearance];
    }
}

- (void)setTitleOffset:(CGPoint)titleOffset
{
    if (!CGPointEqualToPoint(_titleOffset, titleOffset)) {
        _titleOffset = titleOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}
- (void)setSubtitleOffset:(CGPoint)subtitleOffset
{
    if (!CGPointEqualToPoint(_subtitleOffset, subtitleOffset)) {
        _subtitleOffset = subtitleOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    if (!CGPointEqualToPoint(_imageOffset, imageOffset)) {
        _imageOffset = imageOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setEventOffset:(CGPoint)eventOffset
{
    if (!CGPointEqualToPoint(_eventOffset, eventOffset)) {
        _eventOffset = eventOffset;
        [_calendar.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}
- (void)setTitleDefaultColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(WMCalendarCellStateNormal)] = color;
    } else {
        [_titleColors removeObjectForKey:@(WMCalendarCellStateNormal)];
    }
    [self.calendar configureAppearance];
}
- (UIColor *)titleDefaultColor
{
    return _titleColors[@(WMCalendarCellStateNormal)];
}
- (void)setTitleSelectionColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(WMCalendarCellStateSelected)] = color;
    } else {
        [_titleColors removeObjectForKey:@(WMCalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titleSelectionColor
{
    return _titleColors[@(WMCalendarCellStateSelected)];
}
- (void)setTitleTodayColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(WMCalendarCellStateToday)] = color;
    } else {
        [_titleColors removeObjectForKey:@(WMCalendarCellStateToday)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titleTodayColor
{
    return _titleColors[@(WMCalendarCellStateToday)];
}
- (void)setTitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(WMCalendarCellStatePlaceholder)] = color;
    } else {
        [_titleColors removeObjectForKey:@(WMCalendarCellStatePlaceholder)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titlePlaceholderColor
{
    return _titleColors[@(WMCalendarCellStatePlaceholder)];
}
- (void)setTitleWeekendColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(WMCalendarCellStateWeekend)] = color;
    } else {
        [_titleColors removeObjectForKey:@(WMCalendarCellStateWeekend)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)titleWeekendColor
{
    return _titleColors[@(WMCalendarCellStateWeekend)];
}
- (void)setSubtitleDefaultColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(WMCalendarCellStateNormal)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(WMCalendarCellStateNormal)];
    }
    [self.calendar configureAppearance];
}

-(UIColor *)subtitleDefaultColor
{
    return _subtitleColors[@(WMCalendarCellStateNormal)];
}

- (void)setSubtitleSelectionColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(WMCalendarCellStateSelected)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(WMCalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitleSelectionColor
{
    return _subtitleColors[@(WMCalendarCellStateSelected)];
}
- (void)setSubtitleTodayColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(WMCalendarCellStateToday)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(WMCalendarCellStateToday)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitleTodayColor
{
    return _subtitleColors[@(WMCalendarCellStateToday)];
}

- (void)setSubtitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(WMCalendarCellStatePlaceholder)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(WMCalendarCellStatePlaceholder)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitlePlaceholderColor
{
    return _subtitleColors[@(WMCalendarCellStatePlaceholder)];
}
- (void)setSubtitleWeekendColor:(UIColor *)color
{
    if (color) {
        _subtitleColors[@(WMCalendarCellStateWeekend)] = color;
    } else {
        [_subtitleColors removeObjectForKey:@(WMCalendarCellStateWeekend)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)subtitleWeekendColor
{
    return _subtitleColors[@(WMCalendarCellStateWeekend)];
}

- (void)setSelectionColor:(UIColor *)color
{
    if (color) {
        _backgroundColors[@(WMCalendarCellStateSelected)] = color;
    } else {
        [_backgroundColors removeObjectForKey:@(WMCalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)selectionColor
{
    return _backgroundColors[@(WMCalendarCellStateSelected)];
}
- (void)setTodayColor:(UIColor *)todayColor
{
    if (todayColor) {
        _backgroundColors[@(WMCalendarCellStateToday)] = todayColor;
    } else {
        [_backgroundColors removeObjectForKey:@(WMCalendarCellStateToday)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)todayColor
{
    return _backgroundColors[@(WMCalendarCellStateToday)];
}

- (void)setTodaySelectionColor:(UIColor *)todaySelectionColor
{
    if (todaySelectionColor) {
        _backgroundColors[@(WMCalendarCellStateToday|WMCalendarCellStateSelected)] = todaySelectionColor;
    } else {
        [_backgroundColors removeObjectForKey:@(WMCalendarCellStateToday|WMCalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)todaySelectionColor
{
    return _backgroundColors[@(WMCalendarCellStateToday|WMCalendarCellStateSelected)];
}
- (void)setEventDefaultColor:(UIColor *)eventDefaultColor
{
    if (![_eventDefaultColor isEqual:eventDefaultColor]) {
        _eventDefaultColor = eventDefaultColor;
        [self.calendar configureAppearance];
    }
}

- (void)setBorderDefaultColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(WMCalendarCellStateNormal)] = color;
    } else {
        [_borderColors removeObjectForKey:@(WMCalendarCellStateNormal)];
    }
    [self.calendar configureAppearance];
}
- (UIColor *)borderDefaultColor
{
    return _borderColors[@(WMCalendarCellStateNormal)];
}

- (void)setBorderSelectionColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(WMCalendarCellStateSelected)] = color;
    } else {
        [_borderColors removeObjectForKey:@(WMCalendarCellStateSelected)];
    }
    [self.calendar configureAppearance];
}

- (UIColor *)borderSelectionColor
{
    return _borderColors[@(WMCalendarCellStateSelected)];
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    borderRadius = MAX(0.0, borderRadius);
    borderRadius = MIN(1.0, borderRadius);
    if (_borderRadius != borderRadius) {
        _borderRadius = borderRadius;
        [self.calendar configureAppearance];
    }
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor
{
    if (![_weekdayTextColor isEqual:weekdayTextColor]) {
        _weekdayTextColor = weekdayTextColor;
        [self.calendar configureAppearance];
    }
}

- (void)setHeaderTitleColor:(UIColor *)color
{
    if (![_headerTitleColor isEqual:color]) {
        _headerTitleColor = color;
        [self.calendar configureAppearance];
    }
}
- (void)setHeaderMinimumDissolvedAlpha:(CGFloat)headerMinimumDissolvedAlpha
{
    if (_headerMinimumDissolvedAlpha != headerMinimumDissolvedAlpha) {
        _headerMinimumDissolvedAlpha = headerMinimumDissolvedAlpha;
        [self.calendar configureAppearance];
    }
}

- (void)setHeaderDateFormat:(NSString *)headerDateFormat
{
    if (![_headerDateFormat isEqual:headerDateFormat]) {
        _headerDateFormat = headerDateFormat;
        [self.calendar configureAppearance];
    }
}

- (void)setCaseOptions:(WMCalendarCaseOptions)caseOptions
{
    if (_caseOptions != caseOptions) {
        _caseOptions = caseOptions;
        [self.calendar configureAppearance];
    }
}
- (void)setSeparators:(WMCalendarSeparators)separators
{
    if (_separators != separators) {
        _separators = separators;
        [_calendar.collectionView.collectionViewLayout invalidateLayout];
    }
}


@end
@implementation WMCalendarAppearance (Deprecated)

- (void)setUseVeryShortWeekdaySymbols:(BOOL)useVeryShortWeekdaySymbols
{
    
    _caseOptions &= 15;
    self.caseOptions |= (useVeryShortWeekdaySymbols*WMCalendarCaseOptionsWeekdayUsesSingleUpperCase);
}

- (BOOL)useVeryShortWeekdaySymbols
{
    return (_caseOptions & (15<<4) ) == WMCalendarCaseOptionsWeekdayUsesSingleUpperCase;
}

- (void)setTitleVerticalOffset:(CGFloat)titleVerticalOffset
{
    self.titleOffset = CGPointMake(0, titleVerticalOffset);
}

- (CGFloat)titleVerticalOffset
{
    return self.titleOffset.y;
}

- (void)setSubtitleVerticalOffset:(CGFloat)subtitleVerticalOffset
{
    self.subtitleOffset = CGPointMake(0, subtitleVerticalOffset);
}

- (CGFloat)subtitleVerticalOffset
{
    return self.subtitleOffset.y;
}

- (void)setEventColor:(UIColor *)eventColor
{
    self.eventDefaultColor = eventColor;
}

- (UIColor *)eventColor
{
    return self.eventDefaultColor;
}

- (void)setCellShape:(WMCalendarCellShape)cellShape
{
    self.borderRadius = 1-cellShape;
}

- (WMCalendarCellShape)cellShape
{
    return self.borderRadius==1.0?WMCalendarCellShapeCircle:WMCalendarCellShapeRectangle;
}

- (void)setTitleTextSize:(CGFloat)titleTextSize
{
    self.titleFont = [UIFont fontWithName:self.titleFont.fontName size:titleTextSize];
}

- (void)setSubtitleTextSize:(CGFloat)subtitleTextSize
{
    self.subtitleFont = [UIFont fontWithName:self.subtitleFont.fontName size:subtitleTextSize];
}

- (void)setWeekdayTextSize:(CGFloat)weekdayTextSize
{
    self.weekdayFont = [UIFont fontWithName:self.weekdayFont.fontName size:weekdayTextSize];
}

- (void)setHeaderTitleTextSize:(CGFloat)headerTitleTextSize
{
    self.headerTitleFont = [UIFont fontWithName:self.headerTitleFont.fontName size:headerTitleTextSize];
}

- (void)invalidateAppearance
{
    [self.calendar configureAppearance];
}

- (void)setAdjustsFontSizeToFitContentSize:(BOOL)adjustsFontSizeToFitContentSize {}
- (BOOL)adjustsFontSizeToFitContentSize { return YES; }

@end
