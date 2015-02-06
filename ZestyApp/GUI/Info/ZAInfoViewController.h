//
//  ZASomeInfoViewController.h
//  Zesty
//
//  Created by Антон on 06.02.15.
//  Copyright (c) 2015 ZestyLtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZABaseNavBarViewController.h"

@interface ZAInfoViewController : ZABaseNavBarViewController

@property (nonatomic) id sender;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *infoText;

@end
