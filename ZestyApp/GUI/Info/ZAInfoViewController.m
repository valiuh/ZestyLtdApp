//
//  ZASomeInfoViewController.m
//  Zesty
//
//  Created by Антон on 06.02.15.
//  Copyright (c) 2015 ZestyLtd. All rights reserved.
//

#import "ZAInfoViewController.h"

@interface ZAInfoViewController ()

@end

@implementation ZAInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCurrentViews];
}

-(void) initCurrentViews {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"infoPage" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    if ( [self.sender isEqualToString:@"About Zesty"] ) {
        
        self.titleLabel.text = @"About Zesty";
        self.infoText.text = [dict objectForKey:@"aboutZesty"];
        
    } else if ([self.sender isEqualToString:@"Press"]){
        
        self.titleLabel.text = @"Press Enquiries";
        self.infoText.text = [dict objectForKey:@"press"];
        
    } else if ([self.sender isEqualToString:@"Trust & Safety"]){
        
        self.titleLabel.text = @"Trust & Safety";
        self.infoText.text = [dict objectForKey:@"trust"];
        
    } else if ([self.sender isEqualToString:@"Privacy Policy"]){
        
        self.titleLabel.text = @"Privacy Policy";
        self.infoText.text = [dict objectForKey:@"privacy"];
       
    } else if ([self.sender isEqualToString:@"Terms & Conditions"]){
        
        self.titleLabel.text = @"Terms & Conditions";
        self.infoText.text = [dict objectForKey:@"terms"];
        
    }
}

@end
