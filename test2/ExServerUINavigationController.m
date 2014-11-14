//
//  ExServerUINavigationController.m
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14/10/30.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "ExServerUINavigationController.h"

@implementation ExServerUINavigationController

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

//-(BOOL)shouldAutorotate{
//    return NO;
//}
//
//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}

@end
