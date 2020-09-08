//
//  AddNotesViewController.h
//  Fertility IVF
//
//  Created by Tconnect on 12/25/14.
//  Copyright (c) 2014 Tconnect. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "NoteObject.h"

@interface AddNotesViewController : UIViewController<UIActionSheetDelegate,UITextViewDelegate>
{
    AppDelegate *appDelegate;
    
    IBOutlet UILabel *lblDate;
    IBOutlet UITextView *txtDescp;
    
    IBOutlet UIButton *doneBtn;
    
    IBOutlet UIView *footerView;
}
@property BOOL reqForUpdate;
@property(nonatomic,retain) NoteObject *noteDetail;
@end
