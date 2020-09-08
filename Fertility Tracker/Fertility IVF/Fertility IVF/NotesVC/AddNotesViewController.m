//
//  AddNotesViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "AddNotesViewController.h"
#import "MyCommonFunctions.h"

@implementation AddNotesViewController

@synthesize noteDetail,reqForUpdate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    
    //Wed 24/12/2014, 4:00 pm
    if (reqForUpdate)
    {
        lblDate.text = noteDetail.date;
        txtDescp.text = noteDetail.descp;
        doneBtn.alpha = 0;
        footerView.alpha = 1;
    }
    else
    {
        lblDate.text = [appDelegate formatDate:[NSDate date] ToFormat:[NSString stringWithFormat:@"EEE %@, hh:mm a",appDelegate.deviceDateFormat]];
        [txtDescp becomeFirstResponder];
        doneBtn.alpha = 1;
        footerView.alpha = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)cancelBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)doneBtnAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    if ([txtDescp.text isEqualToString:@""])
    {
        alert.message = @"Please write your Note!";
        [alert show];
    }
    else
    {
        if (reqForUpdate)
            [self updateNote];
        else
            [self addNote];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)NewBtnAction:(id)sender
{
    txtDescp.text = @"";
    lblDate.text = [appDelegate formatDate:[NSDate date] ToFormat:[NSString stringWithFormat:@"EEE %@, hh:mm a",appDelegate.deviceDateFormat]];
    [txtDescp becomeFirstResponder];
    reqForUpdate = FALSE;
}

-(IBAction)deleteBtnAction:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Are you sure you want to delete this note?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Yes" otherButtonTitles:nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)menu2 didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
        [self deleteNote];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(BOOL)addNote
{
    NSString *queryString = [NSString stringWithFormat:@"insert into Notes (descp,note_date) values ('%@','%@');",txtDescp.text,[appDelegate formatDate:lblDate.text Format:[NSString stringWithFormat:@"EEE %@, hh:mm a",appDelegate.deviceDateFormat] ToFormat:@"MM/dd/yyyy"]];
    
    BOOL success = [MyCommonFunctions InsUpdateDelData:queryString];
    
    return success;
}

-(BOOL)updateNote
{
    NSString *queryString = [NSString stringWithFormat:@"update Notes set descp = '%@', date = '%@' where note_id=%i;",txtDescp.text,lblDate.text,noteDetail.noteID];
    
    BOOL success = [MyCommonFunctions InsUpdateDelData:queryString];
    
    return success;
}

-(void)deleteNote
{
    NSString *queryString = [NSString stringWithFormat:@"delete from Notes where id = %i",noteDetail.noteID];
    BOOL success = [MyCommonFunctions InsUpdateDelData:queryString];
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.33];
    doneBtn.alpha = 1;
    footerView.alpha = 1;
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtDescp resignFirstResponder];
    
    if (!reqForUpdate)
        footerView.alpha = 0;
}

@end

