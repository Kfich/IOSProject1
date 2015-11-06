//
//  SignupViewController.h
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/30/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;

@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UITextField *emailAdressField;
@property (weak, nonatomic) IBOutlet UITextField *hometownField;


@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *videoFilePath;



- (IBAction)signup:(id)sender;
//- (void) setPickedImage:(UIImage *)pickedImage forNewUser:(PFUser *)user;

- (void) uploadProfileImage;



@end
