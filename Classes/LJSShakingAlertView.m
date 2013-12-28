//
//  LJSShakingAlertView.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import "LJSShakingAlertView.h"
#import "LJSAlertViewShaker.h"

@interface LJSShakingAlertView () <SDCAlertViewDelegate>
@property (nonatomic, strong, readwrite) NSString *secretText;
@property (nonatomic, copy, readwrite) void (^completionHandler)(BOOL enteredCorrectText);
@property (nonatomic, strong, readwrite) NSString *cancelButtonTitle;
@property (nonatomic, strong, readwrite) NSString *otherButtonTitle;
@property (nonatomic, strong) LJSAlertViewShaker *alertViewShaker;
@end

@implementation LJSShakingAlertView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                   secretText:(NSString *)secretText
                   completion:(void(^)(BOOL textEntryWasCorrect))completion
            cancelButtonTitle:(NSString *)cancelButtonTitle
             otherButtonTitle:(NSString *)otherButtonTitle {
    if (!secretText) {
        return nil;
    }
    
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitle, nil];
    
    if (self) {
        self.secretText = secretText;
        self.completionHandler = completion;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitle = otherButtonTitle;
        self.alertViewStyle = UIAlertViewStyleSecureTextInput;
        self.alertViewShaker = [[LJSAlertViewShaker alloc] init];
    }
    return self;
}

#pragma mark - SDCAlertViewDelegate

- (BOOL)alertView:(SDCAlertView *)alertView shouldDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if ([[self buttonTitleAtIndex:buttonIndex] isEqualToString:self.otherButtonTitle]) {
        
        UITextField *secureTextField = [self textFieldAtIndex:0];
        BOOL enteredCorrectText = [secureTextField.text isEqualToString:self.secretText];
        if (enteredCorrectText) {
            [self safeCallCompletionHandlerWithTextEntryWasCorrect:YES];
        }
        else {
            secureTextField.text = nil;
            [self.alertViewShaker shakeAlertView:self];
        }
        return enteredCorrectText;
        
    }
    
    [self safeCallCompletionHandlerWithTextEntryWasCorrect:NO];
    return YES;
}

#pragma mark - Private

- (void)safeCallCompletionHandlerWithTextEntryWasCorrect:(BOOL)textEntryWasCorrect {
    if (self.completionHandler) {
        self.completionHandler(textEntryWasCorrect);
    }
}

@end
