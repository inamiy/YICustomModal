//
//  ViewController.h
//  YICustomModalDemo
//
//  Created by Inami Yasuhiro on 13/01/17.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *counterLabel;

- (IBAction)handleNormalModalButton:(id)sender;
- (IBAction)handleCustomModalButton:(id)sender;
- (IBAction)handleCloseButton:(id)sender;
- (IBAction)handleStatusBarButton:(id)sender;

@end
