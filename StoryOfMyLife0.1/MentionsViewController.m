//
//  MentionsViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/31/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "MentionsViewController.h"

@interface MentionsViewController () <UIScrollViewDelegate>

@end

@implementation MentionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    clicked = NO;
    [self.view setBackgroundColor:[UIColor clearColor]];

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self.view setBackgroundColor:[UIColor clearColor]];

    
    clicked = NO;
    
    self.friendsRelation = [[PFUser currentUser] relationForKey:@"friendsRelation"];
    self.mentionRelation = [[PFUser currentUser] relationForKey:@"mentionRelation"];
    
    // PFUser *currentUser = [PFUser currentUser];
    
    self.entries = [[NSArray alloc] init];
    
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
/*
        
        PFQuery *query = [self.mentionRelation query];
        [query orderByDescending:@"updatedAt"];
        query.limit = 20;
        [indicator startAnimating];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            if (error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                
            }else{
                //We found the messages y'all
                self.mentionedFriends = objects;
              //  NSLog(@"Number of Recent Friends: %lu", (unsigned long)[self.mentionedFriends count]);
                [indicator stopAnimating];
              //  [self createRecentsScrollMenu];
                
            }
            
        }];

  */
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"DiaryEntry"];
    [query2 whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query2 orderByDescending:@"createdAt"];
    query2.limit = 20;
    [indicator startAnimating];

    // execute the query
    [query2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@", [error userInfo]);
        }else{
            [indicator stopAnimating];

            
            self.entries = objects;
             [self createEntryScrollMenu];
            
            
            self.selectedEntry = [self.entries objectAtIndex:0];
            
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
                
                [self resizeImage:entryImage toWidth:entryImage.size.height andHeight:self.view.frame.size.height/1.6];
                
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



- (void)createEntryScrollMenu{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.recentMentionsView.frame.size.height)];
    scrollView.delegate = self;
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:YES];
    
    [self scrollViewDidScroll:scrollView];
    
    int buttonX = 15;
    int i = 0;
    
    if (self.entries.count == 0) {
       
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2.0f, self.view.frame.size.width, self.view.frame.size.height/3.0f)];
        
        button.tag = i;
        i ++;
        [[button titleLabel] setTextAlignment: NSTextAlignmentCenter];
        
        [button setBackgroundColor:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:0.5f]];
        NSString *entryDetails = [NSString stringWithFormat:@"Click Here To Add A Friend To Mention!"];
        
        [button setTitle:entryDetails forState:UIControlStateNormal];
        
        [[button layer] setBorderWidth:2.0f];
        [[button layer] setBorderColor:[UIColor grayColor].CGColor];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
        
        
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        
        [button addTarget:self action:@selector(showFriendsView:)
         forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }else{
        
        for (PFObject *ent in self.entries)
            
        {
            
            PFObject *entry = ent;
            
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, scrollView.frame.size.height/3.0f + 3, 75, 75)];
            
            button.tag = i;
            i ++;
            [[button titleLabel] setTextAlignment: NSTextAlignmentCenter];
            
            [button setBackgroundImage:[UIImage imageNamed:@"no_image.png"] forState:UIControlStateNormal];
            NSString *entryDetails = [NSString stringWithFormat:@"By: %@ ", [entry objectForKey:@"Username"]];
            
            [button setTitle:entryDetails forState:UIControlStateNormal];
            
            [[button layer] setBorderWidth:2.0f];
            [[button layer] setBorderColor:[UIColor grayColor].CGColor];
            button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12.0f];
            
            
            button.layer.cornerRadius = 10;
            button.clipsToBounds = YES;
            
            [scrollView addSubview:button];
            
            buttonX = buttonX+button.frame.size.width + 25.0f;
            
            [button addTarget:self action:@selector(showThumbnailView:)
             forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        
    }
    
    UIView *entriesView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, buttonX, scrollView.frame.size.height/3.0)];
    entriesView.backgroundColor = [UIColor colorWithRed:247/255.0 green:232/255.0 blue:55/255.0 alpha:0.50f];
    
    
    [scrollView addSubview:entriesView];
    
    UILabel *entriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,entriesView.frame.size.height/4.5f , 200, entriesView.frame.size.height - 20)];
    
    [entriesLabel setTextColor:[UIColor blackColor]];
    [entriesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:23.0f]];
    [entriesLabel setBackgroundColor:[UIColor clearColor]];
    [entriesLabel setText:@"Recent Mentions"];
    
    [scrollView addSubview:entriesLabel];
    
    scrollView.contentSize = CGSizeMake(buttonX, scrollView.frame.size.height);
    //scrollView.backgroundColor = [UIColor clearColor];
    [self.recentMentionsView addSubview:scrollView];
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0  ||  scrollView.contentOffset.y < 0 )
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0);
}

-(void)showThumbnailView:(UIButton*)sender

{
    self.selectedEntry = [self.entries objectAtIndex:sender.tag];
    
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
        
        [self resizeImage:entryImage toWidth:entryImage.size.width andHeight:entryImage.size.height];
        
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


-(void)showFriendsView:(UIButton*)sender{
    [self performSegueWithIdentifier:@"showAddUsers" sender:self];

    
}

#pragma mark - Helper Methods


- (UIImage *)resizeImage:(UIImage *)image toWidth:(float) width andHeight:(float)height{
    
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRectangle = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:newRectangle];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    
}
*/

@end
