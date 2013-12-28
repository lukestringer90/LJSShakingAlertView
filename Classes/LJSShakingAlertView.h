//
//  LJSShakingAlertView.h
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCAlertView.h"

@interface LJSShakingAlertView : SDCAlertView

@property (nonatomic, strong, readonly) NSString *secretText;
@property (nonatomic, copy, readonly) void (^completionHandler)(BOOL enteredCorrectText);
@property (nonatomic, strong, readonly) NSString *cancelButtonTitle;
@property (nonatomic, strong, readonly) NSString *otherButtonTitle;

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                   secretText:(NSString *)secretText
                   completion:(void(^)(BOOL enteredCorrectText))completion
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle;

@end
