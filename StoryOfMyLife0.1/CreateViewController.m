//
//  CreateViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/30/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "CreateViewController.h"

#define kOFFSET_FOR_KEYBOARD 20.0


@interface CreateViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>{

}
@end


@implementation CreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.entryTextField setDelegate:self];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    tap.numberOfTapsRequired = 2;
    
    [self.view addGestureRecognizer:tap];
    //[self.entryTextField addGestureRecognizer:tap];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
    self.entryRelation = [self.diaryEntry relationForKey:@"entryRelation"];
    
   // self.recipients = [[NSMutableArray alloc] init];
    
    submitWasPressed = NO;

    
    [self.entryTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f]];
    [self.entryTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f]];
    self.entryTextField.textAlignment = NSTextAlignmentCenter;
    
    self.entryTextField.inputAccessoryView = self.accessoryView;
    self.entryTextField.text = @"Tap Here To Start Creating!";
    
    UIEdgeInsets insets = self.entryTextField.contentInset;
    insets.left = 2.0f;
    insets.right = 2.0f;
    insets.top = 1.0f;
    

}
- (void) viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.entryTextField setDelegate:self];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    
    _diaryEntry = [PFObject objectWithClassName:@"DiaryEntry"];

    
    [self.entryTextField setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f]];
    self.entryTextField.textAlignment = NSTextAlignmentCenter;
    
    [self.entryTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:24.0f]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *now = [NSDate date];
    NSString *prettyDate = [formatter stringFromDate:now];
    [self.dateLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:15.0f]];
    self.dateLabel.text = prettyDate;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                    object:nil];
    
}


#pragma marks - IBActions (Things were pressed ;))

- (IBAction)imageButtonWasPressed:(id)sender {
    
    if ([self.entryTextField.text isEqualToString:@"Tap Here To Start Creating!"]) {
        self.entryTextField.text = @"";
    }
    

    if (self.image == nil){
        
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        
        self.imagePicker.allowsEditing = NO;
        // self.imagePicker.videoMaximumDuration = 10;
        
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Hold On A Sec!"
                                      message:@"Please select a source type for your photo."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Camera"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self presentViewController:self.imagePicker animated:NO completion:nil];


                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Photo Library"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self presentViewController:self.imagePicker animated:NO completion:nil];

                                     
                                 }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
 

       
      //  self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
    }
    
}

#pragma mark - Location delegate methods





#pragma mark - Entry Submission delegate

- (IBAction)submitDiaryEntry:(id)sender {
    submitWasPressed = YES;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    
    if(_diaryEntry != nil){
        
        [indicator startAnimating];
    
    [_diaryEntry setObject:self.entryTitle.text forKey:@"entryTitle"];
    [_diaryEntry setObject:self.entryTextField.text forKey:@"entryBody"];
    [_diaryEntry setObject:self.dateLabel.text forKey:@"entryDate"];
    [_diaryEntry setObject:[[PFUser currentUser] objectId] forKey:@"UserID"];
    [_diaryEntry setObject:[[PFUser currentUser] username] forKey:@"Username"];
     
        if (_imageFile != nil) {
            _diaryEntry[@"imageFile"] = _imageFile;
            _diaryEntry[@"fileType"] = @"image";
        }
        
    [_diaryEntry saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            // There was a problem.
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"An Error Occurred"
                                      message:@"Please try sending the message again!"
                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
        } else {
            // The object was saved
            [self clearEntryFields];
            [indicator stopAnimating];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Hold On A Sec! \n Would you like to mention a friend?"
                                          message:@"Remember! Only the people mentioned have access to see the entry exists."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertController * successAlert=   [UIAlertController
                                          alertControllerWithTitle:@"Success!"
                                          message:@"Your entry was successfully submitted. \n Keep building your story."
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                   actionWithTitle:@"Sure!"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
            
            
            UIAlertAction* sure = [UIAlertAction
                                 actionWithTitle:@"Sure!"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     [self performSegueWithIdentifier:@"showFriendList" sender:self];
                                    // _diaryEntry = [PFObject objectWithClassName:@"DiaryEntry"];


                                     
                                 }];
            UIAlertAction* noThanks = [UIAlertAction
                                     actionWithTitle:@"No, thanks"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         [self presentViewController:successAlert animated:YES completion:nil];
                                       //  _diaryEntry = [PFObject objectWithClassName:@"DiaryEntry"];

                                         

                                         
                                         
                                     }];
            UIAlertAction* cancel = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                           [self.diaryEntry deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                               if (error) {
                                                    NSLog(@"Error %@ %@", error, [error userInfo]);
                                               }else{
                                                   _diaryEntry = [PFObject objectWithClassName:@"DiaryEntry"];

                                               }
                                               
                                           }];
                                           
                                       }];
            
            [alert addAction:sure];
            [alert addAction:noThanks];
            [alert addAction:cancel];
            
            [successAlert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
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
        
        
        [self setPickedImage:self.image];
        self.image = nil;
        
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}


- (void) setPickedImage:(UIImage *)pickedImage{
    
    if (pickedImage == nil) {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"An Error Occurred"
                                  message:@"Please try selecting the image again!"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
    }else{
        NSData *fileData;
        NSString *fileName;
        NSString *fileType;
        
        UIImage *resizedImage = [pickedImage resizedImageByWidth:self.view.frame.size.width];
        //[self newSize:pickedImage];
                
        fileData = UIImagePNGRepresentation(resizedImage);
        fileName = @"image.png";
        fileType = @"image";
        
        _imageFile = [PFFile fileWithName:fileName data:fileData];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_entryTextField.text];
        
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = resizedImage;
        
        NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
        
        NSRange cursorPosition = [_entryTextField selectedRange];
        
        [attributedString replaceCharactersInRange:cursorPosition withAttributedString:attrStringWithImage];
        
        _entryTextField.attributedText = attributedString;
        
    }
    
    //[self reset];
    
}


#pragma mark - Keyboard delegates

// Version 1

- (void)_keyboardWillShowNotification:(NSNotification*)notification
{
    if ([self.entryTextField isFirstResponder]) {
        
        UIEdgeInsets insets = self.entryTextField.contentInset;
        insets.bottom = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        self.entryTextField.contentInset = insets;
        
        insets = self.entryTextField.scrollIndicatorInsets;
        insets.bottom = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        self.entryTextField.scrollIndicatorInsets = insets;
    }
    
    
}

- (void)_keyboardWillHideNotification:(NSNotification*)notification
{
    if ([self.entryTextField isFirstResponder]) {
    
        UIEdgeInsets insets = self.entryTextField.contentInset;
        insets.bottom -= [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
        self.entryTextField.contentInset = insets;
        
        insets = self.entryTextField.scrollIndicatorInsets;
        insets.bottom -= [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
        self.entryTextField.scrollIndicatorInsets = insets;
    }

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Tap Here To Start Creating!"]) {
        textView.text = @"";
    }
    
    _oldRect = [self.entryTextField caretRectForPosition:self.entryTextField.selectedTextRange.end];
    _caretVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(_scrollCaretToVisible) userInfo:nil repeats:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
   [_caretVisibilityTimer invalidate];
   _caretVisibilityTimer = nil;
}

- (void)_scrollCaretToVisible
{
    //This is where the cursor is at.
    CGRect caretRect = [self.entryTextField caretRectForPosition:self.entryTextField.selectedTextRange.end];
    
    if(CGRectEqualToRect(caretRect, _oldRect))
        return;
    
    _oldRect = caretRect;
    
    //This is the visible rect of the textview.
    CGRect visibleRect = self.entryTextField.bounds;
    visibleRect.size.height -= (self.entryTextField.contentInset.top + self.entryTextField.contentInset.bottom/2);
    visibleRect.origin.y = self.entryTextField.contentOffset.y;
    
    //We will scroll only if the caret falls outside of the visible rect.
    if(!CGRectContainsRect(visibleRect, caretRect))
    {
        CGPoint newOffset = self.entryTextField.contentOffset;
        
        newOffset.y = MAX((caretRect.origin.y + caretRect.size.height) - visibleRect.size.height + 5, 0);
        
        [self.entryTextField setContentOffset:newOffset animated:YES];
    }else{
        return;
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)dismissKeyboard {
    [self.entryTextField resignFirstResponder];
    [self.view endEditing:YES];
}



- (IBAction)keyboardDismiss:(id)sender {
    [self.entryTextField resignFirstResponder];
    [self.view endEditing:YES];
    
}

#pragma mark - Other delegates
- (IBAction)clear:(id)sender {
    
    [self clearEntryFields];
}



- (void) clearEntryFields{
    
    self.entryTitle.text = @"";
    self.entryTextField.text = @"";
    self.image = nil;
    self.imageFile = nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSDate *now = [NSDate date];
    NSString *prettyDate = [formatter stringFromDate:now];
    self.dateLabel.text = prettyDate;
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showFriendList"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        MentionFriendsViewController *mentionFriendsView = (MentionFriendsViewController *)segue.destinationViewController;
        mentionFriendsView.entryRelation = self.entryRelation;
        mentionFriendsView.entry = self.diaryEntry;
        
    }
    
}

@end
