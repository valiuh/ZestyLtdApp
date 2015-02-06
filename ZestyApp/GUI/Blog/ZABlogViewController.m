//
//  ZABlogViewController.m
//  Zesty
//
//  Created by Антон on 05.02.15.
//  Copyright (c) 2015 ZestyLtd. All rights reserved.
//

#import "ZABlogViewController.h"

@interface ZABlogViewController ()

@end

@implementation ZABlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBlog];
}

-(void) loadBlog {
    NSString * urlAddress = [NSString stringWithFormat:@"http://blog.zesty.co.uk/"];
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.blogWebview loadRequest:requestObj];
}

@end
