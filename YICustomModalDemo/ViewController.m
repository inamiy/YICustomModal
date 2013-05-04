//
//  ViewController.m
//  YICustomModalDemo
//
//  Created by Inami Yasuhiro on 13/01/17.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+YICustomModal.h"

#define TEST_FULL_SCREEN    1

static NSUInteger __counter = 0;


@interface ViewController ()

@end


@implementation ViewController

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.counterLabel.text = self.title;
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
    
    [self presentViewController:vc animated:YES completion:NULL];
}

- (IBAction)handleCustomModalButton:(id)sender
{
    ViewController* vc = [self.storyboard instantiateInitialViewController];
    vc.title = [NSString stringWithFormat:@"%d",++__counter];
    vc.customModalTransitionStyle = YICustomModalTransitionStyleZoomOut;

#if TEST_FULL_SCREEN
    vc.wantsFullScreenLayout = YES;
#endif
    
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
}

- (IBAction)handleStatusBarButton:(id)sender
{
    [[UIApplication sharedApplication] setStatusBarHidden:![UIApplication sharedApplication].statusBarHidden
                                            withAnimation:UIStatusBarAnimationSlide];
}

@end
