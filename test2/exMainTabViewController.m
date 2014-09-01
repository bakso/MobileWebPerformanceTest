//
//  exMainTabViewController.m
//  test2
//
//  Created by fanyu on 14-8-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "exMainTabViewController.h"
#import "exRunnerViewController.h"


@implementation exMainTabViewController

@synthesize startButton = _startButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.urlTextField.delegate = self;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"xxx");
    
    _startButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _startButton.layer.borderWidth = 1;
    _startButton.layer.cornerRadius = 5.0;
    
    UITabBar *tabbar = self.tabBarController.tabBar;
    UITabBarItem *tabBarItem0 = [tabbar.items objectAtIndex:0];
    UIImage *image0 = [UIImage imageNamed:@"stopwatch.png"];
    tabBarItem0.image = image0;
    tabBarItem0.title = @"Run Task";
    
    UITabBarItem *tabBarItem1 = [tabbar.items objectAtIndex:1];
    UIImage *image2 = [UIImage imageNamed:@"servermode.png"];
    tabBarItem1.image = image2;
    tabBarItem1.title = @"Sever Mode";
    
    [self.duration addTarget:self action:@selector(durationSliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.durationLabel setTextAlignment:NSTextAlignmentRight];
    
    [self.space addTarget:self action:@selector(spaceSliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.spaceLabel setTextAlignment:NSTextAlignmentRight];
    
    [self syncDurationLabel];
    [self syncSpaceLabel];
}

-(void) syncDurationLabel{
    NSString* text = [NSString stringWithFormat:@"%d", (int)self.duration.value];
    self.durationLabel.text = [text stringByAppendingString: @"s"];
}

-(void) syncSpaceLabel{
    NSString* text = [NSString stringWithFormat:@"%.1f", self.space.value];
    self.spaceLabel.text = [text stringByAppendingString: @"s"];
}

-(void) durationSliderChange:(id)sender{
    [self syncDurationLabel];
}

-(void) spaceSliderChange:(id)sender{
   [self syncSpaceLabel];
}

- (void) runTest{
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
    exRunnerViewController *runnerView =[board instantiateViewControllerWithIdentifier:@"runner"];
    runnerView.url = _urlTextField.text;
    runnerView.duration = (int)self.duration.value;
    NSString* formatSpace = [NSString stringWithFormat:@"%.1f", self.space.value];
    runnerView.space = [formatSpace floatValue];
    [self presentViewController:runnerView animated:YES completion:nil];
}

- (IBAction)onClick:(id)sender {
    [self runTest];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self runTest];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
