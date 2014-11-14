//
//  ExUINavigationController.m
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14/10/30.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "ExUINavigationController.h"

@implementation ExUINavigationController

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
