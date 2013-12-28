//
//  LJSAlertViewShaker.m
//  LJSShakingAlertView
//
//  Created by Luke Stringer on 28/12/2013.
//  Copyright (c) 2013 Luke James Stringer. All rights reserved.
//

#import "LJSAlertViewShaker.h"
#import "LJSShakingAlertView.h"

@implementation LJSAlertViewShaker

- (void)shakeAlertView:(LJSShakingAlertView *)alertView {
    
    CGAffineTransform moveRight = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
    CGAffineTransform moveLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -20, 0);
    CGAffineTransform resetTransform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    
    [UIView animateWithDuration:0.1 animations:^{
        alertView.transform = moveLeft;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            alertView.transform = moveRight;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                alertView.transform = moveLeft;
                
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    alertView.transform = resetTransform;
                }];
            }];
            
        }];
    }];
    
}

@end
