//
//  EFBigLineViewController.m
//  EFCircularSlider
//
//  Created by Christian Bianciotto on 21/03/14.
//  Copyright (c) 2014 Eliot Fowler. All rights reserved.
//

#import "EFBigLineViewController.h"
#import "EFCircularSlider.h"

@interface EFBigLineViewController ()

@end

@implementation EFBigLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect sliderFrame = CGRectMake(0, 120, 320, 320);
    EFCircularSlider* circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    
    circularSlider.lineWidth = 50;
    circularSlider.labelFont = [UIFont fontWithName:@"GillSans-Light" size:16];
    
    NSArray* labels = @[@"B", @"C", @"D", @"E"];
    [circularSlider setInnerMarkingLabels:labels];
    
    [self.view addSubview:circularSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
