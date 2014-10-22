


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


@end


//@implementation NSString
//- (NSString *)stringByDecodingURLFormat
//{
//    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
//    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    return result;
//}
//@end


@implementation exRunnerViewController

@synthesize webview = _webview;
@synthesize windowSize = _windowSize;
@synthesize label;
@synthesize btn;
@synthesize captureImages;
@synthesize parentViewCtrl;

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
    
    WKWebViewConfiguration *theConfiguration =
    [[WKWebViewConfiguration alloc] init];
    [theConfiguration.userContentController
     addScriptMessageHandler:self name:@"MWPT"];
    
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, _windowSize.width, _windowSize.height-STATUSBAR_HEIGHT) configuration:theConfiguration];
    _wkwebView.navigationDelegate = self;
    
    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, STATUSBAR_HEIGHT, _windowSize.width, _windowSize.height-STATUSBAR_HEIGHT)];
    _webview.delegate = self;
    
    //[self.view addSubview:_webview];
    [self.view addSubview:_wkwebView];
    
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

- (void)webView:(WKWebView *)wkwebview didCommitNavigation:(WKNavigation *)navigation{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"script"
                                                     ofType:@"js"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    [wkwebview evaluateJavaScript:content completionHandler:nil];
}

- (void) webViewDidStartLoad:(UIWebView *)webView{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"script"
                                                     ofType:@"js"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];    
    [_webview stringByEvaluatingJavaScriptFromString:content];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* rurl=[[request URL] absoluteString];
    if ([rurl hasPrefix:@"mwpt://"]) {
        NSLog(@"ssss%@",rurl);
        NSURL *url = [NSURL URLWithString:rurl];
        NSString *query = [url query];
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *urlComponents = [query componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [pairComponents objectAtIndex:1];
            
            [queryStringDictionary setObject:value forKey:key];
        }

        NSString *rawResult = [queryStringDictionary objectForKey:@"result"];
        NSString *decodedString = [rawResult stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
        
        NSData* jsonData = [decodedString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *perfResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSString *onloadTime = [perfResult objectForKey:@"onloadTime"];
        NSString *domreadyTime = [perfResult objectForKey:@"domreadyTime"];
        
        _onloadTime = onloadTime;
        _domreadyTime = domreadyTime;
    }
    
    return true;
}


- (void) onAbortClick:(id)sender{
    //[self dismissViewControllerAnimated:true completion:nil];
    [self endTask];
}

- (void) startTask
{
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NSURLCache sharedURLCache] setDiskCapacity:0];
    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    
    //[_webview loadRequest:request];
    [_wkwebView loadRequest:request];
    
    int seconds = self.duration;
    int _seconds = self.duration;
    float perSecond = self.space;
    __block int timeout = seconds*100; //倒计时时间
    __block int capturePerSecond = perSecond*100;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 0.01*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            //最后一张图
            int pass = _seconds*100-timeout;
            int passSeconds = pass/100;
            int passMs = pass % 100;
            UIImage* image = [self captureScreen:_wkwebView];
            NSDictionary* obj = @{@"image": image, @"label": [NSString stringWithFormat:@"%.2d''%.2d",passSeconds, passMs]};
            [captureImages addObject:obj];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"capture image number:%d", captureImages.count);
                [self endTask];
                
            });
        }else{
            int seconds = timeout / 100;
            int ms = timeout % 100;
            Boolean needCapture = (timeout % capturePerSecond)==0;
            NSString *strTime = [NSString stringWithFormat:@"%.2d:%.2d",seconds, ms];
            
            int pass,passSeconds,passMs;
            if(needCapture){
                pass = _seconds*100-timeout;
                passSeconds = pass/100;
                passMs = pass % 100;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if(needCapture){
                    UIImage* image = [self captureScreen:_wkwebView];
                    NSDictionary* obj = @{@"image": image, @"label": [NSString stringWithFormat:@"%.2d''%.2d",passSeconds, passMs]};
                    [captureImages addObject:obj];
                }
                //设置界面的按钮显示 根据自己需求设置
                label.text = strTime;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

-(void) endTask{
    
    
//    
//    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
//    exResultViewController *resultViewController =[board instantiateViewControllerWithIdentifier:@"result"];
//    resultViewController.resultImages = captureImages;

    
    //[self presentViewController:resultViewController animated:YES completion:nil];
    [self dismissViewControllerAnimated: YES completion:^{
        NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:
                                captureImages, @"captureImages",
                                _onloadTime, @"onloadTime",
                                _domreadyTime, @"domreadyTime",
                                nil];
        
        
        if(parentViewCtrl != nil){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"taskRunEnd" object:result];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"webTaskRunEnd" object:result];
        }
       
    }];
}


-(UIImage*)captureScreen:(UIView*) viewToCapture{
    UIGraphicsBeginImageContext(viewToCapture.frame.size);
    
    [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenshot;
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

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    NSDictionary *sentData = (NSDictionary *)message.body;
    NSString *messageString = sentData[@"result"];
    NSLog(@"Message received: %@", messageString);
    
    
    NSData* jsonData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *perfResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSString *onloadTime = [perfResult objectForKey:@"onloadTime"];
    NSString *domreadyTime = [perfResult objectForKey:@"domreadyTime"];
    _onloadTime = onloadTime;
    _domreadyTime = domreadyTime;
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
