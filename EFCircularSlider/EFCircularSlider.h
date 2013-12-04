//
//  EFCircularSlider.h
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFCircularSlider : UIControl

typedef enum : NSUInteger {
    semiTransparentWhiteCircle,
    semiTransparentBlackCircle,
    doubleCircleWithOpenCenter,
    doubleCircleWithClosedCenter
} HandleType;

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float currentValue;
@property (nonatomic) int lineWidth;
@property (nonatomic, strong) UIColor* handleColor;
@property (nonatomic, strong) UIFont* labelFont;
@property (nonatomic) BOOL snapToLabels;
@property (nonatomic, strong) UIColor* filledColor;
@property (nonatomic, strong) UIColor* unfilledColor;
@property (nonatomic) HandleType handleType;

-(void)setHandleColor:(UIColor*)color;
-(void)setInnerMarkingLabels:(NSArray*)labels;

@end
