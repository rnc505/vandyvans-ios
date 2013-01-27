//
//  VVBugReportTableViewController.m
//  Vandy Vans
//
//  Created by Seth Friedman on 1/19/13.
//  Copyright (c) 2013 VandyMobile. All rights reserved.
//

#import "VVReportTableViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "VVVandyMobileAPIClient.h"

@interface VVReportTableViewController ()

@property (weak, nonatomic) IBOutlet UITableViewCell *emailTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *notifyWhenResolvedTableViewCell;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation VVReportTableViewController

@synthesize userIsSendingFeedback = _userIsSendingFeedback;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.userIsSendingFeedback) {
        self.title = @"Send Feedback";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPressed:(UIBarButtonItem *)sender {
    if ([self.emailTextField.text isEqualToString:@""] || [self.descriptionTextView.text isEqualToString:@"Description"]) {
        [SVProgressHUD showErrorWithStatus:@"Please fill in the email and description fields."];
    }
    
    NSDictionary *params = @{
        @"isBugReport" : self.userIsSendingFeedback ? @"FALSE" : @"TRUE",
        @"senderAddress" : self.emailTextField.text,
        @"body" : self.descriptionTextView.text,
        @"notifyWhenResolved" : (self.notifyWhenResolvedTableViewCell.accessoryType == UITableViewCellAccessoryCheckmark) ? @"TRUE" : @"FALSE"
    };
    
    [[VVVandyMobileAPIClient sharedClient] postPath:@"bugReport.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"status"] isEqualToString:@"success"]) {
            [SVProgressHUD showSuccessWithStatus:@"Report submitted!"];
            [self.navigationController popViewControllerAnimated:YES];
            [self.delegate reportTableViewControllerDidSendReport:self];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Report failed. Please try again later."];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = 3;
    
    if (self.userIsSendingFeedback) {
        numberOfSections = 2;
    }
    
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section == 0) {
        cell = self.emailTableViewCell;
    } else if (indexPath.section == 1) {
        cell = self.descriptionTableViewCell;
    } else if (!self.userIsSendingFeedback) {
        cell = self.notifyWhenResolvedTableViewCell;
    }
    
    return cell;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (self.notifyWhenResolvedTableViewCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            self.notifyWhenResolvedTableViewCell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            self.notifyWhenResolvedTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
}

#pragma mark - Text View Delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"Description"]) {
        textView.textColor = [UIColor blackColor];
        textView.text = @"";
    }
    
    return YES;
}

@end
