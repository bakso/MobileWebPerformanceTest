//
//  exServerViewController.m
//  MobileWebPerformanceTest
//
//  Created by fanyu on 14-10-10.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "exServerViewController.h"
#import "GCDWebServerURLEncodedFormRequest.h"


@interface exServerViewController ()
@end

@implementation exServerViewController
@synthesize webServer;
@synthesize serverStartAt;
@synthesize address;

- (IBAction)onClick:(id)sender {
    UIButton *resultButton = (UIButton *)sender;
    
    if([resultButton.titleLabel.text isEqualToString:@"Start"]){
        if(webServer == nil){
            webServer = [[GCDWebServer alloc] init];
            
            
            [webServer addGETHandlerForBasePath:@"/" directoryPath:NSHomeDirectory() indexFilename:nil cacheAge:3600 allowRangeRequests:YES];
//            [webServer addHandlerForMethod:@"GET"
//                                      path:@"/"
//                              requestClass:[GCDWebServerRequest class]
//                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
//                                  
//                                  NSString* html = @" \
//                                  <html><body> \
//                                  <form name=\"input\" action=\"/\" method=\"post\" enctype=\"application/x-www-form-urlencoded\"> \
//                                  Value: <input type=\"text\" name=\"value\"> \
//                                  <input type=\"submit\" value=\"Submit\"> \
//                                  </form> \
//                                  </body></html> \
//                                  ";
//                                  return [GCDWebServerDataResponse responseWithHTML:html];
//                                  
//                              }];
            
            
            
            [webServer addHandlerForMethod:@"POST"
                                      path:@"/"
                              requestClass:[GCDWebServerURLEncodedFormRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                  
                                  NSString* value = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"value"];
                                  NSString* html = [NSString stringWithFormat:@"<html><body><p>%@</p></body></html>", value];
                                  return [GCDWebServerDataResponse responseWithHTML:html];
                                  
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
