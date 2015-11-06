//
//  EditSettingsViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 10/11/15.
//  Copyright © 2015 Kevin Fich. All rights reserved.
//

#import "EditSettingsViewController.h"

@interface EditSettingsViewController () <UIActionSheetDelegate,UINavigationControllerDelegate ,UIImagePickerControllerDelegate>

@end

@implementation EditSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *currentUser = [PFUser currentUser];
    
    self.usernameField.text = [currentUser objectForKey:@"username"];
    self.emailField.text = [currentUser objectForKey:@"email"];
    self.hometownField.text = [currentUser objectForKey:@"hometown"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editProfileImage:(id)sender {
    
    if (self.image == nil) {
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        self.imagePicker.allowsEditing = NO;
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Hold On A Sec!"
                                      message:@"Please select a source type for your photo."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* camera = [UIAlertAction
                             actionWithTitle:@"Camera"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self presentViewController:self.imagePicker animated:NO completion:nil];
                                 
                                 
                                 
                             }];
        UIAlertAction* library = [UIAlertAction
                                 actionWithTitle:@"Photo Library"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self presentViewController:self.imagePicker animated:NO completion:nil];
                                     
                                     
                                 }];
        
        [alert addAction:camera];
        [alert addAction:library];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
        
    }
    
}


- (IBAction)submitChanges:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *confirmPassword = [self.confirmPasswordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *hometown = [self.hometownField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0 || [hometown length] == 0 || ![password isEqualToString:confirmPassword]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Something's Not Right.." message:@"Please make sure you enter all fields" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
    }else{
        
        PFUser *updatedUser = [PFUser currentUser];
        updatedUser.username = username;
        updatedUser.password = password;
        updatedUser.email = email;
        
        updatedUser[@"hometown"] = hometown;
        
        // [self setPickedImage:_pickedImage forNewUser:newUser];
        
        
        [updatedUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }else{
                
               // [self uploadProfileImage];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"We're All Set." message:@"Your changes were submitted successfully! \n Please sign in again to make sure everything checks out!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
                
                [PFUser logOut];
                [self performSegueWithIdentifier:@"showLoginView" sender:self];
                
            }
            
    }];
}
}

#pragma mark - Image Picker Controller Delegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
    [self.tabBarController setSelectedIndex:0];
}


- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        //A photo was taken/selected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self uploadProfileImage];
        
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
            
        }
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"We're All Set."
                                  message:@"Your profile picture has been updated."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self presentViewController:self.imagePicker animated:NO completion:nil];
                                 
                                 
                                 
                             }];
    
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - Helper methods


- (void)uploadProfileImage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.image != nil) {
        UIImage *newImage = [self newSize:self.image];
        
        //[self resizeImage:self.image toWidth:150.0f andHeight:150.0f];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
        
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"There Was A Problem :("
                                      message:@"Please try selecting the image again!"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }else{
            
            PFUser *currentUser = [PFUser currentUser];
            currentUser[@"fileType"] = fileType;
            currentUser[@"imageFile"] = file;
            
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"Sorry About That.."
                                              message:@"Please try uploading the photo again!"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                    
                }else{
                    // Everything went well
                    self.image = nil;
                    
                }
            }];
        }
        
    }];
    
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float) width andHeight:(float)height{
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

-(UIImage *)newSize:(UIImage *)image{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
