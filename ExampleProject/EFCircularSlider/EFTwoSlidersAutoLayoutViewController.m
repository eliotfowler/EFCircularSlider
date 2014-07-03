//
//  EFTwoSlidersAutoLayoutViewController.m
//  EFCircularSlider
//
//  Created by Eliot Fowler on 12/5/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "EFTwoSlidersAutoLayoutViewController.h"
#import "EFCircularSlider.h"

@interface EFTwoSlidersAutoLayoutViewController ()

@property (nonatomic, strong) NSMutableArray *myConstraints;
@property (nonatomic, strong) EFCircularSlider *topSlider;
@property (nonatomic, strong) EFCircularSlider *bottomSlider;

@end

@implementation EFTwoSlidersAutoLayoutViewController

-(void) updateViewConstraints
{
    if (!self.myConstraints)
    {
        self.myConstraints = [[NSMutableArray alloc] init];
        
        NSDictionary *views = @{@"topSlider":self.topSlider,
                                @"bottomSlider":self.bottomSlider,
                                @"topGuide" : self.topLayoutGuide};
        
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topGuide]-[topSlider]-[bottomSlider(100)]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[topSlider]-50-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        [self.myConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[bottomSlider]-|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:views]];
        
        [self.view addConstraints:self.myConstraints];
    }
    [super updateViewConstraints];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topSlider = [[EFCircularSlider alloc] init];
    self.topSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.topSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.topSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [self.view addSubview:self.topSlider];
    
    self.bottomSlider = [[EFCircularSlider alloc] init];
    self.bottomSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.bottomSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter;
    self.bottomSlider.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    [self.view addSubview:self.bottomSlider];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
