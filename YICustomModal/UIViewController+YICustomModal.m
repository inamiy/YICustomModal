//
//  UIViewController+YICustomModal.m
//  YICustomModal
//
//  Created by Inami Yasuhiro on 13/01/17.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import "UIViewController+YICustomModal.h"
#import <objc/runtime.h>

#define IS_IOS_AT_LEAST(ver)    ([[[UIDevice currentDevice] systemVersion] compare:ver] != NSOrderedAscending)
#define IS_PORTRAIT             UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)
#define STATUS_BAR_HEIGHT       (IS_PORTRAIT ? [UIApplication sharedApplication].statusBarFrame.size.height : [UIApplication sharedApplication].statusBarFrame.size.width)

#define ANIMATION_DURATION  0.4

const char __customModalViewControllerKey;
const char __customParentViewControllerKey;
const char __customModalTransitionStyleKey;


@implementation UIViewController (YICustomModal)

- (void)_setCustomModalViewController:(UIViewController*)customModalViewController;
{
    objc_setAssociatedObject(self, &__customModalViewControllerKey, customModalViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController*)customModalViewController
{
    UIViewController* customModalViewController = objc_getAssociatedObject(self, &__customModalViewControllerKey);
    return customModalViewController;
}

- (void)_setCustomParentViewController:(UIViewController*)customModalViewController;
{
    objc_setAssociatedObject(self, &__customParentViewControllerKey, customModalViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController*)customParentViewController
{
    UIViewController* customParentViewController = objc_getAssociatedObject(self, &__customParentViewControllerKey);
    return customParentViewController;
}

- (void)setCustomModalTransitionStyle:(UIModalTransitionStyle)customModalTransitionStyle
{
    objc_setAssociatedObject(self, &__customModalTransitionStyleKey, [NSNumber numberWithInt:customModalTransitionStyle], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIModalTransitionStyle)customModalTransitionStyle
{
    UIModalTransitionStyle customModalTransitionStyle = [objc_getAssociatedObject(self, &__customModalTransitionStyleKey) intValue];
    return customModalTransitionStyle;
}

- (UIView*)_rootView
{
    if (!self.view.window.rootViewController.view.superview) {
        [NSException raise:NSInternalInconsistencyException format:@"window.rootViewController.view must be attached to window in order to use YICustomModal."];
    }

    return self.view.window.rootViewController.view;
}

- (void)_layoutCustomModalViewControllerVisible:(BOOL)isVisible
{
    UIView* rootView = [self _rootView];
    CGFloat statusBarHeight = STATUS_BAR_HEIGHT;
    
    CGRect visibleFrame = rootView.bounds;
    
    //
    // crop status-bar-frame if needed
    //
    // NOTE:
    // When using UITabBar/NavigationController as window.rootViewController,
    // rootView.frame is equal to [UIScreen mainScreen].bounds, not applicationFrame.
    //
    if (!self.customModalViewController.wantsFullScreenLayout && !CGRectEqualToRect(rootView.frame, [UIScreen mainScreen].applicationFrame)) {
        visibleFrame.origin.y = statusBarHeight;
        visibleFrame.size.height -= statusBarHeight;
    }
    
    self.customModalViewController.view.frame = visibleFrame;
    
    if (isVisible) {
        switch (self.customModalViewController.customModalTransitionStyle) {
            case UIModalTransitionStyleCrossDissolve:
                self.customModalViewController.view.alpha = 1;
                break;
                
            default:
                break;
        }
    }
    else {
        switch (self.customModalViewController.customModalTransitionStyle) {
            case UIModalTransitionStyleCrossDissolve:
                self.customModalViewController.view.alpha = 0;
                break;
                
            default:
            {
                CGRect hiddenFrame = visibleFrame;
                hiddenFrame.origin.y += visibleFrame.size.height;
                self.customModalViewController.view.frame = hiddenFrame;
                break;
            }
        }
    }
}

- (void)presentCustomModalViewController:(UIViewController*)customModalViewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    [self _setCustomModalViewController:customModalViewController];
    [customModalViewController _setCustomParentViewController:self];
    
    self.customModalViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [[self _rootView] addSubview:self.customModalViewController.view];
    
    [self _layoutCustomModalViewControllerVisible:NO];
    
    [self viewWillDisappear:animated];
    if (!IS_IOS_AT_LEAST(@"4.3")) {
        [self.customModalViewController viewWillAppear:animated];
    }
    
    __weak typeof(self) weakSelf = self;
    
    // block
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        
        [weakSelf viewDidDisappear:animated];
        
        if (!IS_IOS_AT_LEAST(@"4.3")) {
            [weakSelf.customModalViewController viewDidAppear:animated];
        }
        
        if (completion) {
            completion();
        }
    };
    
    // animation
    if (animated) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            
            [weakSelf _layoutCustomModalViewControllerVisible:YES];
            
        } completion:completionBlock];
    }
    else {
        [self _layoutCustomModalViewControllerVisible:YES];
        completionBlock(YES);
    }
}

- (void)dismissCustomModalViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    [self viewWillAppear:animated];
    if (!IS_IOS_AT_LEAST(@"4.3")) {
        [self.customModalViewController viewWillDisappear:animated];
    }
    
    __weak typeof(self) weakSelf = self;
    
    // block
    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        
        [weakSelf viewDidAppear:animated];
        if (!IS_IOS_AT_LEAST(@"4.3")) {
            [weakSelf.customModalViewController viewDidDisappear:animated];
        }
        
        [weakSelf.customModalViewController.view removeFromSuperview];
        [weakSelf.customModalViewController _setCustomParentViewController:nil];
        [weakSelf _setCustomModalViewController:nil];
        
        if (completion) {
            completion();
        }
    };
    
    // animation
    if (animated) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            
            [weakSelf _layoutCustomModalViewControllerVisible:NO];
            
        } completion:completionBlock];
    }
    else {
        [self _layoutCustomModalViewControllerVisible:NO];
        completionBlock(YES);
    }
}

@end
