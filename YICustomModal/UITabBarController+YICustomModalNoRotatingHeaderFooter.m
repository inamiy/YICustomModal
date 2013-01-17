//
//  UITabBarController+YICustomModalNoRotatingHeaderFooter.m
//  YICustomModal
//
//  Created by Inami Yasuhiro on 13/01/17.
//  Copyright (c) 2013年 Yasuhiro Inami. All rights reserved.
//

#import "UITabBarController+YICustomModalNoRotatingHeaderFooter.h"
#import <objc/runtime.h>

@implementation UITabBarController (YICustomModalNoRotatingHeaderFooter)

+ (void)yi_swizzleSelector:(SEL)oldSel withSelector:(SEL)newSel
{
    Method oldMethod = class_getInstanceMethod(self, oldSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    Class c = [self class];
    
    if(class_addMethod(c, oldSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, newSel, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
    else
        method_exchangeImplementations(oldMethod, newMethod);
}

+ (void)load
{
    [UITabBarController yi_swizzleSelector:@selector(rotatingHeaderView) withSelector:@selector(yi_rotatingHeaderView)];
    [UITabBarController yi_swizzleSelector:@selector(rotatingFooterView) withSelector:@selector(yi_rotatingFooterView)];
}

- (UIView*)yi_rotatingHeaderView
{
    return nil;
}

- (UIView*)yi_rotatingFooterView
{
    return nil;
}

@end
