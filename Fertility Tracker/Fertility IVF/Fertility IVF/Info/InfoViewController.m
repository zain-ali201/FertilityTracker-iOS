//
//  InfoViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "InfoViewController.h"
#import "DisclaimerViewController.h"

@implementation InfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSDate *pickedYear = [NSDate date];
    
    lblVersion.text = [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    lblYear.text = [NSString stringWithFormat:@"© %@ IVF Tracker.",[dateFormatter stringFromDate:pickedYear]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)disclaimerBtnAction:(id)sender
{
    NSString *viewName = [appDelegate CheckDevice:@"DisclaimerViewController" iPhone5:@"DisclaimerViewControllerIphone5" iPAD:@""];
    DisclaimerViewController *discVC = [[DisclaimerViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
    discVC.fromInfoVC = TRUE;
    [self.navigationController pushViewController:discVC animated:YES];
}

-(IBAction)fbBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.facebook.com"]];
}

-(IBAction)twitterBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.twitter.com"]];
}

-(IBAction)linkedInBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.linkedin.com"]];
}

-(IBAction)sendMail:(UIButton*)button
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate =self;
        
        [mailController setToRecipients:[NSArray arrayWithObjects:@"abc@abc.com",nil]];
        
        NSString *emailBody = [NSString stringWithFormat:@"<html><body><br/><br/><br/><p>Sent Via <a href='http://www.google.com'>My IVF Tracker</a></p> </body></html>"];
        [mailController setMessageBody:emailBody isHTML:YES];
        [self.navigationController presentViewController:mailController animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign In" message:@"Please add mail account to your device. Go to device settings and add account!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"My IVF Tracker" message:@"E-Mail sent successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)webBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sprintsols.com"]];
}

@end
