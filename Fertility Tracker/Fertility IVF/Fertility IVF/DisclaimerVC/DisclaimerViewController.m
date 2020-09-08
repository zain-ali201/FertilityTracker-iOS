//
//  DisclaimerViewController.m
//  Fertility IVF
//
//  Created by Zain Ali on 3/12/15.
//  Copyright (c) 2015 Tconnect. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "HomeViewController.h"

@implementation DisclaimerViewController

@synthesize fromInfoVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, 750.0)];
    
    if (fromInfoVC) {
        lblMessage.alpha = 0;
        nextBtn.alpha = 0;
        checkBtn.alpha = 0;
    }
    else
    {
        lblMessage.alpha = 1;
        nextBtn.alpha = 1;
        checkBtn.alpha = 1;
    }
    
    isChecked = FALSE;
    
    lblDetail.textAlignment = NSTextAlignmentJustified;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)checkBtnAction:(id)sender
{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    if (isChecked)
    {
        [userDefaults setObject:@"0" forKey:@"disclaimer"];
        [userDefaults synchronize];
        [checkBtn setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];
        isChecked = FALSE;
    }
    else
    {
        [checkBtn setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
        [userDefaults setObject:@"1" forKey:@"disclaimer"];
        [userDefaults synchronize];
        isChecked = TRUE;
    }
}

-(IBAction)homeBtnAction:(id)sender
{
    NSString *viewName = [appDelegate CheckDevice:@"HomeViewController" iPhone5:@"HomeViewControllerIphone5" iPAD:@""];
    HomeViewController *homeVC = [[HomeViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:homeVC animated:YES];
}

@end
