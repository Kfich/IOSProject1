//
//  ArchiveDetailViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/6/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "ArchiveDetailViewController.h"

@interface ArchiveDetailViewController () <UIScrollViewDelegate>

@end

@implementation ArchiveDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.selectedEntry fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
        
        if (error) {
            NSLog(@"Error: %@", [error userInfo]);
        }else{
  
            if ([self.selectedEntry objectForKey:@"recipientIds"] != nil && self.currentUserIsSender) {
                self.mentionedFriendsView.hidden = NO;
                [self findMentionedFriends:self.currentUserIsSender];
                
                UIEdgeInsets insets = self.entryTextView.contentInset;
                insets.bottom = self.mentionedFriendsView.frame.size.height;
                self.entryTextView.contentInset = insets;
                
                insets = self.entryTextView.scrollIndicatorInsets;
                insets.bottom = self.mentionedFriendsView.frame.size.height;
                self.entryTextView.scrollIndicatorInsets = insets;
                
            }else{
                
                self.mentionedFriendsView.hidden = YES;
                
            }
    
            NSString *author = [NSString stringWithFormat:@"Author:  %@ ",[self.selectedEntry objectForKey:@"Username"]];
            NSString *date = [NSString stringWithFormat:@"Made: %@ ",[self.selectedEntry objectForKey:@"entryDate"]];

            
            self.titleLabel.text = [self.selectedEntry objectForKey:@"entryTitle"];
            self.dateLabel.text = date;
            self.authorLabel.text = author;
            self.userImage.image = [UIImage imageNamed:@"no_image.png"];

            
            PFFile *imageFile = [self.selectedEntry objectForKey:@"imageFile"];
            
            UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];

            
            [self.entryTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f]];
            self.entryTextView.textAlignment = NSTextAlignmentCenter;
            
            UIEdgeInsets insets = self.entryTextView.contentInset;
            insets.left = 2.0f;
            insets.right = 2.0f;
            insets.top = 1.0f;

            
            
            //
            
           // self.entryTextView.text = [self.selectedEntry objectForKey:@"entryBody"];
            
            if (imageFile != nil) {
                
      //          [self.entryTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f]];
      //          self.entryTextView.textAlignment = NSTextAlignmentCenter;
                
                NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                
                UIImage *entryImage = [UIImage imageWithData:imageData];
                [entryImage resizedImageByWidth:self.view.frame.size.width];
                
                // creates a text attachment with an image
                
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                
                attachment.image = entryImage;
                
                NSMutableAttributedString *imageAttrString = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
                
                
                // sets the paragraph styling of the text attachment
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
                
                [paragraphStyle setAlignment:NSTextAlignmentCenter];            // centers image horizontally
                
                [paragraphStyle setParagraphSpacing:1];   // adds some padding between the image and the following section
               
                NSString *string = [self.selectedEntry objectForKey:@"entryBody"];
                NSRange range = NSMakeRange(0, 0);
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

#pragma mark - Helper Methods

-(NSArray *)findMentionedFriends:(BOOL)isSender{
    
    if (isSender) {
        
        PFRelation *entryRelation = [self.selectedEntry relationForKey:@"entryRelation"];
        
        
        PFQuery *query = [entryRelation query];
        [query orderByAscending:@"username"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }else{
                //We found the messages y'all
                
                self.mentionedFriendsArray = objects;
                [self createMentionedScrollMenu];

                
            }
            
        }];
        
    }else{
        // NSLog(@"Private Entry Sorry");
    }
    
    
    
    return self.mentionedFriendsArray;
}

#pragma mark - Scroll View Delegates

- (void)createMentionedScrollMenu{
    
    if (self.mentionedFriendsArray != nil) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.mentionedFriendsView.frame.size.height)];
        scrollView.delegate = self;
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:YES];
        [self scrollViewDidScroll:scrollView];
        
        int buttonX = 15;
        int i = 0;
        for (PFUser *mentionedFriend in self.mentionedFriendsArray)
        {
            PFUser *user = mentionedFriend;
            
            PFFile *imageFile = [user objectForKey:@"imageFile"];
            
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 10, 60, 60)];
            
            if(imageFile != nil){
                NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
                NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
                
                UIImage *entryImage = [UIImage imageWithData:imageData];
                
                
                [button setBackgroundImage:entryImage forState:UIControlStateNormal];
                
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"no_image.png"] forState:UIControlStateNormal];
                
            }
            
            button.tag = i;
            i ++;
            
            //[button setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
            [[button titleLabel] setTextAlignment: NSTextAlignmentCenter];
            
            //        [button setBackgroundImage:[UIImage imageNamed:@"icn_noimage.png"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"%@", user.username] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
            
            [[button layer] setBorderWidth:2.0f];
            [[button layer] setBorderColor:[UIColor grayColor].CGColor];
            
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            
            [scrollView addSubview:button];
            buttonX = buttonX+button.frame.size.width + 25.0f;
            [button addTarget:self action:@selector(showRelationshipView:)
                  forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        scrollView.contentSize = CGSizeMake(buttonX, scrollView.frame.size.height);
        scrollView.backgroundColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        [self.mentionedFriendsView addSubview:scrollView];
        
    }
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
}


#pragma mark - Helper methods

-(void)showRelationshipView:(UIButton*)sender
{
  //  clicked = YES;
    
    self.selectedFriend = [self.mentionedFriendsArray objectAtIndex:sender.tag];
    [self performSegueWithIdentifier:@"showFriendRelation" sender:self];
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showFriendRelation"]){
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
        MentionsRelationshipViewController *relationshipViewController = (MentionsRelationshipViewController *)segue.destinationViewController;
        relationshipViewController.selectedUser = self.selectedFriend;
  
    }
    
    
}




@end
