//
//  exRunnerViewController.h
//  test2
//
//  Created by fanyu on 14-8-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exRunnerViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIWebView *webview;
@property (nonatomic, strong) NSString *url;
@property (nonatomic) int duration;
@property (nonatomic) float space;
@end
