//
//  VVAppearanceBuilder.m
//  Vandy Vans
//
//  Created by Seth Friedman on 5/6/13.
//  Copyright (c) 2013 VandyMobile. All rights reserved.
//

#import "VVAppearanceBuilder.h"
#import "VVStopTableViewController.h"
#import "VVArrivalTimeTableViewController.h"
#import "VVAboutTableViewController.h"

@implementation VVAppearanceBuilder

+ (void)buildAppearance {
    // Set the background view in the table views to the default application background.
    [[UITableView appearance] setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VVBackground"]]];
    
    // Set the navigation bar's tint color across the application to black.
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}

@end
