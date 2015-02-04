//
//  bookingViewController.h
//  ZestyApp
//
//  Created by George Goldhagen on 24/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZABookingViewController : UIViewController <UIWebViewDelegate, NSURLSessionDelegate>

@property (nonatomic, strong) UIWebView *zestyBooking;
@property(nonatomic) NSString *searchLocation;
@property(nonatomic) NSString *searchService;
@property (nonatomic) NSString *urlAddress;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UILabel *loadingLabel;
@property (nonatomic) UIView *loadingPage;
@property(nonatomic) NSString *currentURL;
@end
