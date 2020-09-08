//
//  SettingsViewController.m
//  Fertility IVF
//
//  Created by Sprint on 24/02/2019.
//  Copyright © 2019 Tconnect. All rights reserved.
//

#import "SettingsViewController.h"
#import "ProfileViewController.h"
#import "InfoViewController.h"


@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)backBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)profileBtnAction:(id)sender
{
    ProfileViewController *profileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [self.navigationController pushViewController:profileVC animated:YES];
}

-(IBAction)infoBtnAction:(id)sender
{
    InfoViewController *infoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController"];
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (IBAction)inviteBtnACtion:(id)sender
{
    NSString *message = @"IVF Tracker Application by Sprint Solutions";
    NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/us/developer/zain-ali/id1169007782?mt=8"];
    NSArray *postItems = @[message, url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:postItems
                                            applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}


-(IBAction)moreAppsBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/developer/zain-ali/id1169007782?mt=8"]];
}

-(IBAction)rateBtnAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/developer/zain-ali/id1169007782?mt=8"]];
}

-(IBAction)feedbackBtnAction:(id)sender
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setSubject:@"IVF Tracker Feedback"];
        [mailController setToRecipients:[NSArray arrayWithObjects:@"info@sprintsols.com",nil]];
        
        [self presentViewController:mailController
                           animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"IVF Tracker" message:@"Email received successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
