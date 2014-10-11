//
//  exRunnerViewController.h
//  test2
//
//  Created by fanyu on 14-8-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exMainTabViewController.h"

@interface exRunnerViewController : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *onloadTime;
@property (nonatomic) int duration;
@property (nonatomic) float space;
@property (nonatomic, strong) NSMutableArray* captureImages;

@property (weak, nonatomic) exMainTabViewController* parentViewCtrl;
@end