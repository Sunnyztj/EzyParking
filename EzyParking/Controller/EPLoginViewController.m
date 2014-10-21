//
//  EPLoginViewController.m
//  EzyParking
//
//  Created by Ben Zhang on 10/21/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import "EPLoginViewController.h"

@implementation EPLoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginView.delegate = self;
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    // do any additional setup after loading the view, typically from a nib
}


- (IBAction)notNowButtonPressed:(id)sender {
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
    NSString *theAccessToken = [[[FBSession activeSession] accessTokenData] accessToken];
    [self performSegueWithIdentifier:@"segueGoToMainView" sender:self];
    
}
@end
