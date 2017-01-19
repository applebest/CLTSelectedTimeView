//
//  CLTSelectedTimeView.h
//  CLTSelectedTimeView
//
//  Created by xindongyuan on 2017/1/17.
//  Copyright © 2017年 clt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLTSelectedModel;



@interface CLTSelectedTimeView : UIView



@property (nonatomic,copy) void (^getTimeInfo)(CLTSelectedModel *headerModel,CLTSelectedModel *infoModel);


- (void)bottomShowOverlay;

- (void)bottomDismissRemoveOverlay;



@end


@interface CLTSelectedTimeTableHeaderView : UIView


@property (nonatomic,strong) UIButton *firstBtn;

@property (nonatomic,strong) UIButton *lastBtn;

@property (nonatomic,copy) void (^firstBtnClick)();

@end



@interface CLTSelectedModel : NSObject


@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSMutableArray *timesArr;


+ (NSMutableArray *)getTimesData;

@end
