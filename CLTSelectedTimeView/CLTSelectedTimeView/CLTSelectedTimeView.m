//
//  CLTSelectedTimeView.m
//  CLTSelectedTimeView
//
//  Created by xindongyuan on 2017/1/17.
//  Copyright © 2017年 clt. All rights reserved.
//

#import "CLTSelectedTimeView.h"


@interface CLTSelectedTimeView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *titleView;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) NSMutableArray *resultArr;

@property (nonatomic,strong) CLTSelectedModel *headerModel;

@property (nonatomic,strong) CLTSelectedModel *lastModel;


@property (nonatomic,strong) UIControl *overlayView;


@end

@implementation CLTSelectedTimeView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self setup];
        
        [self setData];

        
    }
    return self;
}


- (void)bottomShowOverlay
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
    [keyWindow addSubview:self.overlayView];
    [keyWindow addSubview:self];
    self.center = CGPointMake(0, keyWindow.bounds.size.height);
    [self.overlayView addTarget:self action:@selector(bottomDismissRemoveOverlay) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.alpha = 0;
    self.frame = CGRectMake(0, keyWindow.bounds.size.height,self.bounds.size.width, self.bounds.size.height);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:.35 animations:^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.alpha = 1;
        
        strongSelf.frame = CGRectMake(0, keyWindow.bounds.size.height - strongSelf.bounds.size.height, strongSelf.bounds.size.width, strongSelf.bounds.size.height);
    }];


}

- (void)bottomDismissRemoveOverlay
{
    __weak typeof(self) weakSelf = self;
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

    
    [UIView animateWithDuration:.35 animations:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.frame = CGRectMake(0, keyWindow.bounds.size.height, strongSelf.frame.size.width, strongSelf.frame.size.height);
        strongSelf.alpha = 0.0;
    } completion:^(BOOL finished) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (finished) {
            
            [strongSelf.overlayView removeFromSuperview];
            
            [strongSelf removeFromSuperview];
        }
    }];
}




- (void)setup
{
    self.headerView = [UIView new];
    self.headerView.backgroundColor = [UIColor whiteColor];
    self.titleView = [UILabel new];
    self.titleView.text = @"选择时间";
    self.titleView.textAlignment = NSTextAlignmentCenter;
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.textColor = [UIColor colorWithRed:119.f/255.f green:170.f/255.f blue:255.f/255.f alpha:1.0];
    self.tableView = [UITableView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = 40;
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f blue:235/255.f alpha:1];
    
    [self.headerView addSubview:self.titleView];
    [self.headerView addSubview:self.lineView];
    [self addSubview:self.headerView];
    [self addSubview:self.tableView];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    self.headerView.frame = CGRectMake(0, 0, rect.size.width, 46);
    self.titleView.center = self.headerView.center;
    self.titleView.bounds = CGRectMake(0, 0, rect.size.width, 25);
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame) - 1, rect.size.width, 1);
    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), rect.size.width, self.bounds.size.height - CGRectGetMaxY(self.headerView.frame));
    
    
    
}


- (void)setData
{
    self.dataSource = [CLTSelectedModel getTimesData];
    self.resultArr = [NSMutableArray arrayWithArray:self.dataSource];
    [self.tableView reloadData];
}



#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArr.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    CLTSelectedTimeTableHeaderView  *headerView = [[CLTSelectedTimeTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    
    if (self.headerModel != nil) {
        
        [headerView.firstBtn setTitleColor:[UIColor blackColor] forState:0];
        [headerView.lastBtn setTitleColor:[UIColor redColor] forState:0];
        [headerView.firstBtn setTitle:self.headerModel.title forState:0];
        [headerView.lastBtn setTitle:@"请选择" forState:0];
    }
    else
    {
        [headerView.firstBtn setTitleColor:[UIColor redColor] forState:0];
        [headerView.lastBtn setTitleColor:[UIColor blackColor] forState:0];
        [headerView.firstBtn setTitle:@"请选择" forState:0];
        [headerView.lastBtn setTitle:@"" forState:0];
    }
    __weak typeof(self) weakSelf = self;
    
    headerView.firstBtnClick = ^{
        
        weakSelf.resultArr = [NSMutableArray arrayWithArray:self.dataSource];
        weakSelf.headerModel = nil;
        [weakSelf.tableView reloadData];
    };
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *XDYSelectedTimeTableViewCellID = @"XDYSelectedTimeTableViewCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XDYSelectedTimeTableViewCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XDYSelectedTimeTableViewCellID];
    }
    
    CLTSelectedModel *model = self.resultArr[indexPath.row];
    
    
    cell.textLabel.text = model.title;
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CLTSelectedModel *model = self.resultArr[indexPath.row];
    if (model.timesArr.count != 0) {
        
        self.headerModel = model;
        
        self.resultArr = self.headerModel.timesArr;
        
    }
    else
    {
        
        self.lastModel = self.resultArr[indexPath.row];
        
        if (self.getTimeInfo) {
            self.getTimeInfo(self.headerModel,self.lastModel);
            
        }
    }
    
    
    
    [self.tableView reloadData];
    
    
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation CLTSelectedTimeTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setup];

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnW = 60;
    
    self.firstBtn.frame = CGRectMake(10, 0, btnW, self.bounds.size.height);
    self.lastBtn.frame = CGRectMake(CGRectGetMaxX(self.firstBtn.frame) + 10, 0, btnW, self.bounds.size.height);
    
    
}

- (void)setup
{
    self.firstBtn = [UIButton new];
    [self.firstBtn setTitle:@"请选择" forState:0];
    [self.firstBtn setTitleColor:[UIColor redColor] forState:0];
    self.lastBtn = [UIButton new];
    
    self.firstBtn.titleLabel.font = self.lastBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    [self addSubview:self.firstBtn];
    [self addSubview:self.lastBtn];
    [self.firstBtn addTarget:self action:@selector(firstClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)firstClick:(UIButton *)sender
{
    if (self.firstBtnClick) {
        self.firstBtnClick();
    }
}



@end



@implementation CLTSelectedModel



+ (NSMutableArray *)getTimesData
{
    NSMutableArray *dataArr = [NSMutableArray array];
    
    CLTSelectedModel *year = [CLTSelectedModel getTimeWithType:@"年"];

    CLTSelectedModel *quarter = [CLTSelectedModel getTimeWithType:@"季"];
    CLTSelectedModel *month = [CLTSelectedModel getTimeWithType:@"月"];
    CLTSelectedModel *week = [CLTSelectedModel getTimeWithType:@"周"];

    year.timesArr = [self getYear];
    quarter.timesArr = [self getQuarter];
    month.timesArr = [self getMonth];
    week.timesArr = [self getWeek];

    [dataArr addObject:year];
    [dataArr addObject:quarter];
    [dataArr addObject:month];
    [dataArr addObject:week];
    
    
    return dataArr;
}

+ (instancetype)getTimeWithType:(NSString *)type
{
    CLTSelectedModel *year = [CLTSelectedModel new];
    year.title = type;
    return year;
}

+ (NSMutableArray *)getYear
{
    NSMutableArray *yearArr = [NSMutableArray array];
    NSDateComponents *compontents  = [self getCurrentDateComponents];

    NSInteger year = compontents.year;
    
    for (NSInteger i = 0; i < 3; i++) {
        
        CLTSelectedModel *currentYearModel = [CLTSelectedModel getYearModelWithYear:year];
 
        year += 1;
        
    
        [yearArr addObject:currentYearModel];
 
        
    }
    
    
    
    return yearArr;
    
}

+ (instancetype)getYearModelWithYear:(NSInteger)Year
{
    CLTSelectedModel *currentYearModel = [CLTSelectedModel new];
    // 得到12月字符串
    NSString *str = [NSString stringWithFormat:@"%ld-%@",Year,@"12"];
    // 12月的天数
    NSDate *date = [self getDateWithTimeString:str dateFormat:@"yyyy-MM"];
    // 得到有多少天
    NSInteger dayInMonth = [self getNumberDayOfDateInMonth:date];
    
    NSString *end = [NSString stringWithFormat:@"%ld-12-%ld",Year,dayInMonth];
    
    currentYearModel.title = [NSString stringWithFormat:@"%ld-01-12",Year];
    
    currentYearModel.startTime = [self get13TimeNumberWithDateFormat :@"yyyy-MM-dd" timeOut:[NSString stringWithFormat:@"%ld-01-01",Year]];
    
    currentYearModel.endTime =     [self get13TimeNumberWithDateFormat :@"yyyy-MM-dd" timeOut:end];
    
    
    return currentYearModel;

}

+ (NSMutableArray *)getQuarter
{
    NSMutableArray *quarter = [NSMutableArray array];
    
    NSDateComponents *compontents  = [self getCurrentDateComponents];
    NSInteger year = compontents.year;
    
    NSInteger startmonth = 1;
    NSInteger endMonth = 3;
    
    NSInteger nextMonth = 1;
    NSInteger nextEndmonth = 3;
    
    for (NSInteger i = 0; i < 4; i++) {
        
        CLTSelectedModel *quarterModel = [CLTSelectedModel getQuarterModelWithYear:year Month:startmonth endMonth:endMonth];
        NSString *title = quarterModel.title;
        
        quarterModel.title = [NSString stringWithFormat:@"%ld 第%ld季度 %@",year,(i+1),title];
        
        
        startmonth += 3;
        endMonth += 3;
        
        
        [quarter addObject:quarterModel];
        
        
    }
    
    for (NSInteger i = 0; i < 4 ; i++) {
        
        CLTSelectedModel *quarterModel = [CLTSelectedModel getQuarterModelWithYear:year+1 Month:nextMonth endMonth:nextEndmonth];
        NSString *title = quarterModel.title;
        
        quarterModel.title = [NSString stringWithFormat:@"%ld 第%ld季度 %@",year+1,(i+1),title];
        
        nextMonth += 3;
        nextEndmonth += 3;

      [quarter addObject:quarterModel];

    }
    
    
    return quarter;

}

+ (instancetype)getQuarterModelWithYear:(NSInteger)year Month:(NSInteger)month endMonth:(NSInteger)endMonth
{
    
    CLTSelectedModel *model = [CLTSelectedModel new];
    
    
    // 得到有多少天
    // 月字符串
    NSString *str = [NSString stringWithFormat:@"%ld-%ld",year,endMonth];
    // 得到结束月的天数
    NSDate *date = [self getDateWithTimeString:str dateFormat:@"yyyy-MM"];
    // 得到有多少天
    NSInteger dayInMonth = [self getNumberDayOfDateInMonth:date];
    
    
    model.title = [NSString stringWithFormat:@"%ld-%02ld-01----%ld-%02ld-%02ld",year,month,year,endMonth,dayInMonth];
    
    NSString *startQuarter = [NSString stringWithFormat:@"%ld-%02ld",year,month];
    
    // 得到 截断的月份的字符串  3 6 9 12
    NSString *endQuarter = [NSString stringWithFormat:@"%ld-%02ld",year,endMonth];
    
    
    model.startTime = [self get13TimeNumberWithDateFormat:@"yyyy-MM" timeOut:startQuarter];
    
    
    model.endTime = [self get13TimeNumberWithDateFormat:@"yyyy-MM" timeOut:endQuarter];
    
    
    
    return model;
    
}


+ (NSMutableArray *)getMonth
{
    NSMutableArray *monthData = [NSMutableArray array];
    
    NSDateComponents *components  =  [self getCurrentDateComponents];
    
    for (NSInteger i = 0 ; i < 12 ; i ++ ) {
        
        CLTSelectedModel *timeModel = [CLTSelectedModel new];
        timeModel.title = [NSString stringWithFormat:@"第%ld月 %ld-%02ld",(i+1),components.year,(i+1)];
        NSString *str = [NSString stringWithFormat:@"%ld-%02ld",components.year,(i+1)];
        // 得到时间
        NSDate *date = [self getDateWithTimeString:str dateFormat:@"yyyy-MM"];
        // 得到有多少天
        NSInteger dayInMonth = [self getNumberDayOfDateInMonth:date];
        
        timeModel.startTime = [self get13TimeNumberWithDateFormat:@"yyyy-MM-dd" timeOut:[NSString stringWithFormat:@"%ld-%ld-%@",components.year,(i+1),@"01"]];
        timeModel.endTime = [self get13TimeNumberWithDateFormat:@"yyyy-MM-dd" timeOut:[NSString stringWithFormat:@"%ld-%ld-%02ld",components.year,(i+1),dayInMonth]];
        
        
        
            [monthData addObject:timeModel];
            
            
        
        
    }
    
    // 获取下一年的日期
    for (NSInteger i = 0; i < 12; i ++) {
        
        CLTSelectedModel *timeModel = [CLTSelectedModel new];
        timeModel.title = [NSString stringWithFormat:@"第%ld月 %ld-%02ld",(i+1),(components.year+1),(i+1)];
        NSString *str = [NSString stringWithFormat:@"%ld-%02ld",(components.year+1),(i+1)];
        // 得到时间
        NSDate *date = [self getDateWithTimeString:str dateFormat:@"yyyy-MM"];
        // 得到有多少天
        NSInteger dayInMonth = [self getNumberDayOfDateInMonth:date];
        
        timeModel.startTime = [self get13TimeNumberWithDateFormat:@"yyyy-MM-dd" timeOut:[NSString stringWithFormat:@"%ld-%ld-%@",(components.year+1),(i+1),@"01"]];
        timeModel.endTime = [self get13TimeNumberWithDateFormat:@"yyyy-MM-dd" timeOut:[NSString stringWithFormat:@"%ld-%ld-%02ld",(components.year+1),(i+1),dayInMonth]];
        
        
        
        
            [monthData addObject:timeModel];
            
            
        
    }
    
    
    
    return monthData;

}
+ (NSMutableArray *)getWeek
{
    NSMutableArray *weekArr = [NSMutableArray array];

    // 日期格式化
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    // 得到今年一月一号的时间
    
    NSDate *getFirstWeekOne = [self getYearFirstWeekOne];
    NSDate *getEndWeek = [NSDate dateWithTimeIntervalSinceNow:getFirstWeekOne.timeIntervalSinceNow + (24 * 60 * 60 *6)];
    
    
    
    CLTSelectedModel *weekModel = [CLTSelectedModel new];
    weekModel.startTime = [self get13TimeWithDate:getFirstWeekOne];
    weekModel.endTime = [self get13TimeWithDate:getEndWeek];
    
    NSString *startTitle = [self getAppointFormaterrStr:@"yyyy-MM-dd" DateString:weekModel.startTime];
    NSString *endTitle = [self getAppointFormaterrStr:@"yyyy-MM-dd" DateString:weekModel.endTime];
    
    weekModel.title = [NSString stringWithFormat:@"第1周 %@----%@",startTitle,endTitle];
    
    
        [weekArr addObject:weekModel];
        
    
    long long  currentEndTime = getEndWeek.timeIntervalSince1970 + 24 * 60 * 60;
    
    
    for (NSInteger i = 1 ; i < 104; i ++) {
        
        CLTSelectedModel *model = [CLTSelectedModel new];
        model.startTime = [self get13TimeWithDate:[NSDate dateWithTimeIntervalSince1970:currentEndTime]];
        model.endTime = [self get13TimeWithDate:[NSDate dateWithTimeIntervalSince1970:currentEndTime  + (24 * 60 * 60 *6)]];
        
        NSString *startTitle = [self getAppointFormaterrStr:@"yyyy-MM-dd" DateString:model.startTime];
        NSString *endTitle = [self getAppointFormaterrStr:@"yyyy-MM-dd" DateString:model.endTime];
        
        model.title = [NSString stringWithFormat:@"第%ld周 %@----%@", i >= 52 ? (i - 51) : (i+1),startTitle,endTitle];
        
            
        [weekArr addObject:model];
        
        
        currentEndTime +=  (604800);
        
    }
    
    
    
    
    
    
    
    return weekArr;

}



#pragma mark 时间处理

+ (NSDateComponents *)getCurrentDateComponents
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    
    return comp;
}

+ (NSDate *)getDateWithTimeString:(NSString *)timeString dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = dateFormat;
    
    
    return [formatter dateFromString:timeString];
    
}

+ (NSInteger)getNumberDayOfDateInMonth:(NSDate *)dateInMonth
{
 
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:dateInMonth];
    
    
    return range.length;
}

+ (NSString *)get13TimeNumberWithDateFormat:(NSString *)dateFormat timeOut:(NSString *)timeOut
{
    if (timeOut.description.length == 0) {
        
        return @"";
    }
    else
    {
        NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
        //        [objDateformat setDateStyle:NSDateFormatterMediumStyle];
        //        [objDateformat setTimeStyle:NSDateFormatterShortStyle];
        [objDateformat setDateFormat:dateFormat];
        
        NSDate *date = [objDateformat dateFromString:timeOut.description];
        NSString *nowtimeStr = [objDateformat stringFromDate:date];
        NSDate *newData = [objDateformat dateFromString:nowtimeStr];
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",[newData timeIntervalSince1970] * 1000];
        
        
        return timeStr;
        
    }
    
}



+ (NSDate *)getYearFirstWeekOne
{
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    // 得到今年一月一号的时间
    NSDate *currentFirstDate = [formatter dateFromString:[NSString stringWithFormat:@"%ld-01-01",[self getCurrentYear]]];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:currentFirstDate];
    
    NSInteger weekDay = [comp weekday];
    NSInteger day = [comp day];
    
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
    }
    
    
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentFirstDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    
    return firstDayOfWeek;
    
    
}


+ (NSString *)get13TimeWithDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%.0f",date.timeIntervalSince1970 * 1000] ;
}

+ (NSString *)getAppointFormaterrStr:(NSString *)formaterrStr DateString:(NSString *)dateString
{
    if (dateString.description.length == 0) {
        
        return @"";
    }
    else
    {
        long long time = dateString.description.longLongValue;
        time = time / 1000;
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = formaterrStr;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
        return [formatter stringFromDate:date];
    }
}

+ (NSInteger)getCurrentYear
{
    
    return [self getCurrentDateComponents].year;
}




@end

