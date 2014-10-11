//
//  exMainTabViewController.h
//  test2
//
//  Created by fanyu on 14-8-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface exMainTabViewController : UIViewController <UITextFieldDelegate>
@property (weak, weak) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISlider *duration;
@property (weak, nonatomic) IBOutlet UISlider *space;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *spaceLabel;
@property NSDictionary* results;

-(void) endTestWithResults: (NSMutableArray*) results;
@end

