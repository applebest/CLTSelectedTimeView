//
//  ViewController.m
//  CLTSelectedTimeView
//
//  Created by xindongyuan on 2017/1/17.
//  Copyright © 2017年 clt. All rights reserved.
//






/*
 *********************************************************************************
 *                                                                                *
 * 在使用此款控件时如有问题请以以下任意一种方式联系我，我会及时修复bug并  *
 * 帮您解决问题。                                                                    *
 * QQ    : 253028824( 混  不  吝  〃 )                                                      *
 * Email : 253028824@qq.com                                                          *                                                        *

 *********************************************************************************
 */

#import "ViewController.h"
#import "CLTSelectedTimeView.h"


@interface ViewController ()


@property (nonatomic,strong) CLTSelectedTimeView *timeView;


@property (nonatomic,strong) UILabel *infoView;


@property (nonatomic,assign) CGFloat timeViewHeight;

@end

@implementation ViewController


- (void)loadView
{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg.jpeg"]];
    
    imageView.userInteractionEnabled = YES;
    
    self.view = imageView;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    
    self.timeViewHeight = [UIScreen mainScreen].bounds.size.height / 2.5;
    
    
}

- (UILabel *)infoView
{
    if (!_infoView) {
        
        
       CGRect rect = [UIScreen mainScreen].bounds;
        _infoView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height - self.timeViewHeight - 20)];
        _infoView.textAlignment = NSTextAlignmentCenter;
        
        _infoView.backgroundColor = [UIColor clearColor];
        
        _infoView.numberOfLines = 0;
        
        _infoView.textColor = [UIColor colorWithRed:255.0f / 255.0f green:97.0f/ 255.0f blue:130.0f/ 255.0f alpha:1];
        
        
        
        [self.view addSubview:_infoView];
        
    }
    
    return _infoView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.timeView = [[CLTSelectedTimeView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,self.timeViewHeight)];
    
    __weak typeof(self) weakSelf = self;

    self.timeView.getTimeInfo = ^(CLTSelectedModel *headerModel,CLTSelectedModel *infoModel)
    {
      
        
        weakSelf.infoView.text = [NSString stringWithFormat:@"在使用过程中如有问题请及时联系我:QQ:253028824(混  不  吝  〃)\n\n 头部信息 ==> %@\n 最终选中的cell的信息 ==>\n  title:%@\n startTime:%@\n endTime:%@",headerModel.title,infoModel.title,infoModel.startTime,infoModel.endTime];
        
        
        NSLog(@"头部信息 ==> %@",headerModel.title);

        
        NSLog(@"最终选中的cell的信息 ==>  title:%@ startTime:%@ endTime:%@",infoModel.title,infoModel.startTime,infoModel.endTime);
        [weakSelf.timeView bottomDismissRemoveOverlay];
    };
    
    [weakSelf.timeView bottomShowOverlay];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
