//
//  exServerViewController.m
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14-10-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "exServerViewController.h"
#import "GCDWebServerURLEncodedFormRequest.h"
#import "exRunnerViewController.h"
#import "exRunnerManager.h"

@interface exServerViewController ()
@end

@implementation exServerViewController
@synthesize webServer;
@synthesize serverStartAt;
@synthesize address;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)onClick:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    id this = self;
    
    if([resultButton.titleLabel.text isEqualToString:@"Start"]){
        if(webServer == nil){
            webServer = [[GCDWebServer alloc] init];
            
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            
            NSString *documentRoot = [resourcePath stringByAppendingPathComponent:@"/webui"];
            
            [webServer addGETHandlerForBasePath:@"/" directoryPath:documentRoot indexFilename:@"index.html" cacheAge:0 allowRangeRequests:YES];
            
            [webServer addHandlerForMethod:@"GET"
                                      path:@"/status"
                                      requestClass:[GCDWebServerRequest class]
                                      processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                          BOOL working = [exRunnerManager getWorkingStatus];
                                          NSString *status;
                                          if(working){
                                              status = @"Working";
                                          }else{
                                              status = @"Idle";
                                          }
                                          
                                          NSDictionary *res = [[NSDictionary alloc] initWithObjectsAndKeys:status, @"working", nil];
                                  
                                          return [GCDWebServerDataResponse responseWithJSONObject:res];
                                      }];
            
            [webServer addHandlerForMethod:@"POST"
                                      path:@"/"
                              requestClass:[GCDWebServerURLEncodedFormRequest class]
                              asyncProcessBlock:^(GCDWebServerRequest* request, GCDWebServerCompletionBlock completionBlock) {
                                  
                                  if([exRunnerManager getWorkingStatus] == YES){
                                      NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:@"There's task before, please wait until device idle.", @"errMsg", nil];
                                      GCDWebServerDataResponse* response = [GCDWebServerDataResponse responseWithJSONObject:result];
                                      completionBlock(response);
                                      return;
                                  }
                                  
                                  [exRunnerManager setWorkingStatus:YES];
                                  
                                  
                                  NSDictionary *queryString = [(GCDWebServerURLEncodedFormRequest*)request arguments];
                                  
                                  NSString* url = [queryString objectForKey:@"url"];
                                  NSString* interval = [queryString objectForKey:@"interval"];
                                  NSString* duration = [queryString objectForKey:@"duration"];
                                  
                                  [this runTestWithUrl: url interval:[interval floatValue] duration:[duration intValue]];
                                  
                                  [[NSNotificationCenter defaultCenter] addObserverForName:@"webTaskRunEnd" object:nil queue:nil usingBlock:^(NSNotification* obj){
                                      
                                      
                                      id res = [obj object];
                                      NSString *onloadTime = [res objectForKey:@"onloadTime"];
                                      NSString *domreadyTime = [res objectForKey:@"domreadyTime"];
                                      
                                      NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithObjectsAndKeys:onloadTime, @"onloadTime", domreadyTime, @"domreadyTime", nil];
                                      
                                      NSMutableArray *images = [[NSMutableArray alloc] init];
                                      
                                      NSArray *orginImages = [res objectForKey:@"captureImages"];
                                      
                                      for(NSInteger i = 0; i < orginImages.count; i++){
                                          NSDictionary *originImg = [orginImages objectAtIndex:i];
                                          
                                          UIImage *uiimage = [originImg objectForKey:@"image"];
                                          NSString *base64Image = [UIImagePNGRepresentation(uiimage) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength ];
                                          NSString *label = [originImg objectForKey:@"label"];
                                          
                                          NSDictionary *img = [[NSDictionary alloc] initWithObjectsAndKeys:base64Image, @"image",
                                              label,  @"label", nil];
                                          
                                          [images addObject:img];
                                      }
                                      
                                      [result setObject:images forKey:@"captureImages"];
                                      
                                      GCDWebServerDataResponse* response = [GCDWebServerDataResponse responseWithJSONObject:result];
                                      
                                      
                                      completionBlock(response);
                                  }];
                                  
                              }];
        }
        
        // Start server on port 3000
        [webServer startWithPort:3000 bonjourName:nil];
        NSLog(@"Please visit : %@", webServer.serverURL);
        [resultButton setTitle:@"Stop" forState:UIControlStateNormal];
        
        serverStartAt.hidden = false;
        address.hidden = false;
        address.text = [NSString stringWithFormat: @"%@", webServer.serverURL];
    }else{
        [webServer stop];
        NSLog(@"Server stopped");
        [resultButton setTitle:@"Start" forState:UIControlStateNormal];
        
        serverStartAt.hidden = true;
        address.hidden = true;
    }
}

- (void) runTestWithUrl:(NSString *)url interval:(float)interval duration:(int)duration{
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"Main"bundle:nil];
    exRunnerViewController *runnerView =[board instantiateViewControllerWithIdentifier:@"runner"];
    runnerView.url = url;
    runnerView.duration = duration;
    runnerView.space = interval;
    [self presentViewController:runnerView animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
