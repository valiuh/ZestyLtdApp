//
//  sideBarTableViewController.m
//  ZestyApp
//
//  Created by George Goldhagen on 23/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import "ZASideBarTableViewController.h"
#import "SWRevealViewController.h"
#import "ZAHomeViewController.h"
#import "ZABlogViewController.h"
#import "ZAInfoViewController.h"


@interface ZASideBarTableViewController ()

@end

@implementation ZASideBarTableViewController

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

    self.tableView.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0f];
//    self.tableView.backgroundColor = [UIColor clearColor];
    
//    UIView *backgroundTable = [[UIView alloc]initWithFrame:self.view.frame];
//    backgroundTable.backgroundColor = [UIColor redColor];
//    [self.view addSubview:backgroundTable];
//    [self.view sendSubviewToBack:backgroundTable];
    
    self.tableView.separatorColor = [UIColor colorWithRed:87.0/255.0 green:107.0/255.0 blue:135.0/255.0 alpha:0.50];
    
    //Initialize the iconArray
    self.sideBarIcons1 = [[NSMutableArray alloc]initWithObjects:@"homeSB",@"zestySB",@"pressSB.png",@"blogSB.png", nil];
    self.sideBarIcons2 = [[NSMutableArray alloc]initWithObjects:@"trustSB",@"termsSB",@"privacySB", nil];
    
    //Initialize the dataArray
    self.dataArray = [[NSMutableArray alloc] init];
    
    //First section data
    NSArray *firstItemsArray = [[NSArray alloc] initWithObjects:@"Home",@"About Zesty", @"Press", @"Blog", nil];
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
    
    cell.backgroundColor = [UIColor colorWithRed:55.0/255.0 green:86.0/255.0 blue:129.0/255.0 alpha:0.50];
//    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellBackground"]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 12, 200, 30)];
    [cell.contentView addSubview:label];
    label.text = cellValue;
    label.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:18.0f];
    label.textColor = [UIColor whiteColor];
    label.tag = indexPath.row;
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(73/255.0) green:(114/255.0) blue:(171/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;

    cell.tag = indexPath.row;
    
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 20 , 20)];
    if (indexPath.section == 0){
        imv.image = [UIImage imageNamed:[self.sideBarIcons1 objectAtIndex:indexPath.row]];
        if (cell.tag == 0) {

            imv.tintColor = [UIColor whiteColor];
            
        }
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    } else if(section == 1){
        return 30;
    }
    
    return YES;
}


-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    if([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        UITableViewHeaderFooterView *headerIndexText = (UITableViewHeaderFooterView *)view;
        [headerIndexText.textLabel setTextColor:[UIColor whiteColor]];
        headerIndexText.textLabel.font = [UIFont fontWithName:@"GothamNarrow-Book" size:20.0f];
        headerIndexText.textLabel.textAlignment = NSTextAlignmentLeft;
        
       
    } else {
        NSLog(@"This is the new iOS case where the delegate gets called on a custom view.");
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0){
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 30, tableView.frame.size.width, 18)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        NSString *string =[NSString stringWithFormat:@"Discover Zesty"];
        label.font = [UIFont fontWithName:@"GothamNarrow-Book" size:20.0f];
        label.textColor = [UIColor whiteColor];
        /* Section header is in 0th index... */
        [label setText:string];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor clearColor]]; //your background color...
        
        return view;

    }
    
    if(section == 1){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, tableView.frame.size.width, 10)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        NSString *string =[NSString stringWithFormat:@"Zesty Information"];
        label.font = [UIFont fontWithName:@"GothamNarrow-Book" size:20.0f];
        label.textColor = [UIColor whiteColor];
        /* Section header is in 0th index... */
        [label setText:string];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor clearColor]]; //your background color...
        
        return view;

    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *selectedCell = nil;
    NSDictionary *dictionary = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"data"];
    selectedCell = [array objectAtIndex:indexPath.row];
    
    
    NSLog(@"%@", selectedCell);
    
    if ([selectedCell isEqualToString:@"Home"]) {
        
        [self performSegueWithIdentifier:@"showHome" sender:selectedCell];

    } else if ([selectedCell isEqualToString:@"Blog"]){
        
        [self performSegueWithIdentifier:@"showBlog" sender:selectedCell];
        
    } else {
        
        [self performSegueWithIdentifier:@"showInfo" sender:selectedCell];

    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"showInfo"]){
        ZAInfoViewController *infoScreen = (ZAInfoViewController *)segue.destinationViewController;
        infoScreen.sender = sender;
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            
            
        };
        
    }
    
}

@end