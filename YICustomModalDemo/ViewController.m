//
//  ViewController.m
//  YICustomModalDemo
//
//  Created by Inami Yasuhiro on 13/01/17.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+YICustomModal.h"

#define TEST_FULL_SCREEN    0
#define TEST_NAV_MODAL      1

static NSUInteger __counter = 0;


@interface ViewController ()

@end


@implementation ViewController

- (void)dealloc
{
    NSLog(@"%p dealloc",self);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.counterLabel.text = self.title;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"%p viewWillAppear",self);
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"%p viewDidAppear",self);
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"%p viewWillDisappear",self);
    [super viewDidDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%p viewDidDisappear",self);
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"%p viewWillLayoutSubviews",self);
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"%p viewDidLayoutSubviews",self);
    [super viewDidLayoutSubviews];
}

- (void)viewDidUnload
{
    [self setCounterLabel:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleNormalModalButton:(id)sender
{
    ViewController* vc = [self.storyboard instantiateInitialViewController];
    vc.title = [NSString stringWithFormat:@"%d",++__counter];
    
#if TEST_FULL_SCREEN
    vc.wantsFullScreenLayout = YES;
#endif
    
#if TEST_NAV_MODAL
    vc = (id)[[UINavigationController alloc] initWithRootViewController:vc];
#endif
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)handleCustomModalButton:(id)sender
{
    ViewController* vc = [self.storyboard instantiateInitialViewController];
    vc.title = [NSString stringWithFormat:@"%d",++__counter];

#if TEST_FULL_SCREEN
    vc.wantsFullScreenLayout = YES;
#endif
    
#if TEST_NAV_MODAL
    vc = (id)[[UINavigationController alloc] initWithRootViewController:vc];
#endif
    
    vc.customModalTransitionStyle = YICustomModalTransitionStyleZoomOut;
    
    [self presentCustomModalViewController:vc animated:YES completion:^{
        NSLog(@"did present");
    }];
}

- (IBAction)handleCloseButton:(id)sender
{
    // normal
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
    // custom
    else if (self.customParentViewController) {
        [self.customParentViewController dismissCustomModalViewControllerAnimated:YES completion:^{
            NSLog(@"did dismiss");
        }];
    }
    // custom + TEST_NAV_MODAL
    else if (self.navigationController.customParentViewController) {
        [self.navigationController.customParentViewController dismissCustomModalViewControllerAnimated:YES completion:^{
            NSLog(@"did dismiss");
        }];
    }
}

- (IBAction)handleStatusBarButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].statusBarHidden
                                            withAnimation:UIStatusBarAnimationSlide];
}

@end
