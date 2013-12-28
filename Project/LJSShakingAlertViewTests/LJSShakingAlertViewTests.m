//
//  LJSShakingAlertViewTests.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 23/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LJSShakingAlertView/LJSShakingAlertView.h>
#import <OCMock/OCMock.h>

@interface LJSShakingAlertView (TestVisibility) <UIAlertViewDelegate>
- (void)tappedButtonAtIndex:(NSInteger)index;
@end

@interface LJSShakingAlertViewTests : XCTestCase
// sut is the "Subject Under Test"
@property (nonatomic, strong) LJSShakingAlertView *sut;
@end

@implementation LJSShakingAlertViewTests

#pragma mark - Helpers

- (id)partialMockShakingAlertView:(LJSShakingAlertView *)shakingAlertView stubbedWithSecureTextFieldWithText:(NSString *)secureEntryText {
    id shakingPartialMock = [OCMockObject partialMockForObject:shakingAlertView];
    id secureTextFieldMock = [OCMockObject niceMockForClass:[UITextField class]];
    [[[secureTextFieldMock stub] andReturn:secureEntryText] text];
    [[[shakingPartialMock stub] andReturn:secureTextFieldMock] textFieldAtIndex:0];
    return shakingPartialMock;
}

#pragma mark - Initialisation tests

- (void)testInitialisesWithStoredProperties {
    void (^completion)(BOOL enteredCorrectText) = ^void(BOOL enteredCorrectText) {};
    
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:completion
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    XCTAssertNotNil(_sut, @"");
    XCTAssertEqualObjects(_sut.secretText, @"password", @"");
    XCTAssertEqualObjects(_sut.completionHandler, completion, @"");
    XCTAssertEqualObjects(_sut.cancelButtonTitle, @"Cancel", @"");
    XCTAssertEqualObjects(_sut.otherButtonTitle, @"OK", @"");
    
    //TODO:: Test title and message are set
    //    XCTAssertEqualObjects(_sut.title, @"Title", @"");
    //    XCTAssertEqualObjects(_sut.message, @"Message.", @"");
}

- (void)testInitialisesWithSecureInputeAlertViewStyle {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:^void(BOOL enteredCorrectText) {}
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    XCTAssertEqual(_sut.alertViewStyle, (NSInteger)UIAlertViewStyleSecureTextInput, @"");
}

- (void)testReturnsNilWhenInitialisedWithoutSecretText {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:nil
                                           completion:^void(BOOL enteredCorrectText) {}
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    XCTAssertNil(_sut, @"");
}

#pragma mark - Completion handler tests

- (void)testCallsCompletionHandlerForCorrectTextEntry {
    __block BOOL completionBlockWasCalled;
    __block BOOL capturedenteredCorrectTextValue;
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:^void(BOOL enteredCorrectText) {
                                               completionBlockWasCalled = YES;
                                               capturedenteredCorrectTextValue = enteredCorrectText;
                                           }
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    // Stub the secure text field with a mock text field specific text
    id sutMock = [self partialMockShakingAlertView:_sut stubbedWithSecureTextFieldWithText:@"password"];
    
    // "tap OK button"
    [[sutMock delegate] tappedButtonAtIndex:1];
    
    XCTAssertTrue(completionBlockWasCalled, @"");
    XCTAssertTrue(capturedenteredCorrectTextValue, @"");
}

- (void)testDoesNotCallsCompletionHandlerForIncorrectTextEntry {
    __block BOOL completionBlockWasCalled = NO;
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:^void(BOOL enteredCorrectText) {
                                               completionBlockWasCalled = YES;
                                           }
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    // Stub the secure text field with a mock text field specific text
    id sutMock = [self partialMockShakingAlertView:_sut stubbedWithSecureTextFieldWithText:@"incorrect-secure-text"];
    
    // "tap OK button"
    [sutMock tappedButtonAtIndex:1];
    
    XCTAssertFalse(completionBlockWasCalled, @"");
}

- (void)testCallsCompletionHandlerWhenCancelled {
    __block BOOL completionBlockWasCalled;
    __block BOOL capturedenteredCorrectTextValue;
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:^void(BOOL enteredCorrectText) {
                                               completionBlockWasCalled = YES;
                                               capturedenteredCorrectTextValue = enteredCorrectText;
                                           }
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    
    // "tap Cancel button"
    [_sut tappedButtonAtIndex:_sut.cancelButtonIndex];
    
    XCTAssertTrue(completionBlockWasCalled, @"");
    XCTAssertFalse(capturedenteredCorrectTextValue, @"");
}

#pragma mark - Dismissing alert view tests

- (void)testTappingCancelButtonDismissesAlertView {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:nil
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    id sutMock = [OCMockObject partialMockForObject:_sut];
    
    // Should be dismissed
    [[sutMock expect] dismissWithClickedButtonIndex:_sut.cancelButtonIndex animated:YES];
    
    // "tap Cancel button"
    [sutMock tappedButtonAtIndex:_sut.cancelButtonIndex];
    
    [sutMock verify];
}


- (void)testDoesNotDismissForIncorrectTextEntry {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:nil
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    // Stub the secure text field with a mock text field specific text
    id sutMock = [self partialMockShakingAlertView:_sut stubbedWithSecureTextFieldWithText:@"incorrect-secure-text"];
    
    // Should not be dismissed
    [[sutMock reject] dismissWithClickedButtonIndex:_sut.cancelButtonIndex animated:YES];
    [[sutMock reject] dismissWithClickedButtonIndex:1 animated:YES];
    
    // "tap OK button"
    [sutMock tappedButtonAtIndex:1];
    
    [sutMock verify];
}

- (void)testDismissesForCorrectTextEntry {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:nil
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    // Stub the secure text field with a mock text field specific text
    id sutMock = [self partialMockShakingAlertView:_sut stubbedWithSecureTextFieldWithText:@"password"];
    
    // Should be dismissed
    [[sutMock expect] dismissWithClickedButtonIndex:1 animated:YES];
    
    // "tap OK button"
    [sutMock tappedButtonAtIndex:1];
    
    [sutMock verify];
}

#pragma mark - Clearing text tests

- (void)testClearsSecureTextFieldForIncorrectEntry {
    _sut = [[LJSShakingAlertView alloc] initWithTitle:@"Title"
                                              message:@"Message."
                                           secretText:@"password"
                                           completion:nil
                                    cancelButtonTitle:@"Cancel"
                                     otherButtonTitle:@"OK"];
    
    id sutMock = [OCMockObject partialMockForObject:_sut];
    id secureTextFieldMock = [OCMockObject mockForClass:[UITextField class]];
    [[[secureTextFieldMock stub] andReturn:@"incorrect-secure-text"] text];
    [[[sutMock stub] andReturn:secureTextFieldMock] textFieldAtIndex:0];
    
    // Text should be cleared
    [[secureTextFieldMock expect] setText:nil];
    
    // "tap OK button"
    [sutMock tappedButtonAtIndex:1];

    [secureTextFieldMock verify];

}

@end
