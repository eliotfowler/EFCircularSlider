//
//  EFImageHandleViewController.m
//  EFCircularSlider
//
//  Created by Ilter Cengiz on 20/12/14.
//  Copyright (c) 2014 Eliot Fowler. All rights reserved.
//

#import "EFImageHandleViewController.h"
#import "EFCircularSlider.h"

@interface EFImageHandleViewController ()

@property (nonatomic) EFCircularSlider *circularSlider;

@end

@implementation EFImageHandleViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGSize size = CGSizeMake(240.0, 240.0);
    CGRect frame = (CGRect){.origin = CGPointMake(0.0, 0.0), .size = size};
    self.circularSlider = [[EFCircularSlider alloc] initWithFrame:frame];
    self.circularSlider.handleType = CircularSliderHandleTypeImage;
    self.circularSlider.handleImage = [UIImage imageNamed:@"Handle"];
    self.circularSlider.currentValue = 10.0;
    self.circularSlider.clipsToBounds = NO;
    
    [self.view addSubview:self.circularSlider];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    CGRect frame = self.circularSlider.frame;
    frame.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(self.circularSlider.frame)) / 2.0;
    frame.origin.y = (CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.circularSlider.frame)) / 2.0;
    
    self.circularSlider.frame = frame;
    
}

@end
