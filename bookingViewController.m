//
//  bookingViewController.m
//  ZestyApp
//
//  Created by George Goldhagen on 24/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import "bookingViewController.h"
#import "viewController.h"

@interface bookingViewController ()
@property (nonatomic) BOOL ishome;
@end

@implementation bookingViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
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
                                   initWithImage:[UIImage imageNamed:@"backIcon"]
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.zestyBooking = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.zestyBooking.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0];
    self.zestyBooking.delegate = self;
    [self.view addSubview:self.zestyBooking];
    
    self.urlAddress = [NSString stringWithFormat:@"http://www.staging.zesty.co.uk/find/%@/%@/1",self.searchService, self.searchLocation];
    
    NSURL *url = [NSURL URLWithString:self.urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.zestyBooking loadRequest:requestObj];
    
    NSLog(@"%@",self.urlAddress);
    NSLog(@"%@", self.searchService);
    
    self.ishome = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)wv shouldStartLoadWithRequest:(NSURLRequest *)rq
{


    return YES;
}

//-(void)webViewDidStartLoad:(UIWebView *)webView
//{
//    //create an activity indicator to give user feedback
//    self.activityIndicator =[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    self.activityIndicator.center=self.view.center;
//    [self.activityIndicator startAnimating];
//    self.activityIndicator.hidden = NO;
//    [self.view addSubview:self.activityIndicator];
//    [self.view bringSubviewToFront:self.activityIndicator];
//    
//    NSLog(@"start spinning");
//}
//
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    
//    NSLog(@"stop spinning");
//    
//    [self.activityIndicator stopAnimating];
//}

//- (void)webViewDidFinishLoading:(UIWebView *)zestyBooking
//{
//    
//    NSLog(@"stop spinning");
//   
//    [self.activityIndicator stopAnimating];
//}


-(IBAction)cancel:(UIBarButtonItem *)sender
{
    //go back to the login page
   
    NSLog(@"back to login page");
    
    if (self.zestyBooking.request.URL.absoluteString != self.urlAddress) {
         [self.navigationController popToRootViewControllerAnimated:YES];
        self.navigationController.navigationBar.translucent = YES;

    }else{
        NSURL *url = [NSURL URLWithString:self.urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.zestyBooking loadRequest:requestObj];
    }
    
    self.currentURL = self.zestyBooking.request.URL.absoluteString;
    NSLog(@"%@",self.currentURL);
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

@end
