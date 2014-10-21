//
//  EPLoginViewController.h
//  EzyParking
//
//  Created by Ben Zhang on 10/21/14.
//  Copyright (c) 2014 Sunny Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface EPLoginViewController : UIViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *notNowButton;
- (IBAction)notNowButtonPressed:(id)sender;

@end
