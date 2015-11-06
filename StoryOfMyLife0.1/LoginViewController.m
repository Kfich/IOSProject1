//
//  LoginViewController.m
//  StoryOfMyLife0.1
//
//  Created by Kevin Fich on 8/30/15.
//  Copyright (c) 2015 Kevin Fich. All rights reserved.
//

#import "LoginViewController.h"

#define kOFFSET_FOR_KEYBOARD 50.0

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.hidesBackButton = YES;
    [self.view setBackgroundColor:[UIColor clearColor]];
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

- (IBAction)login:(id)sender {
    
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];


    if ([username length] == 0 || [password length] == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ooops" message:@"Make sure you enter a username and password!" delegate:nil cancelButtonTitle:@"Danks" otherButtonTitles:nil];
        [alertView show];
    }else{
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
            if(error){
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry" message:[error.userInfo objectForKey:@"error"]
                                          delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
    
}

@end

