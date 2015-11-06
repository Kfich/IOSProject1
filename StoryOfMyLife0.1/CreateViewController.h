//
//  CreateViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/30/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EditFriendsViewController.h"
#import "MentionFriendsViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+ResizeMagick.h"

@interface CreateViewController : UIViewController {
    BOOL submitWasPressed;

    
}

@property (strong, nonatomic) PFObject *diaryEntry;

@property (weak, nonatomic) IBOutlet UITextField *entryTitle;

@property (weak, nonatomic) IBOutlet UITextView *entryTextField;

@property (strong, nonatomic) NSDate *entryDate;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) NSMutableArray *imageFilesArray;

@property (nonatomic, strong) NSMutableArray *recipients;

@property (nonatomic, strong) PFRelation  *entryRelation;

@property (nonatomic, strong) PFFile *imageFile;

@property (strong, nonatomic) IBOutlet UIView *accessoryView;

@property (strong, nonatomic) NSTimer *caretVisibilityTimer;

@property (nonatomic, assign) CGRect oldRect;
@property (weak, nonatomic) NSString *placeHolder;

- (IBAction)keyboardDismiss:(id)sender;


@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;


- (IBAction)submitDiaryEntry:(id)sender;

- (IBAction)imageButtonWasPressed:(id)sender;


- (IBAction)clear:(id)sender;

- (void) clearEntryFields;

@end
