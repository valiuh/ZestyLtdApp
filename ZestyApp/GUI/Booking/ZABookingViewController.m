//
//  bookingViewController.m
//  ZestyApp
//
//  Created by George Goldhagen on 24/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import "ZABookingViewController.h"
#import "ZAHomeViewController.h"

@interface ZABookingViewController ()
{
    NSMutableData *_responseData;
}
@property (nonatomic) BOOL ishome;
@end

@implementation ZABookingViewController
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
    
    self.zestyBooking = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 504)];
    self.zestyBooking.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0];
    self.zestyBooking.delegate = self;
    [self.view addSubview:self.zestyBooking];
    
    self.loadingPage = [[UIView alloc]initWithFrame:self.view.frame];
    self.loadingPage.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zestyLondonSB"]];
    self.loadingPage.hidden = NO;
    [self.view addSubview:self.loadingPage];
    
    self.loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 90, 240, 30)];
    self.loadingLabel.text = @"Loading practices now";
    [self.loadingLabel setFont:[UIFont fontWithName:@"GothamNarrow-Medium" size:24.0f]];
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.backgroundColor = [UIColor clearColor];
    [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
    self.loadingLabel.hidden = NO;
    [self.view addSubview:self.loadingLabel];
    [self.view bringSubviewToFront:self.loadingLabel];
    
    _ishome = YES;
    
    self.urlAddress = [NSString stringWithFormat:@"https://ios.zesty.co.uk/find/%@/%@/1",self.searchService, self.searchLocation];
//
////    self.urlAddress = [NSString stringWithFormat:@"http:ios.staging.zesty.co.uk/find/%@/%@/1",self.searchService, self.searchLocation];
//
////    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
////    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
//    
//    NSURL *url = [NSURL URLWithString:self.urlAddress];
//    NSURLRequest* requestObj = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    // Create the request.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlAddress]];
    
    // Create url connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];

    [self.zestyBooking loadRequest:request];
    
    NSLog(@"%@",self.urlAddress);
    NSLog(@"%@", self.searchService);
    
    self.ishome = YES;
    
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if ([trustedHosts containsObject:challenge.protectionSpace.host])
    
    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
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

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_ishome == YES) {
        
        _ishome = !_ishome;
        
        //create an activity indicator to give user feedback
        self.activityIndicator =[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = CGPointMake(self.view.frame.size.width/2, 180);
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidden = NO;
        [self.view addSubview:self.activityIndicator];
        [self.view bringSubviewToFront:self.activityIndicator];
        
        self.loadingPage.hidden = NO;
        
        self.loadingLabel.hidden = NO;
        
        NSLog(@"start spinning");
    }
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}

  
//
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"stop spinning");
    
    self.zestyBooking.hidden = NO;
    self.loadingPage.hidden = YES;
    self.loadingLabel.hidden = YES;

    [self.activityIndicator stopAnimating];
    
}

//- (void)webViewDidFinishLoading:(UIWebView *)zestyBooking
//{
//    
//    NSLog(@"page loaded");
//    
//   
////    [self.activityIndicator stopAnimating];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView firstOtherButtonIndex]){
        //Phone clicked
        NSString *value=@"02032875416";
        NSURL *url = [[ NSURL alloc ] initWithString:[NSString stringWithFormat:@"tel://%@",value]];
        [[UIApplication sharedApplication] openURL:url];
    }
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
