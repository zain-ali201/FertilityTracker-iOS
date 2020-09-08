//
//  NotesViewController.m
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import "NotesViewController.h"
#import "AddNotesViewController.h"

@implementation NotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getListRecords];
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

-(IBAction)cancelBtnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)addBtnAction:(id)sender
{
    NSString *viewName = [appDelegate CheckDevice:@"AddNotesViewController" iPhone5:@"AddNotesViewControllerIphone5" iPAD:@""];
    AddNotesViewController *addNoteVC = [[AddNotesViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
    addNoteVC.reqForUpdate = FALSE;
    [self.navigationController pushViewController:addNoteVC animated:YES];
}

-(void)getListRecords
{
    notesArray = [[NSMutableArray alloc]init];
    sqlite3_stmt *ReturnStatement = (sqlite3_stmt *) [MyCommonFunctions getStatement:@"Select * from Notes"];
    {
        while(sqlite3_step(ReturnStatement) == SQLITE_ROW)
        {
            NSString *noteID = ((char *)sqlite3_column_text(ReturnStatement, 0)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 0)] : @"";
            
            NSString *descp = ((char *)sqlite3_column_text(ReturnStatement, 1)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 1)] : @"";
            
            NSString *date = ((char *)sqlite3_column_text(ReturnStatement, 2)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(ReturnStatement, 2)] : @"";
            
            NoteObject *noteDetail = [[NoteObject alloc]init];
            noteDetail.noteID = [noteID intValue];
            noteDetail.descp = descp;
            noteDetail.date = date;
            
            [notesArray addObject:noteDetail];
        }
    }
    
    filteredArray = [[NSMutableArray alloc]initWithArray:notesArray];
}

-(void)fillMainScrollView
{
    for(UIView *view in mainScrollView.subviews)
        [view removeFromSuperview];
    
    if (filteredArray.count > 0)
    {
        lblNoRecord.hidden = YES;
        
        float YAxis = 0.0;
        
        for (int i = 0; i < filteredArray.count; i++)
        {
            NoteObject *noteDetail = [filteredArray objectAtIndex:i];
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, YAxis, 306.0, 50.0)];
            
            UILabel *lblDate = [[UILabel alloc]initWithFrame:CGRectMake(7.0, 8.0, 200.0, 17.0)];
            [lblDate setBackgroundColor:[UIColor clearColor]];
            [lblDate setFont:[UIFont systemFontOfSize:11.0]];
            [lblDate setTextColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
            [lblDate setText:noteDetail.date];
            
            UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(7.0, 22.0, 200.0, 17.0)];
            [lblName setBackgroundColor:[UIColor clearColor]];
            [lblName setFont:[UIFont systemFontOfSize:13.0]];
            [lblName setTextColor:[UIColor colorWithRed:137.0/255.0 green:80.0/255.0 blue:125.0/255.0 alpha:1]];
            [lblName setText:noteDetail.descp];
            
            UIImageView *arrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(282.0, 15.0, 11.0, 20.0)];
            [arrowImgView setImage:[UIImage imageNamed:@"right_arrow.png"]];
            
            UIImageView *lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(7.0, 49.0, 287.0, 1.0)];
            [lineImgView setImage:[UIImage imageNamed:@"line.png"]];
            
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 306.0, 50.0)];
            btn.tag  = i + 1000;
            [btn addTarget:self action:@selector(noteDetailBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [view addSubview:lblDate];
            [view addSubview:lblName];
            [view addSubview:arrowImgView];
            [view addSubview:lineImgView];
            [view addSubview:btn];
            
            [mainScrollView addSubview:view];
            
            YAxis += 50.0;
        }
        [mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, YAxis)];
    }
        else
        {
            lblNoRecord.hidden = NO;
        }
}

-(IBAction)noteDetailBtnAction:(UIButton*)button
{
    NSString *viewName = [appDelegate CheckDevice:@"AddNotesViewController" iPhone5:@"AddNotesViewControllerIphone5" iPAD:@""];
    AddNotesViewController *addNoteVC = [[AddNotesViewController alloc]initWithNibName:viewName bundle:[NSBundle mainBundle]];
    addNoteVC.noteDetail = [filteredArray objectAtIndex:button.tag-1000];
    addNoteVC.reqForUpdate = TRUE;
    [self.navigationController pushViewController:addNoteVC animated:YES];
}

#pragma mark UISearchbar

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        filteredArray = [[NSMutableArray alloc]initWithArray:notesArray];
    }
    else
    {
        filteredArray = [[NSMutableArray alloc] init];
        
        for (NoteObject *detail in notesArray)
        {
            NSRange nameRange1 = [detail.descp rangeOfString:text options:NSCaseInsensitiveSearch];
            
            NSRange nameRange2 = [detail.date rangeOfString:text options:NSCaseInsensitiveSearch];
            
            if(nameRange1.location != NSNotFound)
            {
                [filteredArray addObject:detail];
            }
            else if(nameRange2.location != NSNotFound)
            {
                [filteredArray addObject:detail];
            }
        }
    }
    [self fillMainScrollView];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    NSLog(@"User canceled search");
    [searchBar setText:@""];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
//    filteredArray = [[NSMutableArray alloc]initWithArray:mainArray];
//    [self fillScrollView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [txtSearchBar resignFirstResponder];
}

@end
