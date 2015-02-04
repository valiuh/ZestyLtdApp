//
//  sideBarTableViewController.h
//  ZestyApp
//
//  Created by George Goldhagen on 23/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZASideBarTableViewController : UITableViewController <UITableViewDelegate, UIWebViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic) UITableView *mainTable;
@property (nonatomic) NSArray *sideBarIcons1;
@property (nonatomic) NSArray *sideBarIcons2;

@end
