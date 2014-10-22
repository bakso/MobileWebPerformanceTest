//
//  exRunnerViewController.h
//  test2
//
//  Created by fanyu on 14-8-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "exMainTabViewController.h"
#import <WebKit/WebKit.h>

@interface exRunnerViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate, WKScriptMessageHandler>
@property (strong, nonatomic) IBOutlet UIWebView *webview;
@property(nonatomic, readonly) WKWebView *wkwebView;

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *onloadTime;
@property (strong, nonatomic) NSString *domreadyTime;
@property (nonatomic) int duration;
@property (nonatomic) float space;
@property (nonatomic, strong) NSMutableArray* captureImages;

@property (weak, nonatomic) exMainTabViewController* parentViewCtrl;
@end