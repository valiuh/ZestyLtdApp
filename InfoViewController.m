//
//  InfoViewController.m
//  Zesty
//
//  Created by George Goldhagen on 26/08/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import "InfoViewController.h"
#import "ViewController.h"
#import "SWRevealViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:87.0/255.0 blue:158.0/255.0 alpha:1.0];
    UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 93, 20)];
    [title setContentMode:UIViewContentModeScaleAspectFit];
    title.image = [UIImage imageNamed:@"zestyLogo"];
    self.navigationItem.titleView = title;
    //setup the uibarbuttonitems
    UIBarButtonItem *phoneButton = [[UIBarButtonItem alloc]
                                    initWithImage:[UIImage imageNamed:@"callIcon"]
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(call:)];
    self.navigationItem.rightBarButtonItem = phoneButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"menuIcon"]
                                   style:UIBarButtonItemStylePlain
                                   target:self.revealViewController
                                   action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zestyLondonSB"]];

    
    self.sideBarText = [[UIScrollView alloc]initWithFrame:self.view.frame];
    [self.sideBarText setContentSize:CGSizeMake(320, 800)];
    self.sideBarText.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.sideBarText];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel:(UIBarButtonItem *)sender
{
    //go back to the login page
        
}
-(void)call:(UIBarButtonItem *)sender
{
    //    NSString *phoneNumber = @"0203 287 5416";
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    NSLog(@"phoneIcon pressed");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Need help?"
                                                    message:@"Contact the Zesty Customer Support Team."
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Call Zesty", nil];
    
    [alert show];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
