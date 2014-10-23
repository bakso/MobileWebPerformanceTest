//
//  exServerViewController.h
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14-10-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"

@interface exServerViewController : UIViewController<UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) GCDWebServer* webServer;
@property (strong, nonatomic) IBOutlet UILabel *serverStartAt;
@property (strong, nonatomic) IBOutlet UILabel *address;
@end
