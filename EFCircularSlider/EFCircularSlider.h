//
//  EFCircularSlider.h
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFCircularSlider : UIControl

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float currentValue;

typedef enum : NSUInteger {
    semiTransparentWhiteCircle,
    semiTransparentBlackCircle,
    doubleCircleWithOpenCenter,
    doubleCircleWithClosedCenter
} HandleType;

-(void)setHandleColor:(UIColor*)color;
-(void)setInnerMarkingLabels:(NSArray*)labels;

@end
