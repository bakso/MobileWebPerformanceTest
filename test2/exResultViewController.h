//
//  exResultViewController.h
//  test2
//
//  Created by fanyu on 14-8-31.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exResultViewController : UIViewController

@property(nonatomic, strong) NSMutableArray* resultImages;
@property(nonatomic, strong) NSString* onloadTime;
@property (nonatomic, strong) IBOutlet UILabel *onloadTimeLabel;

@end
