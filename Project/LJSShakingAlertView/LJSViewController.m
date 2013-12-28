//
//  LJSViewController.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import "LJSViewController.h"
#import <LJSShakingAlertView/LJSShakingAlertView.h>

@interface LJSViewController ()

@end

@implementation LJSViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showShakingAlertView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Need this so that Obj-C doesn't complain that method does not return from non void function
    static NSString *CellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
    }
    
    cell.textLabel.text = @"Show LJSShakingAlertView";
    
    return cell;
}

#pragma mark - Pirvate
- (void)showShakingAlertView {
    LJSShakingAlertView *alertView;
    alertView = [[LJSShakingAlertView alloc] initWithTitle:@"Enter Password"
                                                   message:@"To continue enter a valid password"
                                                secretText:@"password"
                                                completion:^(BOOL enteredCorrectText) {
                                                    if (enteredCorrectText) {
                                                        NSLog(@"Correct!");
                                                    }
                                                    else {
                                                        NSLog(@"Incorrect");
                                                    }
                                                } cancelButtonTitle:@"Cancel"
                                          otherButtonTitle:@"OK"];
    [alertView show];

}



@end
