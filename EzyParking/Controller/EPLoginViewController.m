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
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
    // do any additional setup after loading the view, typically from a nib
}
@end
