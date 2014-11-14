//
//  exResultViewController.m
//  test2
//
//  Created by fanyu on 14-8-31.
//  Copyright (c) 2014年 fanyu. All rights reserved.
//

#import "exResultViewController.h"

@interface exResultViewController () <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property CGFloat btmHeight;
@property UIView* btmBar;

@end



@implementation exResultViewController

@synthesize resultImages;
@synthesize scrollView;
@synthesize topScrollView;
@synthesize btmHeight;
@synthesize btmBar;

-(BOOL)shouldAutorotate{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}



-(id) initWithResultImages: (NSMutableArray*) images{
    self = [super init];
    if(self){
        
    }
    return self;
}

-(void) popupViewC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(popupViewC)];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    NSUInteger count = resultImages.count;
    // Do any additional setup after loading the view.
    CGFloat viewWidth = 320;
    CGFloat viewHeight = 245;
    CGFloat singleViewWidth = 152;
    CGFloat imageViewHeight = 210;
    CGFloat imageContentTop = 25;
    CGFloat txMgLeft = 5;
    btmHeight = 30;
    
    //UIBarButtonItem* backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem.title = @"Back";
    
    NSLog(@"%f", self.navigationController.navigationBar.bounds.size.height);
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    scrollView.delegate = self;
    
    [scrollView setBackgroundColor:[[UIColor alloc] initWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
    
    self.scrollView.contentSize = CGSizeMake(singleViewWidth*count, viewHeight);
    
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    
    CGFloat left = 0;
    for (NSUInteger i = 0; i <count; i++) {
        NSDictionary* obj = [resultImages objectAtIndex:i];
        UIImage* image = [obj objectForKey: @"image"];
        CGFloat scale = image.size.height / imageViewHeight;
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(left, 0, singleViewWidth, viewHeight)];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(txMgLeft, imageContentTop, image.size.width/scale, imageViewHeight)];
        [imageView setImage:image];
        [view addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(txMgLeft, 0, 100, imageContentTop)];
        [view addSubview:label];
        label.text = [obj objectForKey: @"label"];
        [scrollView addSubview:view];
        left += (singleViewWidth);
    }
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Back" forState:UIControlStateNormal];    
    
    
    topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [topScrollView setContentSize:CGSizeMake(320, viewHeight+72)];
    [topScrollView addSubview:scrollView];
    [self.view addSubview:topScrollView];
    
    _domreadyTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(txMgLeft, viewHeight+5,  300, 28)];
    _domreadyTimeLabel.text = [NSString stringWithFormat:@"DOM Ready Time: %@ms", _domreadyTime];
    [topScrollView addSubview:_domreadyTimeLabel];
    
    _onloadTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(txMgLeft, viewHeight+5+28,  300, 28)];
    _onloadTimeLabel.text = [NSString stringWithFormat:@"Onload Time: %@ms", _onloadTime];
    [topScrollView addSubview:_onloadTimeLabel];
}

- (void) back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)resetScrollContainer{
    CGSize sizeOfScreen = [[UIScreen mainScreen] bounds].size;
    [topScrollView setFrame:CGRectMake(0, 0, sizeOfScreen.width, sizeOfScreen.height)];
    [scrollView setFrame:CGRectMake(0, 0, sizeOfScreen.width, 245)];
}


-(void) viewDidAppear:(BOOL)animated{
    [self resetScrollContainer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {
    
    [self resetScrollContainer];
    
//    switch (orientation)
//    {
//        case UIInterfaceOrientationPortrait:
//        case UIInterfaceOrientationPortraitUpsideDown:
//        {
//            //load the portrait view
//        }
//            
//            break;
//        case UIInterfaceOrientationLandscapeLeft:
//        case UIInterfaceOrientationLandscapeRight:
//        {
//            //load the landscape view
//        }
//            break;
//        case UIInterfaceOrientationUnknown:break;
//    }
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
