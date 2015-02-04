//
//  InfoViewController.h
//  Zesty
//
//  Created by George Goldhagen on 26/08/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZAInfoViewController : UIViewController

@property (nonatomic) NSString *urlAddress;

@property (nonatomic) UIWebView *blogPage;

@property (nonatomic) UIScrollView *sideBarText;

@property (nonatomic) UITextView *infoText;

@property (nonatomic) UILabel *infoPageTitle;

@end