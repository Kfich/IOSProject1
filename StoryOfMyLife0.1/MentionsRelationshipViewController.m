//
//  MentionsRelationshipViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 9/14/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "MentionsRelationshipViewController.h"

@interface MentionsRelationshipViewController ()

@end

@implementation MentionsRelationshipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFUser *currentUser = [PFUser currentUser];
    
    self.currentUsernameLabel.text = @"Me";
    self.currentUserHometownLabel.text = [currentUser objectForKey:@"hometown"];
    
    self.currentUserImage.layer.cornerRadius = 60.0f;
    self.currentUserImage.layer.masksToBounds = YES;
    self.currentUserImage.layer.borderWidth = 0;
    
    self.userImage.layer.cornerRadius = 60.0f;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
    
    
    PFFile *imageFile2 = [currentUser objectForKey:@"imageFile"];
    
    if(imageFile2 != nil){
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile2.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        UIImage *userImage = [UIImage imageWithData:imageData];
        
        
        self.currentUserImage.image = userImage;
        
    }else{
        
        self.currentUserImage.image = [UIImage imageNamed:@"no_image.png"];
        
        
    }
    
    
    
    self.usernameLabel.text = [self.selectedUser objectForKey:@"username"];
    self.hometownLabel.text = [self.selectedUser objectForKey:@"hometown"];
    
    PFFile *imageFile = [self.selectedUser objectForKey:@"imageFile"];
    
    if(imageFile != nil){
        NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
        NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
        
        UIImage *userImage = [UIImage imageWithData:imageData];
        
        
        self.userImage.image = userImage;
        
    }else{
        
        self.userImage.image = [UIImage imageNamed:@"no_image.png"];

        
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showRelationshipEntries"]){
        
        MentionsContainerViewController *containerView = (MentionsContainerViewController *)segue.destinationViewController;
        containerView.otherUser = self.selectedUser;
        

    
    }
    
}

@end
