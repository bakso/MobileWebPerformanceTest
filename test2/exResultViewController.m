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
@end

@implementation exResultViewController

@synthesize resultImages;
@synthesize scrollView;


-(id) initWithResultImages: (NSMutableArray*) images{
    self = [super init];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    int count = resultImages.count;
    // Do any additional setup after loading the view.
    CGFloat viewWidth = 320;
    CGFloat viewHeight = 230;
    CGFloat imageViewHeight = 210;
    CGFloat singleViewWidth = 170;
    CGFloat imageContentTop = 10;
    
    NSLog(@"scrollView x,y,w,h: %d,%d,%f,%f", 0, 50, viewWidth, viewHeight);
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, viewWidth, viewHeight)];
    [self.view addSubview:scrollView];
    
    scrollView.delegate = self;
    [scrollView setBackgroundColor:[UIColor lightGrayColor]];
    
    self.scrollView.contentSize = CGSizeMake(viewWidth*count, viewHeight);
    
//    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    
    CGFloat left = 0;
    for (NSUInteger i = 0; i <count; i++) {
        UIImage* image = [resultImages objectAtIndex:i];
        CGFloat scale = image.size.height / imageViewHeight;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(left, 0, singleViewWidth, viewHeight)];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageContentTop, image.size.width/scale, imageViewHeight)];
        
        [imageView setImage:image];
        [view addSubview:imageView];
        
        
        [scrollView addSubview:view];
        
        left += (singleViewWidth);
    }
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
