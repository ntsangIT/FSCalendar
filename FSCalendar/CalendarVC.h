//
//  ButtonsViewController.h
//  FSCalendar
//
//  Created by dingwenchao on 4/15/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FSCalendar.h"

@interface CalendarVC : UIViewController

@property (weak, nonatomic) id<FSCalendarDelegate> delegate;

@property (nonatomic) BOOL isOutDateTo;
@property (nonatomic) BOOL isOutDateFrom;

-(NSDate*)increaseOneDay;
-(NSDate*)decreaseOneDay;
-(void)updateOutDate:(NSDate*)date;
-(void)updateUI:(NSDate*)date;
-(void)setOutDateTo:(NSDate *)outDateTo outDateFrom:(NSDate *)outDateFrom;
+(void)setCurrentDate:(NSDate*)date;
-(void)setAndUpdateCurrentDate:(NSDate*)date;
+(NSDate*)getCurrentDate;

@end
