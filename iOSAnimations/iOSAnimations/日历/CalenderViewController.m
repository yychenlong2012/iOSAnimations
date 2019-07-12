//
//  CalenderViewController.m
//  合集
//
//  Created by goat on 2018/3/28.
//  Copyright © 2018年 goat. All rights reserved.
//

#import "CalenderViewController.h"
#import <FSCalendar.h>
#import "UIColor+Hex.h"

@interface CalenderViewController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance>
@property (nonatomic,strong) FSCalendar *calendar;
@property (nonatomic,strong) NSDate *todayMonth;
@end

@implementation CalenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.calendar];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.calendar setCurrentPage:self.todayMonth animated:YES];
    
}

//上一月按钮点击事件
- (void)previousClicked:(id)sender {
    
//    NSDate *currentMonth = self.calendar.currentPage;
//    NSDate *previousMonth = [self.calendar dateBySubstractingMonths:1 fromDate:currentMonth];
//    [self.calendar setCurrentPage:previousMonth animated:YES];
}

//下一月按钮点击事件
- (void)nextClicked:(id)sender {
    
//    NSDate *currentMonth = self.calendar.currentPage;
//    NSDate *nextMonth = [self.calendar dateByAddingMonths:1 toDate:currentMonth];
//    [self.calendar setCurrentPage:nextMonth animated:YES];
}

#pragma mark FSCalendarDelegateAppearance

//设置当前月与非当前月字体颜色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
//
//    if ([calendar date:[NSDate date] sharesSameMonthWithDate:date]) {
//        return [UIColor whiteColor];
//    } else {
//        return [ToolHelper colorWithHexString:@"#8cc0f5"];//[UIColor colorWithWhite:0.702 alpha:1.000]
//    }
//}

//设置选中日期与未选中日期Title的颜色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleSelectionColorForDate:(NSDate *)date {
//    if (_dateArray.count > 0) {
//        for (NSDate *obj in _dateArray) {
//            if ([_calendar date:obj sharesSameDayWithDate:date]) {
//                return COLOR_BLUE;
//            }
//        }
//    }
//    return [UIColor whiteColor];
//}

//设置选中日期与未选中日期的填充色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance selectionColorForDate:(NSDate *)date {
//    if (_dateArray.count > 0) {
//        for (NSDate *obj in _dateArray) {
//            if ([_calendar date:obj sharesSameDayWithDate:date]) {
//                return [UIColor whiteColor];
//            }
//        }
//    }
//    return [UIColor blueColor];
//}

//设置可选日期与不可选日期的border颜色
//- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderDefaultColorForDate:(NSDate *)date {
//    if (_dateArray.count > 0) {
//        for (NSDate *obj in _dateArray) {
//            if ([_calendar date:obj sharesSameDayWithDate:date]) {
//                return COLOR_YELLOW;
//            }
//        }
//    }
//    return [UIColor blueColor];
//}

//设置选中日期的border颜色
- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance borderSelectionColorForDate:(NSDate *)date {
    return [UIColor whiteColor];
}

//设置可选日期
//- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date {
//    if (_dateArray.count > 0) {
//        for (NSDate *obj in _dateArray) {
//            if ([_calendar date:obj sharesSameDayWithDate:date]) {
//                return YES;
//            }
//        }
//    }
//
//    return NO;
//}

////////////////
/**
 * Asks the dataSource for a title for the specific date as a replacement of the day text   替换当月文本
 */
//- (nullable NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date{
//    return @"ss";
//}

/**
 * Asks the dataSource for a subtitle for the specific date under the day text.   日期下面的子标题
 */
//- (nullable NSString *)calendar:(FSCalendar *)calendar subtitleForDate:(NSDate *)date{
//    return @"ss";
//}

/**
 * Asks the dataSource for an image for the specific date.   特定日期的图像
 */
//- (nullable UIImage *)calendar:(FSCalendar *)calendar imageForDate:(NSDate *)date{
//    return [UIImage imageNamed:@"logo"];
//}

/**
 * Asks the dataSource the minimum date to display.
 */
//- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar{
//
//}

/**
 * Asks the dataSource the maximum date to display.
 */
//- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar;

/**
 * Asks the data source for a cell to insert in a particular data of the calendar.
 */
//- (__kindof FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)position;

/**
 * Asks the dataSource the number of event dots for a specific date.
 *
 * @see
 *   - (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorForDate:(NSDate *)date;
 *   - (NSArray *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventColorsForDate:(NSDate *)date;
 */
//- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date;

/**
 * This function is deprecated
 */
//- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date FSCalendarDeprecated(-calendar:numberOfEventsForDate:);

#pragma mark FSCalendarDelegate
// 设置五行显示时的calendar布局
- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    [UIView animateWithDuration:.3 animations:^{
        calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
//        self.myTableView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
//        ScheduleHeaderView *headerView = (ScheduleHeaderView *)[self.myTableView headerViewForSection:0];
//        headerView.frame = calendar.frame;
//        [self.myTableView reloadData];
    } completion:^(BOOL finished) {
    }];
    NSLog(@"0---%f",calendar.frame.origin.y);
}
// 对有事件的显示一个点,默认是显示三个点
- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    //从数组中查找是否有事件
//    if ([self.datesWithEvent containsObject:[dateFormatter stringFromDate:date]]) {
//        return 1;
//    }
    return 1;
}
//用于判断是否显示小圆点，有上面那个方法就够了 这个方法不需要
//- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date{
////    return [_datesWithEvent containsObject:[calendar stringFromDate:date format:@"yyyy-MM-dd"]];
//    return YES;
//}
//- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
//
//    NSLog(@"calendar.currentPage--  %@",calendar.currentPage);
//    //日历翻页时记录第一天
//    //    NSDate *changeDate = [calendar tomorrowOfDate:calendar.currentPage];
//    NSDate *changeDate = calendar.currentPage;
//    dateStr = [calendar stringFromDate:changeDate format:@"yyyyMMdd"];
//    //有事件的日期的年和月
//    NSDateFormatter *formatterYearAndMonth = [[NSDateFormatter alloc] init];
//    formatterYearAndMonth.dateFormat = @"yyyy-MM";
//    dateYearAndMonthStr = [formatterYearAndMonth stringFromDate:changeDate];
//    // 当日
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyy-MM-dd";
//    NSString *todayDateYearAndMonthStr = [formatterYearAndMonth stringFromDate: [NSDate date]];
//    // 设置切换到当前月份的时候,显示的是当天的日程
//    if ([[dateYearAndMonthStr substringWithRange:NSMakeRange(5, 2)] isEqualToString:[todayDateYearAndMonthStr substringWithRange:NSMakeRange(5, 2)]]) {
//        dateStr = [calendar stringFromDate:[NSDate date] format:@"yyyyMMdd"];
//    }
//    [self loadData];
//}
//选中某一天进行相关操作
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date {
    //...
}
//取消选中的日期进行相关操作
- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date {
    //...
}

- (FSCalendar *)calendar {
    
    if (!_calendar) {
        _calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 400)]; //248
        _calendar.dataSource = self;
        _calendar.delegate = self;
        //设置周一为第一天
        _calendar.firstWeekday = 2;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
        _calendar.locale = locale;
        //设置翻页方式为水平
        _calendar.scrollDirection = FSCalendarScrollDirectionHorizontal;
        //设置是否用户多选
        _calendar.allowsMultipleSelection = NO;
        _calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase|FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
        //这个属性控制"上个月"和"下个月"标签在静止时刻的透明度          _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        _calendar.backgroundColor = [UIColor whiteColor];
        //设置周字体颜色
        _calendar.appearance.weekdayTextColor = [UIColor blackColor];
        //设置头字体颜色
        _calendar.appearance.headerTitleColor = [UIColor blackColor];
        //设置主标题格式
        _calendar.appearance.headerDateFormat = @"yyyy MM月";
        //月份模式时，只显示当前月份
        _calendar.placeholderType = FSCalendarPlaceholderTypeNone;
        //有事件的小圆点的颜色
        _calendar.appearance.eventDefaultColor = [UIColor colorWithHexString:@"#E04E63"];
        //这个属性控制"上个月"和"下个月"标签在静止时刻的透明度  主标题两边的标题
        _calendar.appearance.headerMinimumDissolvedAlpha = 0;
        //隐藏header
        _calendar.headerHeight = 0;
        //设置显示的时间范围   一周或一个月
        _calendar.scope = FSCalendarScopeMonth;
        //保存当前月
        self.todayMonth = self.calendar.currentPage;
        
        
        //创建点击跳转显示上一月和下一月button
        UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        previousButton.frame = CGRectMake(self.view.center.x - 50 - 6.5, 13, 6.5, 13);
        previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [previousButton setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
        [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_calendar addSubview:previousButton];
        
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(self.view.center.x + 50, 13, 6.5, 13);
        nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [nextButton setImage:[UIImage imageNamed:@"logo"] forState:UIControlStateNormal];
        nextButton.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_calendar addSubview:nextButton];
        //设置当天的字体颜色
//        _calendar.todayColor = [UIColor blueColor];
    }
    return _calendar;
}
@end
