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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	// Do any additional setup after loading the view, typically from a nib.
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
