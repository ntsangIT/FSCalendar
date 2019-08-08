//
//  CalendarVC.m
//  FSCalendar
//
//  Created by dingwenchao on 4/15/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import "CalendarVC.h"

#define         ONE_DAY (24 * 60 * 60)

@interface CalendarVC()<FSCalendarDataSource,FSCalendarDelegate>

//@property (weak, nonatomic) FSCalendar *calendar;
@property (weak, nonatomic) IBOutlet FSCalendar *calendar;
@property (weak, nonatomic) UIButton *previousButton;
@property (weak, nonatomic) UIButton *nextButton;
@property (weak, nonatomic) UIButton *doneButton;
@property (strong, nonatomic) NSCalendar *gregorian;

- (void)previousClicked:(id)sender;
- (void)nextClicked:(id)sender;

@end

@implementation CalendarVC

static NSDate *curentDate;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"FSCalendar";
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return self;
}

+(void)setCurrentDate:(NSDate*)date {
    curentDate = date;
}

-(void)setAndUpdateCurrentDate:(NSDate*)date {
    curentDate = date;
    [self.calendar selectDate:curentDate scrollToDate:NO];
}

+(NSDate*)getCurrentDate {
    return curentDate;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!curentDate) {
        curentDate = [NSDate date];
    }
    self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.dataSource = self;
    [self.calendar setLocale:[NSLocale localeWithLocaleIdentifier:@"ja_JP"]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.calendar.layer.cornerRadius = 15.0;
    self.calendar.layer.masksToBounds = true;
    self.calendar.backgroundColor = [UIColor whiteColor];
    self.calendar.appearance.headerMinimumDissolvedAlpha = 0.0;
    self.calendar.appearance.headerDateFormat = @"yyyy年MM月";
    self.calendar.appearance.titleSundayColor = UIColorFromRGB(0xE4007F);
    self.calendar.appearance.titleSaturdayColor = UIColorFromRGB(0x4C6EAC);
    self.calendar.appearance.weekdayHeaderBackgroundColor = UIColorFromRGB(0x4C6EAC);
    self.calendar.appearance.headerTitleColor = UIColorFromRGB(0x000000);
    self.calendar.appearance.weekdayTextColor = UIColor.whiteColor;
    self.calendar.appearance.weekdayFont = [UIFont systemFontOfSize:20];
    self.calendar.appearance.headerTitleFont = [UIFont systemFontOfSize:22];
    self.calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesUpperCase;
    [self.calendar selectDate:[NSDate date]];
    [self.calendar calendarHeaderView].backgroundColor = UIColorFromRGB(0xF9F9F9);
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.backgroundColor = [UIColor clearColor];
    [previousButton setImage:[UIImage imageNamed:@"ic_previous_month"] forState:UIControlStateNormal];
    [previousButton setImage:[UIImage imageNamed:@"ic_previous_disable"] forState:UIControlStateDisabled];
    [previousButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.backgroundColor = [UIColor clearColor];
    [nextButton setImage:[UIImage imageNamed:@"ic_next_month"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"ic_next_disable"] forState:UIControlStateDisabled];
    [nextButton setImageEdgeInsets:UIEdgeInsetsMake(12, 12, 12, 12)];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    self.nextButton = nextButton;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton setTitle:NSLocalizedString(@"Close", nil) forState:UIControlStateNormal];
    [doneButton setTitleColor:UIColorFromRGB(0x00A0E9) forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [doneButton addTarget:self action:@selector(doneClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    self.doneButton = doneButton;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.calendar.frame.origin.y + self.calendar.calendarHeaderView.frame.size.height/2 - 30/2;
    self.nextButton.frame = CGRectMake(width / 2 + 130 - 30, height, 30, 34);
    self.doneButton.frame = CGRectMake(width / 2 + self.calendar.calendarHeaderView.frame.size.width/2 - 80, height, 70, 30);
    self.previousButton.frame = CGRectMake(width / 2 - 130, height, 30, 34);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
    [self.calendar setCurrentPage:curentDate animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setDelegate:(id<FSCalendarDelegate>)delegate
{
    self.calendar.delegate = delegate;
}

-(void)setOutDateTo:(NSDate *)outDateTo outDateFrom:(NSDate *)outDateFrom {
    self.calendar.appearance.outDateTo = outDateTo;
    self.calendar.appearance.outDateFrom = outDateFrom;
    [self.calendar selectDate:curentDate scrollToDate:NO];
    [self.calendar reloadData];
}

- (void)previousClicked:(id)sender
{
    [self.nextButton setEnabled:YES];
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    if ([self checkOutDate:previousMonth]) {
        [self.previousButton setEnabled:NO];
        return;
    }
    [self.previousButton setEnabled:YES];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    [self.previousButton setEnabled:YES];
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    if ([self checkOutDate:nextMonth]) {
        [self.nextButton setEnabled:NO];
        return;
    }
    [self.nextButton setEnabled:YES];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

- (void)doneClicked:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(NSDate*)increaseOneDay {
    self.isOutDateTo = NO;
    curentDate = [curentDate dateByAddingTimeInterval:ONE_DAY];
    if ([self checkOutDate:[curentDate dateByAddingTimeInterval:ONE_DAY]]) {
        self.isOutDateFrom = NO;
        return curentDate;
    }
    self.isOutDateFrom = NO;
    [self.calendar selectDate:curentDate scrollToDate:NO];
    return curentDate;
}

-(NSDate*)decreaseOneDay {
    self.isOutDateFrom = NO;
    curentDate = [curentDate dateByAddingTimeInterval:-ONE_DAY];
    if ([self checkOutDate:[curentDate dateByAddingTimeInterval:-ONE_DAY]]) {
        self.isOutDateTo = YES;
        return curentDate;
    }
    self.isOutDateTo = NO;
    [self.calendar selectDate:curentDate scrollToDate:NO];
    return curentDate;
}

-(BOOL)checkOutDate:(NSDate *)date {
    return [self.calendar isOutDate:date
                          outDateTo:self.calendar.appearance.outDateTo
                        outDateFrom:self.calendar.appearance.outDateFrom];
}

- (void)updateUI:(NSDate *)date {
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:date options:0];
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:date options:0];
    [self.nextButton setEnabled:![self checkOutDate:nextMonth]];
    [self.previousButton setEnabled:![self checkOutDate:previousMonth]];
}

- (void)updateOutDate:(NSDate *)date {
    self.isOutDateTo = [self checkOutDate:[curentDate dateByAddingTimeInterval:-ONE_DAY]];
    self.isOutDateFrom = [self checkOutDate:[curentDate dateByAddingTimeInterval:ONE_DAY]];
}

@end
