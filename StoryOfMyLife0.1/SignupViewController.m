//
//  SignupViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/30/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController () <UIActionSheetDelegate,UINavigationControllerDelegate ,UIImagePickerControllerDelegate>

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
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

- (IBAction)signup:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailAdressField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *hometown = [self.hometownField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([username length] == 0 || [password length] == 0 || [email length] == 0 || [hometown length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Make sure you enter a username, password & email bruh!" delegate:nil cancelButtonTitle:@"Danks" otherButtonTitles:nil];
        [alertView show];
        
    }else{
        
        PFUser *newUser = [PFUser user];
        newUser.username = username;
        newUser.password = password;
        newUser.email = email;
        
        newUser[@"hometown"] = hometown;
        
      // [self setPickedImage:_pickedImage forNewUser:newUser];
        
        
        [newUser  signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }else{
                
            //    [self.navigationController popToRootViewControllerAnimated:YES];
                
                if (self.image == nil) {
                    
                    self.imagePicker = [[UIImagePickerController alloc] init];
                    self.imagePicker.delegate = self;
                    
                    self.imagePicker.allowsEditing = NO;
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Welcome to Story Of My Life." message:@"We aren't too social here, but You do need to show face. \n \n Please select a profile picture!"
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
    else{
        //A video was taken/seleted
        self.videoFilePath = (__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)){
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}


#pragma mark - Helper methods

- (void)uploadProfileImage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    if (self.image != nil) {
        UIImage *newImage = [self newSize:self.image];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"image.png";
        fileType = @"image";
        
    }else{
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
        
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"An Error Occurred"
                                      message:@"Please try sending the message again!"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
        }else{
            
            PFUser *currentUser = [PFUser currentUser];
            
            currentUser[@"fileType"] = fileType;
            currentUser[@"imageFile"] = file;
            
            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"An Error Occurred"
                                              message:@"Please try sending the message again!"
                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                    
                }else{
                    // Everything went well
               //     [self reset];
                    [self.navigationController popToRootViewControllerAnimated:YES];


                }
            }];
        }
        
    }];
    
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float) width andHeight:(float)height{
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRectangle];
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
