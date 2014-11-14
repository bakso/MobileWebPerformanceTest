//
//  ExUITabBarController.m
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14/10/30.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "ExUITabBarController.h"

@implementation ExUITabBarController

- (BOOL)shouldAutorotate
{
    return self.selectedViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
}

@end
