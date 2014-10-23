//
//  exRunnerManager.m
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14/10/23.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "exRunnerManager.h"

BOOL _isWorking = NO;

@implementation exRunnerManager

+(BOOL)getWorkingStatus{
    return _isWorking;
}

+(void)setWorkingStatus:(BOOL)working{
    _isWorking = working;
}
@end
