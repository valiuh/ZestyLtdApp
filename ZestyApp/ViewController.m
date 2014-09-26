//
//  ViewController.m
//  ZestyApp
//
//  Created by George Goldhagen on 03/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "iconCell.h"
#import "bookingViewController.h"


@interface ViewController ()
//@property (nonatomic) BOOL up;

@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;
@property (nonatomic, strong) NSIndexPath *selectedRowIndexPath;

@property (strong, nonatomic) UIViewController *rightViewController;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

@end
//BOOL selectedCell;
//BOOL isSelectable;
BOOL showServices;
CLGeocoder *geocoder;
CLPlacemark *placemark;
UITapGestureRecognizer *screenTap;
UIPanGestureRecognizer *labelBackgroundDrag;

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    [self.navigationController.navigationBar setTranslucent:NO];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    
    //make the screen tap recogniser
    self.screenTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector (dismissKeyboard)];
    [self.screenTap setDelegate:self];
    [self.view addGestureRecognizer:self.screenTap];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"zestyLondon"]];

    self.scroll = [[UIScrollView alloc]init];

//    if( IS_IPHONE_5 )
//    {
//        [self.scroll setFrame:CGRectMake(0, 64, 320, 640)];
//        // set the content size to be the size our our whole frame
////        self.scroll.contentSize = CGSizeMake(320, 634);
//    }
//    else
//    {
//        [self.scroll setFrame:CGRectMake(0, 0, 320, 480/2)];
//        // set the content size to be the size our our whole frame
////        self.scroll.contentSize = CGSizeMake(320, 480/2);
//    }
//    self.scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, 320, 575)];
//    self.scroll.backgroundColor = [UIColor colorWithRed:48.0/255.0 green:89.0/255.0 blue:156.0/255.0 alpha:1.0];
    self.scroll.backgroundColor = [UIColor clearColor];

    [self.scroll setContentMode:UIViewContentModeScaleAspectFit];
    // then set frame to be the size of the view's frame
    self.scroll.frame = CGRectMake(0, 64, 320, 640);
    self.scroll.contentSize = CGSizeMake(320, 660);
    // now add our scroll view to the main view
    self.scroll.scrollEnabled = YES;
    self.scroll.userInteractionEnabled = YES;
    self.scroll.bounces = YES;
    [self.scroll setShowsHorizontalScrollIndicator:NO];
    [self.scroll setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.scroll];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:.50];
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
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"menuIcon"]
                                       style:UIBarButtonItemStylePlain
                                       target:nil
                                       action:nil];
    self.navigationItem.leftBarButtonItem = menuButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];

    
    // Set the sidebar button action. When it's tapped, it'll show up the sidebar.
    self.navigationItem.leftBarButtonItem.target = self.revealViewController;
    self.navigationItem.leftBarButtonItem.action = @selector(revealToggle:);
    // Set the gestures up so the sideBar can be closed
    // Set the gesture
    SWRevealViewController *revealController = [self revealViewController];
    [revealController resignFirstResponder];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    

    //
    //
    //setup textField background panel
    self.labelBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
    self.labelBackground.backgroundColor = [UIColor clearColor];
    [self.scroll addSubview:self.labelBackground];
//    labelBackgroundDrag = [[UIPanGestureRecognizer alloc]
//                                            initWithTarget:self
//                                                    action:@selector(labelBackgroundDown)];
//    [self.labelBackground addGestureRecognizer:labelBackgroundDrag];
    
    //
    //
    //search title label text
    self.searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, 320, 20)];
    self.searchLabel.text = @"Find and book Healthcare in London";
    self.searchLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:18.0f];
    self.searchLabel.textColor = [UIColor whiteColor];
    [self.searchLabel setTextAlignment:NSTextAlignmentCenter];
    [self.labelBackground addSubview:self.searchLabel];

    //
    //
    //setup the location label
    self.location = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, self.view.frame.size.width - 40, 35)];
    self.location.delegate = self;
    self.location.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:16.0f];
    [self.location setTag:2];
    self.location.placeholder = @"Enter your Postcode or Area";
    [self.location setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
//    [self.location setAlpha:0.5];
    [self.location  setKeyboardAppearance:UIKeyboardAppearanceLight];
//    [self.location setTextColor:[UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0]];
    [self.location setTextColor:[UIColor whiteColor]];
    [self.location.layer setCornerRadius:0.0f];
    [self.location setAdjustsFontSizeToFitWidth:NO];
    [self.location setTintColor:[UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0  alpha:1.0]];
    [self.location addTarget:self
                      action:@selector(editingBegun:)
            forControlEvents:UIControlEventEditingDidBegin];
    [self.location addTarget:self
                      action:@selector(editingEnded:)
            forControlEvents:UIControlEventEditingDidEnd];
    //customise the padding on the right side and add image icon to the left
    //left
    UIView *locationSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.location.frame.size.height)];
    self.locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 12.5, 12.5)];
    [self.locationIcon setContentMode:UIViewContentModeScaleAspectFill];
    self.locationIcon.image = [[UIImage imageNamed:@"geoPin"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [locationSpacerView addSubview:_locationIcon];
    [_location setLeftViewMode:UITextFieldViewModeAlways];
//    _locationIcon.tintColor = [UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0];
    _locationIcon.tintColor = [UIColor whiteColor];
    [self.location setLeftView:locationSpacerView];
    [locationSpacerView setUserInteractionEnabled:NO];
    //right
    UIView *locationPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _location.rightView = locationPaddingView;
    _location.rightViewMode = UITextFieldViewModeAlways;
    [locationPaddingView setUserInteractionEnabled:NO];
    [self.labelBackground addSubview:self.location];
    
    //
    //
    //setup the service label
    self.service = [[UITextField alloc] initWithFrame:CGRectMake(20, 85, self.view.frame.size.width - 40, 35)];
    self.service.delegate = self;
    self.service.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:16.0f];
    [self.service setTag:3];
    self.service.placeholder = @"What service do you need?";
    [self.service setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25]];
    [self.service  setKeyboardAppearance:UIKeyboardAppearanceLight];
//    [self.service setTextColor:[UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0]];
    [self.service setTextColor:[UIColor whiteColor]];
    [self.service.layer setCornerRadius:0.0f];
    [self.service setAdjustsFontSizeToFitWidth:NO];
    [self.service setTintColor:[UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0  alpha:1.0]];
    [self.service setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [self.service addTarget:self
                      action:@selector(editingBegun:)
            forControlEvents:UIControlEventEditingDidBegin];
    [self.service addTarget:self
                     action:@selector(editingChanged:)
           forControlEvents:UIControlEventEditingChanged];
    [self.service addTarget:self
                      action:@selector(editingEnded:)
            forControlEvents:UIControlEventEditingDidEnd];
    //customise the padding on the right side and add image icon to the left
    //left
    UIView *serviceSpacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.service.frame.size.height)];
    self.serviceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 16, 16)];
    [self.serviceIcon setContentMode:UIViewContentModeScaleAspectFill];
    self.serviceIcon.image = [[UIImage imageNamed:@"searchIcon"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [serviceSpacerView addSubview:_serviceIcon];
    [_service setLeftViewMode:UITextFieldViewModeAlways];
//    _serviceIcon.tintColor = [UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0];
    _serviceIcon.tintColor = [UIColor whiteColor];
    [self.service setLeftView:serviceSpacerView];
    [serviceSpacerView setUserInteractionEnabled:NO];
    //right
    UIView *servicePaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    _service.rightView = servicePaddingView;
    _service.rightViewMode = UITextFieldViewModeAlways;
    [servicePaddingView setUserInteractionEnabled:NO];
    [self.labelBackground addSubview:self.service];
    
    //
    //
    //view all services button below the collectionView
//    if( IS_IPHONE_5 )
    {self.viewServices = [[UIButton alloc]initWithFrame:CGRectMake(20, 328+20, self.view.frame.size.width-40, 48)];
//    }
//    else
//    {self.viewServices = [[UIButton alloc]initWithFrame:CGRectMake(20, 240 , self.view.frame.size.width-40, 48)];
//    }
    [self.viewServices setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3]];
    self.viewServices.titleLabel.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:20.0f];
    [self.viewServices setTitle:@"View All Services" forState:UIControlStateNormal];
    self.viewServices.layer.cornerRadius = 0.0f;
    self.viewServices.titleLabel.textColor = [UIColor whiteColor];
    self.viewServices.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.viewServices addTarget:self action:@selector(showServices:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewServices setTag:2];
    [self.scroll addSubview:self.viewServices];
    
    //
    //
    //setup findAppointments button
    self.findAppointments = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height-80-74+20, self.view.frame.size.width - 40, 50)];
    [self.findAppointments setTitle:@"Find Appointments" forState:UIControlStateNormal];
    self.findAppointments.titleLabel.font = [UIFont fontWithName:@"GothamNarrow-Bold" size:22.0f];
    [self.findAppointments.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.findAppointments setBackgroundImage:[UIImage imageNamed:@"findAppts"] forState:UIControlStateNormal];
    [self.findAppointments.layer setCornerRadius:8.0f];
    [self.findAppointments addTarget:self action:@selector(findAppointments:) forControlEvents:UIControlEventTouchUpInside];
    [self.findAppointments setTag:3];
    [self.scroll addSubview:self.findAppointments];
    
    allServices = [[NSMutableArray alloc] initWithObjects:@"Dental Hygienist", @"Health Screening", @"General Consultation",@"Travel Health",@"Private Sexual Health Services", @"NHS Sexual Health Services",@"Sports Massage", nil];
    
    pastUrls = [[NSMutableArray alloc] initWithObjects:@"Dentist",@"Dental Hygienist", @"Chiropractor",@"Health Screening", @"General Consultation",@"Travel Health",@"Private Sexual Health Services", @"NHS Sexual Health Services", @"Osteopathy", @"Private GP", @"Podiatrist",@"Sports Massage", @"Physiotherapy",@"Facial Fillers", @"Cosmetic Practitioner", @"Dermal Fillers", @"Laser Treatments", nil];
    
    sortedArray = [[NSMutableArray alloc] init];
    sortedArray = [pastUrls sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSLog(@"%@",sortedArray);
    
    
    iconLabel = [[NSMutableArray alloc] initWithObjects:@"Dentist",@"Podiatry",@"Physiotherapy",@"Chiropractor",@"Osteopathy",@"Private GP", nil];
    
    self.verticalIcons = [NSArray arrayWithObjects:@"dentist",@"podiatry",@"physio",@"chiro",@"osteo",@"privateGP", nil];
    
    self.verticalIconsSelected = [NSArray arrayWithObjects:@"dentistSelected",@"podiatrySelected",@"physioSelected",@"chiropractorSelected",@"osteoSelected",@"privateGPSelected", nil];
    
    autocompleteUrls = [[NSMutableArray alloc] init];
    
    //
    //
    //setup auto-complete for service textField
//    if( IS_IPHONE_5 )
//    {
        self.autocompleteTableView = [[UITableView alloc] initWithFrame:
                                      CGRectMake(20, 184, self.service.frame.size.width, allServices.count * 35) style:UITableViewStylePlain];
//
//    }
//    else
//    {
//        self.autocompleteTableView = [[UITableView alloc] initWithFrame:
//                                      CGRectMake(20, 184, self.service.frame.size.width, (allServices.count /2) * 35) style:UITableViewStylePlain];
//
//    }

    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    [self.autocompleteTableView setSeparatorColor:[UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:97.0/255.0  alpha:1.0]];
    self.autocompleteTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    [self.autocompleteTableView setBackgroundColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]];
    [self.view addSubview:self.autocompleteTableView];
    
    
    //
    //
    //setup auto-complete for service textField
//    if( IS_IPHONE_5 )
//    {
        self.startAutocompleteTableView = [[UITableView alloc] initWithFrame:
                                           CGRectMake(20, 184, self.service.frame.size.width, pastUrls.count * 35/2 - 10) style:UITableViewStylePlain];
        
//    }
//    else
//    {
//        self.startAutocompleteTableView = [[UITableView alloc] initWithFrame:
//                                           CGRectMake(20, 184, self.service.frame.size.width, pastUrls.count * 35/4 + 40) style:UITableViewStylePlain];
//        
//    }
    self.startAutocompleteTableView.delegate = self;
    self.startAutocompleteTableView.dataSource = self;
    self.startAutocompleteTableView.scrollEnabled = YES;
    self.startAutocompleteTableView.bounces = NO;
    self.startAutocompleteTableView.hidden = YES;
    [self.startAutocompleteTableView setSeparatorColor:[UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:97.0/255.0  alpha:1.0]];
    self.startAutocompleteTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.startAutocompleteTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.startAutocompleteTableView];
    
    //collection view
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
//    if( IS_IPHONE_5 )
    {_collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 204-64, 300, 206) collectionViewLayout:layout];
//    }
//    else
//    {_collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 204-74+5, 300, 206/2) collectionViewLayout:layout];
//    }
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    [_collectionView setScrollEnabled:YES];
    [_collectionView registerClass:[iconCell class] forCellWithReuseIdentifier:@"newCell"];
    [_collectionView setUserInteractionEnabled:YES];
    [_collectionView setShowsHorizontalScrollIndicator:NO];
    [_collectionView setShowsVerticalScrollIndicator:NO];
    [_collectionView setBackgroundColor:[UIColor clearColor]];
//    selectedCell = YES;
    [self.scroll addSubview:_collectionView];
//    [self.scroll bringSubviewToFront:_collectionView];
    geocoder = [[CLGeocoder alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [self.locationManager startUpdatingLocation];
//    [self animateSearchFieldsUp];
    
//    if( IS_IPHONE_5 )
//    {
        self.servicesTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 375+20, 280, 0)];
//
        
//    }
//    else
//    {
//        self.servicesTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 240+20, 280, 0)];
//
//    }
    self.servicesTableView.backgroundColor = [UIColor  clearColor];
    self.servicesTableView.scrollEnabled = YES;
    self.servicesTableView.bounces = NO;
    [self.servicesTableView setShowsHorizontalScrollIndicator:NO];
    [self.servicesTableView setShowsVerticalScrollIndicator:NO];
//    [self.servicesTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.servicesTableView setSeparatorColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.3]];
    [self.servicesTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 280, 0)];
    self.servicesTableView.layer.cornerRadius = 0.0f;
    self.servicesTableView.delegate = self;
    self.servicesTableView.dataSource = self;
    [self.scroll addSubview:self.servicesTableView];
    
    //add the move screen up functionality
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
        }
    }
}

-(void)showServices:(id)sender
{
    showServices = !showServices;

    
    if (showServices) {
        NSLog(@"expand the list");
        
        //expand the scrollable page
//        [self.scroll setFrame:CGRectMake(0, 0, 320, 640)];]
        
        [self.viewServices setTitle:@"Hide All Services" forState:UIControlStateNormal];
        
        if( IS_IPHONE_5 )
        {
            [self.scroll setContentSize:CGSizeMake(320, 800)];

        }
        else
        {
            [self.scroll setContentSize:CGSizeMake(320, 800)];

        }
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             //move the find appointments button to the bottom
                            
                             if( IS_IPHONE_5 )
                             {
                                 [self.findAppointments setFrame:CGRectMake(20, self.scroll.contentSize.height - 200-25+20, 280, 48)];
                                 
                                 [self.servicesTableView setFrame:CGRectMake(20, 375+20, 280, 180)];
                                 
                                 CGPoint bottomOffset = CGPointMake(0, self.scroll.contentSize.height - self.scroll.bounds.size.height);
                                 [self.scroll setContentOffset:bottomOffset animated:YES];
                                 
                                 
                             }
                             else
                             {
                                 [self.findAppointments setFrame:CGRectMake(20, self.scroll.contentSize.height - 300, 280, 48)];
                                 
                                 [self.servicesTableView setFrame:CGRectMake(20, 267+20, 280, 180)];
                                 
                                 CGPoint bottomOffset = CGPointMake(0, self.scroll.contentSize.height - self.scroll.bounds.size.height);
                                 [self.scroll setContentOffset:bottomOffset animated:YES];
                                 
                             }
                             
                             //show the tableview of other verticals

                             
                             
                         }completion:nil];
        
    } else if (!showServices){
        NSLog(@"close the list");
        
        [self.viewServices setTitle:@"View All Services" forState:UIControlStateNormal];

        
        //withdraw the scrollable page
       //move the find appointments button back up
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             if( IS_IPHONE_5 )
                             {
                                 [self.scroll setContentSize:CGSizeMake(320, 640)];
                                 
                                 [self.servicesTableView setFrame:CGRectMake(20, 375+20, 280, 0)];
                                 
                                 [self.findAppointments setFrame:CGRectMake(20, self.view.frame.size.height-80-74+20, self.view.frame.size.width - 40, 48)];

                                 
                             }
                             else
                             {
                                 [self.scroll setContentSize:CGSizeMake(320, 640)];
                                 
                                 [self.servicesTableView setFrame:CGRectMake(20, 267+20, 280, 0)];
                                 
                                 [self.findAppointments setFrame:CGRectMake(20, self.view.frame.size.height-180, self.view.frame.size.width - 40, 48)];

                                 
                             }
                             
                             
                             
                         }completion:nil];
        
        //hide the tableview of other verticals
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    [self.locationManager stopUpdatingLocation];
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.location.text = [NSString stringWithFormat:@"%@, %@", placemark.postalCode, placemark.subAdministrativeArea];
//            self.locationIcon.tintColor = [UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0  alpha:1.0];
            self.location.layer.borderWidth = 1.0f;
            [self.location.layer setBorderColor:[[UIColor whiteColor] CGColor]];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView firstOtherButtonIndex]){
        //Phone clicked
        NSString *value=@"02032875416";
        NSURL *url = [[ NSURL alloc ] initWithString:[NSString stringWithFormat:@"tel://%@",value]];
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)findAppointments:(id)sender{
    NSLog(@"go to the next screen: %@ %@", placemark.postalCode, self.service.text);
    if (self.location.text.length == 0 || self.service.text.length == 0) {
        UIAlertView *details = [[UIAlertView alloc] initWithTitle:@"Almost there!"
                                                          message:@"Make sure that you've entered your location correctly and have selected one of our services."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles: nil];
        [details show];
    } else {
         [self performSegueWithIdentifier:@"bookAppointments" sender:self];
    }

}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor colorWithRed:30.0/255.0 green:57.0/255.0 blue:99.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        }
    }
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
    
    [self.location resignFirstResponder];
    
    [self.service resignFirstResponder];
    
    self.autocompleteTableView.hidden = YES;

}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration
              curve:(int)curve degrees:(CGFloat)degrees
{
    // Setup the animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    // The transform matrix
    CGAffineTransform transform =
    CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
    image.transform = transform;
    
    // Commit the changes
    [UIView commitAnimations];
}

-(IBAction)editingBegun:(id)sender{
    

    
    if ([sender tag] == 2) {
        
        self.screenTap.enabled = YES;

        
        //Do some cool sh*t to the location text field
        self.autocompleteTableView.hidden = YES;
        [self.location.layer setBorderWidth:1.0f];
        [self.location.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//        self.locationIcon.tintColor = [UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0  alpha:1.0];
        
        [self rotateImage:self.locationIcon duration:0.2
                    curve:UIViewAnimationCurveEaseIn degrees:-90];
        
        UINavigationBar *navBar = self.navigationController.navigationBar;
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        float animationDuration;
        if(statusBarFrame.size.height > 20) { // in-call
            animationDuration = 0.2;
        } else { // normal status bar
            animationDuration = 0.2;
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:animationDuration animations:^{
            
            navBar.frame = CGRectMake(navBar.frame.origin.x,
                                      20,
                                      navBar.frame.size.width,
                                      navBar.frame.size.height);
            
        } completion:nil];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, 0, 320, 568);
        }];
        
    }
    else if([sender tag] == 3){
        
        self.screenTap.enabled = NO;

        UINavigationBar *navBar = self.navigationController.navigationBar;
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        float animationDuration;
        if(statusBarFrame.size.height > 20) { // in-call
            animationDuration = 0.2;
        } else { // normal status bar
            animationDuration = 0.2;
        }
        
   
        [[UIApplication sharedApplication] setStatusBarHidden:YES
                                                withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:animationDuration animations:^{
            navBar.frame = CGRectMake(navBar.frame.origin.x,
                                      -navBar.frame.size.height,
                                      navBar.frame.size.width,
                                      navBar.frame.size.height);
        } completion:nil];

        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, -120, 320, 768);}];
        
//        [self keyboardWillShow];
        
        self.scroll.scrollEnabled = NO;
        
        //Do some cool shit to the service text field
        [self.service.layer setBorderWidth:1.0f];
        [self.service.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//        self.serviceIcon.tintColor = [UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0  alpha:1.0];
        [self.startAutocompleteTableView setHidden:NO];

        [self rotateImage:self.serviceIcon duration:0.2
                    curve:UIViewAnimationCurveEaseIn degrees:100];
    }
}

-(IBAction)editingChanged:(id)sender{
    if ([sender tag] == 2) {
        
        self.autocompleteTableView.hidden = YES;

        
        //Do some cool shit to the location text field
    }else if([sender tag] == 3){
        if(self.service.text.length== 0){
        //Do some cool shit to the service text field
            [self keyboardWillShow];

        self.autocompleteTableView.hidden = YES;
            self.startAutocompleteTableView.hidden = NO;

        } else {
           //??
            self.startAutocompleteTableView.hidden = YES;
            self.scroll.scrollEnabled = YES;

            
            self.screenTap.enabled = YES;

            [self keyboardWillHide];
        }
    }
}

-(IBAction)editingEnded:(UITextField *)sender{
    NSLog(@"Location editing finished");
    //when editing is finished, keep border if the field has had input
    
    if (sender.text.length == 0) {
        
        NSLog(@"nothing left in the cell");
        sender.layer.borderWidth = 0.0f;

        if ([sender tag] == 2) {
            self.locationIcon.tintColor = [UIColor whiteColor];
            
            [self rotateImage:self.locationIcon duration:0.2
                        curve:UIViewAnimationCurveEaseIn degrees:0];
            
        }
        else if ([sender tag] == 3){
        
            self.serviceIcon.tintColor = [UIColor whiteColor];
            
            [self rotateImage:self.serviceIcon duration:0.2
                        curve:UIViewAnimationCurveEaseIn degrees:0];
            
            self.startAutocompleteTableView.hidden = YES;
            self.scroll.scrollEnabled = YES;
            
            
            UINavigationBar *navBar = self.navigationController.navigationBar;
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            float animationDuration;
            if(statusBarFrame.size.height > 20) { // in-call
                animationDuration = 0.2;
            } else { // normal status bar
                animationDuration = 0.2;
            
            
            navBar.frame = CGRectMake(navBar.frame.origin.x,
                                      -200,
                                      navBar.frame.size.width,
                                      navBar.frame.size.height);
            

            }
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                    withAnimation:UIStatusBarAnimationSlide];
            [UIView animateWithDuration:animationDuration animations:^{
                
                navBar.frame = CGRectMake(navBar.frame.origin.x,
                                          20,
                                          navBar.frame.size.width,
                                          navBar.frame.size.height);
                
            } completion:nil];


            
            [self dismissKeyboard];

        }
        
    } else if ([sender tag] == 2) {
        
        [self rotateImage:self.locationIcon duration:0.2
                    curve:UIViewAnimationCurveEaseIn degrees:0];

       
    }else if([sender tag] == 3){
        
        self.startAutocompleteTableView.hidden = YES;
        self.scroll.scrollEnabled = YES;

        
        [self rotateImage:self.serviceIcon duration:0.2
                    curve:UIViewAnimationCurveEaseIn degrees:0];
        
        [self.service.layer setBorderWidth:0.0f];
        
        NSArray *visibleCells = [self.collectionView visibleCells];
        for (iconCell *cell in visibleCells) {
            
            cell.tickImage.hidden = YES;
            cell.selected = NO;
            cell.alpha = 0.9f;
            
            cell.icon.image = [UIImage imageNamed:[self.verticalIcons objectAtIndex:cell.tag]];
        }
        self.service.layer.borderWidth = 1.0f;
        self.service.layer.borderColor =[[UIColor whiteColor]CGColor];
        
        _serviceIcon.tintColor = [UIColor whiteColor];
       
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard];
    
    [self keyboardWillHide];
    
                if (textField.tag == 3) {
                
                
                
                UINavigationBar *navBar = self.navigationController.navigationBar;
                CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                float animationDuration;
                if(statusBarFrame.size.height > 20) { // in-call
                    animationDuration = 0.2;
                } else { // normal status bar
                    animationDuration = 0.2;
                    
                    
                    navBar.frame = CGRectMake(navBar.frame.origin.x,
                                              -200,
                                              navBar.frame.size.width,
                                              navBar.frame.size.height);
                    
                    
                }
                
                [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                        withAnimation:UIStatusBarAnimationSlide];
                [UIView animateWithDuration:animationDuration animations:^{
                    
                    navBar.frame = CGRectMake(navBar.frame.origin.x,
                                              20,
                                              navBar.frame.size.width,
                                              navBar.frame.size.height);
                    
                } completion:nil];
    }
    
    NSLog(@"Delegate method being sent");
    
    return YES;
}

//auto-complete methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 3) {
        self.autocompleteTableView.hidden = NO;
        [self.view bringSubviewToFront:self.autocompleteTableView];
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring
                     stringByReplacingCharactersInRange:range withString:string];
        [self searchAutocompleteEntriesWithSubstring:substring];
        
        if( IS_IPHONE_5 )
        {
            [self.autocompleteTableView setFrame:CGRectMake(20, 184, self.service.frame.size.width, autocompleteUrls.count * 35)];
            
            UINavigationBar *navBar = self.navigationController.navigationBar;
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            float animationDuration;
            if(statusBarFrame.size.height > 20) { // in-call
                animationDuration = 0.2;
            } else { // normal status bar
                animationDuration = 0.2;
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                    withAnimation:UIStatusBarAnimationSlide];
            [UIView animateWithDuration:animationDuration animations:^{
                
                navBar.frame = CGRectMake(navBar.frame.origin.x,
                                          20,
                                          navBar.frame.size.width,
                                          navBar.frame.size.height);
                
            } completion:nil];}
            
        }
        else
        {
            [self.autocompleteTableView setFrame:CGRectMake(20, 184, self.service.frame.size.width, (autocompleteUrls.count/2)* 35)];

        }

    }
      return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompleteUrls removeAllObjects];
    for(NSString *curString in pastUrls) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompleteUrls addObject:curString];
        }
    }
    [self.autocompleteTableView reloadData];
}

#pragma mark UITableViewDelegate methods
//format the cells in the drop-down table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.startAutocompleteTableView) {
        
        static NSString *startAutoCompleteRowIdentifier = @"startAutoCompleteRowIdentifier";
        
        UITableViewCell *cell = (UITableViewCell *)[self.startAutocompleteTableView dequeueReusableCellWithIdentifier:startAutoCompleteRowIdentifier];
        
        if (!cell)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:startAutoCompleteRowIdentifier];
            
            
        }
        
        //      [self.autocompleteTableView numberOfRowsInSection:autocompleteUrls.count]
        
        cell.textLabel.text = [sortedArray objectAtIndex:indexPath.row];
        [cell.textLabel setTextColor:[UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:97.0/255.0 alpha:1.0]];
        cell.textLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:16.0f];
        cell.backgroundColor = [UIColor whiteColor];
        
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(73/255.0) green:(114/255.0) blue:(171/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;

        return cell;
    }
    
    
    

    if (tableView == self.autocompleteTableView) {
    
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
        
    UITableViewCell *cell = (UITableViewCell *)[self.autocompleteTableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
        
        if (!cell)
        {
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
            
        
        }
        
//      [self.autocompleteTableView numberOfRowsInSection:autocompleteUrls.count]
            cell.textLabel.text = [autocompleteUrls objectAtIndex:indexPath.row];
        [cell.textLabel setTextColor:[UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:97.0/255.0 alpha:1.0]];
        cell.textLabel.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:18.0f];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }

    
    if (tableView == self.servicesTableView){
        
    static NSString *servicesListIdentifier = @"servicesListIdentifier";
    UITableViewCell *cell = (UITableViewCell *)[self.servicesTableView dequeueReusableCellWithIdentifier:servicesListIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:servicesListIdentifier];
            cell.backgroundColor = [UIColor redColor];

        }
        
//        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        // this is where you set your color view
        UIView *customColorView = [[UIView alloc] init];
        customColorView.backgroundColor = [UIColor colorWithRed:48/255.0
                                                          green:79/255.0
                                                           blue:116/255.0
                                                          alpha:1.0];
        cell.selectedBackgroundView =  customColorView;
        
        cell.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:60.0/255.0 blue:97.0/255.0 alpha:0.25];
        cell.textLabel.text = [sortedArray objectAtIndex:indexPath.row];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont fontWithName:@"GothamNarrow-Medium" size:16.0f]];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        return cell;

    }
    
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
    if (tableView == self.autocompleteTableView) {
        return autocompleteUrls.count;
    }
    
    if (tableView == self.startAutocompleteTableView) {
        return pastUrls.count;
    }
    
    if (tableView == self.servicesTableView){
        return pastUrls.count;
    }
    
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.servicesTableView){
        
        return 44;
    }
    
    if (tableView == self.startAutocompleteTableView) {
        
        return 35;
    }
    
    return 35;
}


//set the uitextfield text as the selected cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.startAutocompleteTableView) {
        
                NSLog(@"LIST CELL SELECTED");
                
                UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
                self.service.text = selectedCell.textLabel.text;
                
                NSArray *visibleCells = [self.collectionView visibleCells];
                for (iconCell *cell in visibleCells) {
                    
                    cell.tickImage.hidden = YES;
                    cell.selected = NO;
                    cell.alpha = 0.9f;
                    
                    cell.icon.image = [UIImage imageNamed:[self.verticalIcons objectAtIndex:cell.tag]];
                    
                }
                
                self.service.layer.borderColor = [[UIColor whiteColor] CGColor];
                self.service.layer.borderWidth = 1.0f;
        
                
                self.startAutocompleteTableView.hidden = YES;
                
                self.screenTap.enabled = YES;
        
        UINavigationBar *navBar = self.navigationController.navigationBar;
        CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
        float animationDuration;
        if(statusBarFrame.size.height > 20) { // in-call
            animationDuration = 0.2;
        } else { // normal status bar
            animationDuration = 0.2;
        }
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO
                                                withAnimation:UIStatusBarAnimationSlide];
        [UIView animateWithDuration:animationDuration animations:^{
            
            navBar.frame = CGRectMake(navBar.frame.origin.x,
                                      20,
                                      navBar.frame.size.width,
                                      navBar.frame.size.height);
            
        } completion:nil];
        
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(0, 0, 320, 568);
        }];
        
        [self dismissKeyboard];

        
    }
    
    if (tableView == self.autocompleteTableView) {
        
        NSLog(@"Predictive cell selected");
    
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        self.service.text = selectedCell.textLabel.text;
        
        self.service.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.service.layer.borderWidth = 1.0f;

        self.autocompleteTableView.hidden = YES;
        
        
    }
    
    if (tableView == self.servicesTableView) {
        
        NSLog(@"Service cell selected");
        

    
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        NSArray *visibleCells = [self.collectionView visibleCells];
        for (iconCell *cell in visibleCells) {
            
            cell.tickImage.hidden = YES;
            cell.selected = NO;
            cell.alpha = 0.9f;
        
            cell.icon.image = [UIImage imageNamed:[self.verticalIcons objectAtIndex:cell.tag]];
        }
        
//        iconCell *selectedCell = [self.collectionView cellForItemAtIndexPath:visibleCells];
//        selectedCell.tickImage.hidden = YES;
        
//
        [self showServices:self];
        
        self.service.text = cell.textLabel.text;
        self.service.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.service.layer.borderWidth = 1.0f;
      
    }
}

#pragma mark UIGestureRecognizerDelegate methods

//make sure that the uitableview is still tappable
- (BOOL)gestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.autocompleteTableView] || (![self.location isFirstResponder] && ![self.service isFirstResponder])){
        // Don't let selections of auto-complete entries fire the gesture recognizer
        return NO;
    }
    return YES;
}


#pragma mark UICollectionViewDelegate methods

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    iconCell *cell = (iconCell *)[cv dequeueReusableCellWithReuseIdentifier:@"newCell"
                                                                           forIndexPath:indexPath];
    
    cell.selected = YES;
    cell.tag = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    cell.alpha = 1.0f;
    [cv selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    cell.label.text = [iconLabel objectAtIndex:indexPath.row];
    
//    [cell.label setFont:[UIFont fontWithName:@"GothamNarrow" size:50.0f]];
    
    
    if (self.selectedItemIndexPath != nil && [indexPath compare:self.selectedItemIndexPath] == NSOrderedSame) {
//        cell.layer.borderColor = [[UIColor whiteColor] CGColor];
//        cell.layer.borderWidth = 2.0;
//        cell.icon.alpha = 1.0f;
        cell.tickImage.hidden = NO;
        [cell bringSubviewToFront:cell.tickImage];
        cell.icon.image = [UIImage imageNamed:[self.verticalIconsSelected objectAtIndex:indexPath.row]];

    } else {
        cell.layer.borderColor = nil;
        cell.layer.borderWidth = 0.0;
//        cell.icon.alpha = 0.5f;
        cell.label.textColor = [UIColor whiteColor];
        cell.tickImage.hidden = YES;
        cell.icon.image = [UIImage imageNamed:[self.verticalIcons objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // always reload the selected cell, so we wi§ll add the border to that cell
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath)
    {
        // if we had a previously selected cell
        self.service.text = @"";
        self.service.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.service.layer.borderWidth = 0.0f;
        _serviceIcon.tintColor = [UIColor whiteColor];
        

        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame)
        {
            // if it's the same as the one we just tapped on, then we're unselecting it
            self.selectedItemIndexPath = nil;
//            self.service.text = @"";
//            self.serviceString = @"";
        }
        else
        {
            // if it's different, then add that old one to our list of cells to reload, and
            // save the currently selected indexPath
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
            self.service.text = [iconLabel objectAtIndex:indexPath.row];
            self.service.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.service.layer.borderWidth = 1.0f;
//            self.serviceString = [iconLabel objectAtIndex:indexPath.row];
//            _serviceIcon.tintColor = [UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0  alpha:1.0];
        }
    }
    else
    {
        // else, we didn't have previously selected cell, so we only need to save this indexPath for future reference
        self.service.text = [iconLabel objectAtIndex:indexPath.row];
        self.selectedItemIndexPath = indexPath;
        self.service.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.service.layer.borderWidth = 1.0f;
//        _serviceIcon.tintColor = [UIColor colorWithRed:69.0/255.0 green:208.0/255.0 blue:249.0/255.0  alpha:1.0];

    }
    
    // and now only reload only the cells that need updating
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
    
    
    NSLog(@"didselect");
    NSLog(@"%@", self.service.text);
    
    self.serviceString = self.service.text;

}

-(void)setState:(id)sender
{
    UICollectionViewCell *cell = (UICollectionViewCell *)sender;
    cell.selected = !cell.selected;
}
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SETTING SIZE FOR ITEM AT INDEX %ld", (long)indexPath.row);
    CGSize mElementSize = CGSizeMake(98.5, 92);
    return mElementSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"bookAppointments"]){
        bookingViewController *controller = (bookingViewController *)segue.destinationViewController;
        
        //set the web-address service string
        if ([self.service.text isEqualToString:@"Dentist"]) {
            controller.searchService = @"dentist";
        } else if ([self.service.text isEqualToString:@"Podiatry"]) {
            controller.searchService = @"podiatry-consultation";
        } else if ([self.service.text isEqualToString:@"Physiotherapy"]){
            controller.searchService = @"physiotherapy-consultation";
        } else if ([self.service.text isEqualToString:@"Chiropractor"]){
            controller.searchService = @"chiropractic-consultation";
        } else if ([self.service.text isEqualToString:@"Osteopathy"]){
            controller.searchService = @"osteopathic-consultation";
        } else if ([self.service.text isEqualToString:@"Private GP"]){
            controller.searchService = @"general-consultation";
        } else if ([self.service.text isEqualToString:@"Health Screening"]){
            controller.searchService = @"health-screen";
        } else if ([self.service.text isEqualToString:@"Dental Hygienist"]){
            controller.searchService = @"dental-hygienist";
        }else if ([self.service.text isEqualToString:@"Travel Health"]){
            controller.searchService = @"travel-health";
        }else if ([self.service.text isEqualToString:@"Private Sexual Health Services"]){
            controller.searchService = @"private-sexual-health-services";
        }else if ([self.service.text isEqualToString:@"NHS Sexual Health Services"]){
                controller.searchService = @"nhs-sexual-health-services";
        }else if ([self.service.text isEqualToString:@"Sports Massage"]){
            controller.searchService = @"sports-massage";
        }else if ([self.service.text isEqualToString:@"Cosmetic Practitioner"]){
            controller.searchService = @"cosmetic-practitioner";
        }else if ([self.service.text isEqualToString:@"Dermal Fillers"]){
            controller.searchService = @"dermal-fillers";
        }else if ([self.service.text isEqualToString:@"Laser Treatments"]){
            controller.searchService = @"laser-treatments";
        }else if ([self.service.text isEqualToString:@"Facial Fillers"]){
            controller.searchService = @"facial-fillers";
        } else if ([self.service.text isEqualToString:@"General Consultation"]){
            controller.searchService = @"general-consultation";
        } else if ([self.service.text isEqualToString:@"Podiatrist"]){
            controller.searchService = @"podiatry-consultation";
        };


        //set the web -address location
        self.locationString = self.location.text.lowercaseString;
        while ([self.locationString rangeOfString:@" "].location != NSNotFound) {
            self.locationString = [self.locationString stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        controller.searchLocation = self.locationString;
    
        controller.navigationController.navigationBar.translucent = NO;
        controller.navigationController.navigationBar.barTintColor = [UIColor blueColor];
        UIImageView *title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 93, 20)];
        [title setContentMode:UIViewContentModeScaleAspectFit];
        title.image = [UIImage imageNamed:@"zestyLogo"];
        controller.navigationItem.titleView = title;

        NSLog(@"%@", self.locationString);
        NSLog(@"%@", self.service.text);
        
    }
    
}

-(void)keyboardWillShow {
    // Animate the current view out of the way if the textField is too low down the screen
    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//    float animationDuration;
////
////    if(statusBarFrame.size.height > 20) { // in-call
////        animationDuration = 0.2;
////    } else { // normal status bar
////        animationDuration = 0.2;
////    }
//
////    if ([self.service isFirstResponder]) {
//        [UIView animateWithDuration:0.3f animations:^ {
//            self.view.frame = CGRectMake(0, -120, 320, 768);}];
    
//        [[UIApplication sharedApplication] setStatusBarHidden:YES
//                                                withAnimation:UIStatusBarAnimationSlide];
//        [UIView animateWithDuration:animationDuration animations:^{
//            navBar.frame = CGRectMake(navBar.frame.origin.x,
//                                      -navBar.frame.size.height,
//                                      navBar.frame.size.width,
//                                      navBar.frame.size.height);
//                                } completion:nil];
//    }
}

-(void)keyboardWillHide {
    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
//    float animationDuration;
//    if(statusBarFrame.size.height > 20) { // in-call
//        animationDuration = 0.2;
//    } else { // normal status bar
//        animationDuration = 0.2;
//    }
//    
//    [[UIApplication sharedApplication] setStatusBarHidden:NO
//                                            withAnimation:UIStatusBarAnimationSlide];
//    [UIView animateWithDuration:animationDuration animations:^{
//        
//        navBar.frame = CGRectMake(navBar.frame.origin.x,
//                                  statusBarFrame.size.height,
//                                  navBar.frame.size.width,
//                                  navBar.frame.size.height);
//        
//    } completion:nil];
    
    // Animate the current view back to its original position
    [UIView animateWithDuration:0.3f animations:^ {
        self.view.frame = CGRectMake(0, 0, 320, 568);
    }];
}

@end
