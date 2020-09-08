//
//  FrequencyViewController.m
//  Fertility IVF
//
//  Created by Zain Ali on 1/7/15.
//  Copyright (c) 2015 Tconnect. All rights reserved.
//

#import "FrequencyViewController.h"

@implementation FrequencyViewController

@synthesize detail;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [self fillMainScrollView];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fillMainScrollView
{
    for(UIView *view in mainScrollView.subviews)
        [view removeFromSuperview];
    
    int count = 1;
    NSString *suffix = @"";
    NSString *suffix1 = @"";
    
    if (detail.freqID == 4)
    {
        count = 48;
        suffix = @"hours";
        suffix1 = @"hour";
    }
    else if (detail.freqID == 5)
    {
        count = 50;
        suffix = @"days";
        suffix1 = @"day";
    }
    else if (detail.freqID == 6)
    {
        count = 10;
        suffix = @"weeks";
        suffix1 = @"week";
    }
    else if (detail.freqID == 7)
    {
        count = 12;
        suffix = @"months";
        suffix1 = @"month";
    }

    
    frequencyChildArray = [[NSMutableArray alloc]init];
    
    float YAxis = 0.0;
    
    for (int i = 1; i <= count; i++)
    {
        NSString *title = @"";
        
        if (i==1)
            title  = [NSString stringWithFormat:@"Every %@",suffix1];
        else
            title  = [NSString stringWithFormat:@"Every %i %@",i,suffix];
        
        FrequencyDetail *freqDetail = [[FrequencyDetail alloc]init];
        freqDetail.freqID = i;
        freqDetail.title = title;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, YAxis, 306.0, 40.0)];
        
        UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(7.0, 0, 200.0, 40.0)];
        [lblName setBackgroundColor:[UIColor clearColor]];
        [lblName setFont:[UIFont systemFontOfSize:14.0]];
        [lblName setTextColor:[UIColor colorWithRed:137.0/255.0 green:80.0/255.0 blue:125.0/255.0 alpha:1]];
        [lblName setText:title];
        
        UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(7.0, 39.0, 287.0, 1.0)];
        [lineImgView setImage:[UIImage imageNamed:@"line.png"]];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 306.0, 40.0)];
        btn.tag  = i + 1000;
        [btn addTarget:self action:@selector(frequencyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
        [view addSubview:lblName];
        [view addSubview:lineImgView];
        [view addSubview:btn];
        
        [mainScrollView addSubview:view];
        
        YAxis += 40.0;
        
        [frequencyChildArray addObject:freqDetail];
    }
    [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, YAxis)];
}

-(IBAction)frequencyBtnAction:(UIButton*)button
{
    FrequencyDetail *freqDetail = [frequencyChildArray objectAtIndex:button.tag - 1001];
    detail.childFreqID = freqDetail.freqID;
    detail.childTitle = freqDetail.title;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)cancelBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
