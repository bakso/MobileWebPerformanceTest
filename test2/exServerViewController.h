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

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (strong, nonatomic) GCDWebServer* webServer;
@property (weak, nonatomic) IBOutlet UILabel *serverStartAt;
@property (weak, nonatomic) IBOutlet UILabel *address;
@end
