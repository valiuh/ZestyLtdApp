//
//  sideBarTableViewController.m
//  ZestyApp
//
//  Created by George Goldhagen on 23/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import "sideBarTableViewController.h"
#import "SWRevealViewController.h"


@interface sideBarTableViewController ()

@end

@implementation sideBarTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0f];
//    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zestyLondon"]];
    
    //    self.tableView.backgroundColor = [
    self.tableView.separatorColor = [UIColor whiteColor];
 
    //Initialize the iconArray
    self.sideBarIcons1 = [[NSMutableArray alloc]initWithObjects:@"zestyIcon",@"pressSB.png",@"blogSB.png", nil];
    self.sideBarIcons2 = [[NSMutableArray alloc]initWithObjects:@"trustSB",@"termsSB",@"privacySB", nil];
    
    //Initialize the dataArray
    self.dataArray = [[NSMutableArray alloc] init];
    
    //First section data
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"About Zesty", @"Press", @"Blog", nil];
    NSDictionary *firstItemsArrayDict = [NSDictionary dictionaryWithObject:firstItemsArray forKey:@"data"];
    [self.dataArray addObject:firstItemsArrayDict];
    
    //Second section data
    NSArray *secondItemsArray = [[NSArray alloc] initWithObjects:@"Trust & Safety", @"Terms & Conditions", @"Privacy Policy", nil];
    NSDictionary *secondItemsArrayDict = [NSDictionary dictionaryWithObject:secondItemsArray forKey:@"data"];
    [self.dataArray addObject:secondItemsArrayDict];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // Number of rows it should expect should be based on the section
    NSDictionary *dictionary = [self.dataArray objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"data"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    NSString *cellValue = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:18.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:89.0/255.0 blue:156.0/255.0 alpha:0.50];
    
//    cell.textLabel.frame = CGRectMake(0, 20, 100, 60);
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10 , 15, 20 , 20)];
    if (indexPath.section == 0){
        imv.image = [UIImage imageNamed:[self.sideBarIcons1 objectAtIndex:indexPath.row]];
    }else if(indexPath.section == 1){
        imv.image = [UIImage imageNamed:[self.sideBarIcons2 objectAtIndex:indexPath.row]];
    }
    [cell.contentView addSubview:imv];

//    cell.imageView.image = [self.sideBarIcons objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"    Discover Zesty";
    if(section == 1)
        return @"    Legal";
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    } else if(section == 1){
        return 40;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
 
    header.textLabel.textColor = [UIColor whiteColor];
    header.backgroundView.backgroundColor = [UIColor clearColor];
    header.textLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size:20.0f];
    header.textLabel.textAlignment = NSTextAlignmentLeft;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedCell = nil;
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    selectedCell = [array objectAtIndex:indexPath.row];
    
    NSLog(@"%@", selectedCell);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end