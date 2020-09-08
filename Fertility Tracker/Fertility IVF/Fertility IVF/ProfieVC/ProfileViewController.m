//
//  ProfileViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "ProfileViewController.h"

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    int device = [appDelegate CheckDevice];
    
    txtDate.placeholder = appDelegate.deviceDateFormat;
    
    
    if (device == 4)
    {
        pickerYPosition = 575.0;
        pickerYOpenPosition = 395.0;
        
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height+50)];
    }
    else if(device == 5)
    {
        pickerYPosition = 672.0;
        pickerYOpenPosition = 483.0;
    }
    
    [datePickerView setCenter:CGPointMake(self.view.center.x, pickerYPosition)];
    [self.view addSubview:datePickerView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    txtFirstName.text = [defaults objectForKey:@"fname"];
    txtLastName.text  = [defaults objectForKey:@"lname"];
    txtDate.text  = [defaults objectForKey:@"dob"];
    txtHeight.text  = [defaults objectForKey:@"height"];
    txtWeight.text  = [defaults objectForKey:@"weight"];
    
    txtFirstName.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancelBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneBtnAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([txtFirstName.text isEqualToString:@""])
    {
        alert.message = @"Please enter you first name!";
        [alert show];
    }
    else if ([txtLastName.text isEqualToString:@""])
    {
        alert.message = @"Please enter your last name!";
        [alert show];
    }
    else if ([txtDate.text isEqualToString:@""])
    {
        alert.message = @"Please select your date of birth!";
        [alert show];
    }
    else
    {
        NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
        [defaults setValue:txtFirstName.text forKey:@"fname"];
        [defaults setValue:txtLastName.text forKey:@"lname"];
        [defaults setValue:txtDate.text forKey:@"dob"];
        [defaults setValue:txtHeight.text forKey:@"height"];
        [defaults setValue:txtWeight.text forKey:@"weight"];
        [defaults synchronize];
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"Your information has been saved!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)calenderBtnAction:(id)sender
{
    [self hideKeyboard];
    datePicker.date = [NSDate date];
    [appDelegate jumpAnimationForView:datePickerView toPoint:CGPointMake(self.view.center.x, pickerYOpenPosition)];
}

-(IBAction)pickerDoneBtnAction:(UIButton*)button
{
    [self hidePickerViews];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:appDelegate.deviceDateFormat];
    
    NSDate *pickedTime = [datePicker date];
    NSString *date = [dateFormatter stringFromDate:pickedTime];
    txtDate.text = date;
    
}

-(IBAction)pickerCancelBtnAction:(id)sender
{
    [self hidePickerViews];
}

-(void)hidePickerViews
{
    [appDelegate jumpAnimationForView:datePickerView toPoint:CGPointMake(self.view.center.x, pickerYPosition)];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideKeyboard];
}

-(IBAction)keyboardHideBtnAction:(id)sender
{
    [self hideKeyboard];
}

-(void)hideKeyboard
{
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtDate resignFirstResponder];
    [txtWeight resignFirstResponder];
    [txtHeight resignFirstResponder];
}

@end
