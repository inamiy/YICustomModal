//
//  UIViewController+YICustomModal.h
//  YICustomModal
//
//  Created by Inami Yasuhiro on 13/01/17.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YICustomModalTransitionStyle) {
    YICustomModalTransitionStyleCoverVertical = 0,
    YICustomModalTransitionStyleCrossDissolve,
    YICustomModalTransitionStyleZoomOut,
    YICustomModalTransitionStyleZoomIn,
};

//
// custom modal, mainly for iOS5 youtube-fullscreen-dismiss bug
// See also: https://github.com/inamiy/ModalYoutubeIOS5Bug
//
@interface UIViewController (YICustomModal)

@property (nonatomic, readonly) UIViewController* containerViewController;

@property (nonatomic, readonly) UIViewController* customModalViewController;
@property (nonatomic, readonly) UIViewController* customParentViewController;

@property (nonatomic) YICustomModalTransitionStyle customModalTransitionStyle;

- (void)presentCustomModalViewController:(UIViewController*)customModalViewController
                                animated:(BOOL)animated
                              completion:(void (^)(void))completion;

- (void)dismissCustomModalViewControllerAnimated:(BOOL)animated
                                      completion:(void (^)(void))completion;

@end
