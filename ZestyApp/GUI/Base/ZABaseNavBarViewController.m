//
//  ZABaseInfiViewController.m
//  Zesty
//
//  Created by Антон on 06.02.15.
//  Copyright (c) 2015 ZestyLtd. All rights reserved.
//

#import "ZABaseNavBarViewController.h"
#import "SWRevealViewController.h"

@interface ZABaseNavBarViewController ()

@end

@implementation ZABaseNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBar];
}


-(void) initNavigationBar {
    
    self.navigationController.navigationBar.translucent = YES;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zestyLondonSB"]];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:87.0/255.0 blue:158.0/255.0 alpha:1.0];
    
    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 93, 20)];
    [title setContentMode:UIViewContentModeScaleAspectFit];
    title.image = [UIImage imageNamed:@"zestyLogo"];
    self.navigationItem.titleView = title;
    
    
    UIBarButtonItem *phoneButton = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"callIcon"]
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onCall:)];
    self.navigationItem.rightBarButtonItem = phoneButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"menuIcon"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(onMenu:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    
}


- (void)onMenu:(UIBarButtonItem *)sender {
    if ( self.revealViewController ) {
        [self.revealViewController revealToggle: self];
    }
}



- (void)onCall:(UIBarButtonItem *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need help?"
                                                    message:@"Contact the Zesty Customer Support Team."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Call Zesty", nil];
    
    [alert show];
}

@end
