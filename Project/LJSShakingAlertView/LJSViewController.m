//
//  LJSViewController.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import "LJSViewController.h"
#import <LJSShakingAlertView/LJSShakingAlertView.h>

typedef NS_ENUM(NSInteger, TableViewRow) {
    TableViewRowShowAlertView,
    TableViewRowTextEntryStatus,
    TableViewRowCount
    
};

@interface LJSViewController ()
@property (nonatomic, strong) NSString *entryStatusText;
@end

@implementation LJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.entryStatusText = @"n/a (show alert first)";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == TableViewRowShowAlertView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self showShakingAlertView];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return TableViewRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    switch (indexPath.row) {
        case TableViewRowShowAlertView:
            cell.textLabel.text = @"Show LJSShakingAlertView";
            break;
        case TableViewRowTextEntryStatus:
            cell.textLabel.text = [NSString stringWithFormat:@"Status: %@", self.entryStatusText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
            
        default:
            break;
    }
    
    
    return cell;
}

#pragma mark - Pirvate
- (void)showShakingAlertView {
    LJSShakingAlertView *alertView;
    alertView = [[LJSShakingAlertView alloc] initWithTitle:@"Enter Password"
                                                   message:@"To continue enter a valid password"
                                                secretText:@"password"
                                                completion:^(BOOL enteredCorrectText) {
                                                    self.entryStatusText = enteredCorrectText ? @"Entered correct text!": @"Cancelled.";
                                                    [self.tableView reloadData];
                                                } cancelButtonTitle:@"Cancel"
                                          otherButtonTitle:@"OK"];
    [alertView show];

}



@end
