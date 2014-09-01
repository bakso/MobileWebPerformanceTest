//
//  exRunnerViewController.m
//  test2
//
//  Created by fanyu on 14-8-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//
#define STATUSBAR_HEIGHT 20

#import "exRunnerViewController.h"
#import "exResultViewController.h"

@interface exRunnerViewController ()
@property CGSize windowSize;
@property UILabel* label;
@property UIButton* btn;
@property NSMutableArray* captureImages;
@end

@implementation exRunnerViewController

@synthesize webview = _webview;
@synthesize windowSize = _windowSize;
@synthesize label;
@synthesize btn;
@synthesize captureImages;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
//    self.navigationController.navigationBar.translucent = NO;
    
    
    //UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style: UIBarButtonItemStyleBordered target:self action:@selector(Back)];
//    
//    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(Back)];
//    backButton.tintColor = [UIColor whiteColor];
//    
//    UIBarButtonItem *abortButton = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style: UIBarButtonItemStyleDone target:self action:@selector(Abort)];
//    UIBarButtonItem *abortButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(Back)];
//    abortButton.tintColor = [UIColor whiteColor];
//    
//    self.navigationItem.leftBarButtonItem = backButton;
//    self.navigationItem.rightBarButtonItem = abortButton;
    
//    NSTimer *timer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
    
    
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated{
    captureImages = [[NSMutableArray alloc] initWithObjects:nil];
    
    _windowSize = self.view.window.bounds.size;
            
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.automaticallyAdjustsScrollViewInsets = false; //否则webview会自动留白边
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, _windowSize.width, _windowSize.height-STATUSBAR_HEIGHT)];
    [self.view addSubview:_webview];
    
    UIView* actionBar = [[UIView alloc]initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, _windowSize.width, 30)];
    actionBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];    
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    label.text = @"10:00";
    label.textColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:1];
    [actionBar addSubview:label];
    
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGFloat btnWidth = 55;
    btn.frame = CGRectMake(_windowSize.width-btnWidth, 0, btnWidth, 30);
    [btn setTitle:@"Abort" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onAbortClick:) forControlEvents:UIControlEventTouchUpInside];
    [actionBar addSubview:btn];
    
    [self.view addSubview:actionBar];
    [self startTask];
}


- (void) onAbortClick:(id)sender{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void) startTask
{
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webview loadRequest:request];
    
    int seconds = self.duration;
    float perSecond = self.space;
    __block int timeout = seconds*100; //倒计时时间
    __block int capturePerSecond = perSecond*100;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 0.01*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endTaskWithImages:captureImages];
                NSLog(@"capture image number:%d", captureImages.count);
            });
        }else{
            int seconds = timeout / 100;
            int ms = timeout % 100;
            Boolean needCapture = (timeout % capturePerSecond)==0;
            NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d",seconds, ms];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                label.text = strTime;
                if(needCapture){
                    UIImage* image = [self captureScreen:_webview];
                    
                    [captureImages addObject:image];
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void) endTaskWithImages:(NSMutableArray*)images{
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
    exResultViewController *resultViewController =[board instantiateViewControllerWithIdentifier:@"result"];
    resultViewController.resultImages = captureImages;
    
    [self presentViewController:resultViewController animated:YES completion:nil];
    [self dismissViewControllerAnimated: NO completion:nil];
}

- (void) tick{
    NSDate *date = [NSDate date];
    NSLog(@"%f", date.timeIntervalSince1970);
    
}

-(UIImage*)captureScreen:(UIView*) viewToCapture{
    UIGraphicsBeginImageContext(viewToCapture.bounds.size);
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*viewImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

- (IBAction)Back
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
}

- (IBAction)Abort
{
    [self dismissViewControllerAnimated:YES completion:nil]; // ios 6
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
