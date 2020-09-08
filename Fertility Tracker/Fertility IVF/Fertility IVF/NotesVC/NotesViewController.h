//
//  NotesViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "MyCommonFunctions.h"

@interface NotesViewController : UIViewController<UISearchBarDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UISearchBar *txtSearchBar;
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UILabel *lblNoRecord;
    
    NSMutableArray *notesArray;
    NSMutableArray *filteredArray;
}
@end
