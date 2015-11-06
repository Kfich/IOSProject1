//
//  MentionsRelationshipEntryViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/27/15.
//  Copyright © 2015 Kevin Fich. All rights reserved.
//

#import "MentionsRelationshipEntryViewController.h"

@interface MentionsRelationshipEntryViewController ()

@end

@implementation MentionsRelationshipEntryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIEdgeInsets insets = self.entryTextView.contentInset;
    insets.left = 2.0f;
    insets.right = 2.0f;
    insets.top = 1.0f;
    
    PFObject *senderID = [self.selectedEntry objectForKey:@"UserID"];
    PFQuery *senderQuery = [PFQuery queryWithClassName:@"User"];
    [senderQuery whereKey:@"objectId" equalTo:senderID];
    
    [senderQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }else{

            _sender = [objects objectAtIndex:0];
            
        }
    }];

    
    [self.selectedEntry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if (error) {
            NSLog(@"Error: %@", [error userInfo]);
        }else{
            
            NSString *author = [NSString stringWithFormat:@"Author:  %@ ",[self.selectedEntry objectForKey:@"Username"]];
            NSString *date = [NSString stringWithFormat:@"Made: %@ ",[self.selectedEntry objectForKey:@"entryDate"]];
            
            
            self.titleLabel.text = [self.selectedEntry objectForKey:@"entryTitle"];
            self.dateLabel.text = date;
            self.authorLabel.text = author;
            
            
            PFFile *userImageFile = [_sender objectForKey:@"imageFile"];
            
            if(userImageFile != nil){
                NSURL *imageFileUrl = [[NSURL alloc] initWithString:userImageFile.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                
                UIImage *userImage = [UIImage imageWithData:imageData];
                
                
                self.userImage.image = userImage;
                
            }else{
                
                self.userImage.image = [UIImage imageNamed:@"no_image.png"];
                
                
            }
            

            PFFile *imageFile = [self.selectedEntry objectForKey:@"imageFile"];
            
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];
            
            
            [self.entryTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f]];
            self.entryTextView.textAlignment = NSTextAlignmentCenter;
            
            
            // self.entryTextView.text = [self.selectedEntry objectForKey:@"entryBody"];
            
            if (imageFile != nil) {
                
                //          [self.entryTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f]];
                //          self.entryTextView.textAlignment = NSTextAlignmentCenter;
                
                NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                
                UIImage *entryImage = [UIImage imageWithData:imageData];                // creates a text attachment with an image
                
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                
                attachment.image = entryImage;
                
                NSMutableAttributedString *imageAttrString = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
                
                
                // sets the paragraph styling of the text attachment
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
                
                [paragraphStyle setAlignment:NSTextAlignmentCenter];            // centers image horizontally
                
                [paragraphStyle setParagraphSpacing:1];   // adds some padding between the image and the following section
                
                NSString *string = [self.selectedEntry objectForKey:@"entryBody"];
                NSRange range = [string rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
                NSString *myString = [string stringByReplacingCharactersInRange:range withString:@" \n \n"];
                
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:myString];
                
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [imageAttrString length])];
                
                [imageAttrString appendAttributedString:attributedString];
                
                [imageAttrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [imageAttrString length])];
                
                [imageAttrString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [imageAttrString length])];
                
                // NSRange cursorPosition = [_entryTextView selectedRange];
                
                //      [attributedString replaceCharactersInRange:NSMakeRange(0, 0) withAttributedString:attrStringWithImage];
                
                //  self.entryTextView.textContainerInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 100.0);
                
                self.entryTextView.attributedText = imageAttrString;
                
            }else{
                
                self.entryTextView.text = [self.selectedEntry objectForKey:@"entryBody"];
                
                
            }
            
        }
        
    }];
    
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

@end
