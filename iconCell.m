//
//  iconCell.m
//  ZestyApp
//
//  Created by George Goldhagen on 24/07/2014.
//  Copyright (c) 2014 ZestyLtd. All rights reserved.
//

#import "iconCell.h"
#import "viewController.h"

@implementation iconCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        [self.layer setCornerRadius:4.0f];
        
            self.label = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
            self.label.center = CGPointMake(self.frame.size.width/2, 85);
            self.label.backgroundColor = [UIColor clearColor];
            self.label.userInteractionEnabled = NO;
            self.autoresizesSubviews = YES;
            self.label.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                           UIViewAutoresizingFlexibleHeight);
            self.label.font = [UIFont fontWithName:@"GothamNarrow-Medium" size:20.0f];
            self.label.textColor = [UIColor whiteColor];
            self.label.textAlignment = NSTextAlignmentCenter;
        
//            self.label.textlabel.adjustsFontSizeToFitWidth = YES;
        
        self.tickImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        self.tickImage.image = [UIImage imageNamed:@"tickImage"];
        self.tickImage.center = CGPointMake(self.frame.size.width/2+20, 50);

    
        self.icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.icon.center = CGPointMake(self.frame.size.width/2, 35);
        
        [self addSubview:self.tickImage];
        [self bringSubviewToFront:self.tickImage];
        [self addSubview:self.label];
        [self addSubview:self.icon];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
