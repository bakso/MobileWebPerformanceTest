//
//  exRunnerManager.h
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14/10/23.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface exRunnerManager : NSObject
+(BOOL) getWorkingStatus;
+(void) setWorkingStatus:(BOOL)working;
@end


