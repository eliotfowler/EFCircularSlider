//
//  EFBigCircleHandleViewController.m
//  EFCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "EFBigCircleHandleViewController.h"
#import "EFCircularSlider.h"

@interface EFBigCircleHandleViewController ()

@end

@implementation EFBigCircleHandleViewController

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
	
    CGRect sliderFrame = CGRectMake(60, 150, 200, 200);
    EFCircularSlider* circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    circularSlider.handleType = CircularSliderHandleTypeBigCircle;
    circularSlider.handleColor = [UIColor blueColor];
    [self.view addSubview:circularSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
