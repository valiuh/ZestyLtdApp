//
//  ViewController.h
//  ZestyApp
//
//  Created by George Goldhagen on 03/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SWRevealViewController.h"


@interface ZAHomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, CLLocationManagerDelegate, UIActionSheetDelegate, SWRevealViewControllerDelegate> {
    NSMutableArray *pastUrls;
    NSMutableArray *allServices;
    NSMutableArray *iconLabel;
    NSMutableArray *autocompleteUrls;
    NSArray *sortedArray;
}

@property (nonatomic, strong) UIButton *findAppointments;
@property (nonatomic, strong) UIButton *viewServices;
@property (nonatomic, strong) UITextField *location;
@property (nonatomic, strong) UITextField *service;
@property (nonatomic, strong) UIImageView *locationIcon;
@property (nonatomic, strong) UIImageView *serviceIcon;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) UITableView *autocompleteTableView;
@property (nonatomic, strong) UITableView *startAutocompleteTableView;
@property (nonatomic, strong) UITableView *servicesTableView;
@property (nonatomic, strong) UIView *labelBackground;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UITapGestureRecognizer *screenTap;
@property (nonatomic) NSArray *verticalIcons;
@property (nonatomic) NSArray *verticalIconsSelected;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic) NSString *locationString;
@property (nonatomic) NSString *serviceString;
@property (nonatomic) UIImageView *titleImage;
@property (nonatomic) IBOutlet UIButton *menuButton;
@property (nonatomic) IBOutlet UIButton *phoneButton;




//@property (nonatomic, strong) UIScrollView *scroll;
//@property(nonatomic, assign) id<UITableViewDataSource> dataSource;

- (IBAction)editingBegun:(id)sender;
- (IBAction)editingEnded:(id)sender;
- (void)showServices:(id)sender;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
- (IBAction)viewAll:(id)sender;
- (IBAction)findAppointments:(id)sender;



@end
