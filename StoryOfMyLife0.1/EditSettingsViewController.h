//
//  EditSettingsViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 10/11/15.
//  Copyright © 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>


@interface EditSettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordField;

@property (weak, nonatomic) IBOutlet UITextField *emailField;


@property (weak, nonatomic) IBOutlet UITextField *hometownField;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;


- (IBAction)editProfileImage:(id)sender;

- (IBAction)submitChanges:(id)sender;


@end
