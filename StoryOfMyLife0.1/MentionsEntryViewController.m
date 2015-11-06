//
//  MentionsEntryViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/14/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "MentionsEntryViewController.h"

@interface MentionsEntryViewController ()

@end

@implementation MentionsEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.entryTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f]];
    self.entryTextView.textAlignment = NSTextAlignmentCenter;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self.selectedEntry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
        if (error) {
            NSLog(@"Error: %@", [error userInfo]);
        }else{
            
            NSString *author = [NSString stringWithFormat:@"Author:  %@ ",[self.selectedEntry objectForKey:@"Username"]];
            NSString *date = [NSString stringWithFormat:@"Made: %@ ",[self.selectedEntry objectForKey:@"entryDate"]];
            
            
            self.titleLabel.text = [self.selectedEntry objectForKey:@"entryTitle"];
            self.dateLabel.text = date;
            self.authorLabel.text = author;
            
            PFFile *imageFile = [self.selectedEntry objectForKey:@"imageFile"];
            
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];
            
            
            [self.entryTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f]];
            self.entryTextView.textAlignment = NSTextAlignmentCenter;
            
            
            //
            
            // self.entryTextView.text = [self.selectedEntry objectForKey:@"entryBody"];
            
            if (imageFile != nil) {
                
                //          [self.entryTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f]];
                //          self.entryTextView.textAlignment = NSTextAlignmentCenter;
                
                NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                
                UIImage *entryImage = [UIImage imageWithData:imageData];
                
                [self resizeImage:entryImage toWidth:self.view.frame.size.width andHeight:self.view.frame.size.height/1.6];
                
                // creates a text attachment with an image
                
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

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float) width andHeight:(float)height{
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
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
