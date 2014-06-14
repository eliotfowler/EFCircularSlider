//
//  EFCircularSlider.h
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFCircularSlider : UIControl

typedef NS_ENUM(NSInteger, EFHandleType) {
    EFSemiTransparentWhiteCircle,
    EFSemiTransparentBlackCircle,
    EFDoubleCircleWithOpenCenter,
    EFDoubleCircleWithClosedCenter,
    EFBigCircle
};

@property (nonatomic) float minimumValue;
@property (nonatomic) float maximumValue;
@property (nonatomic) float currentValue;

@property (nonatomic) int lineWidth;
@property (nonatomic) int lineRadiusDisplacement;
@property (nonatomic, strong) UIColor* filledColor;
@property (nonatomic, strong) UIColor* unfilledColor;

@property (nonatomic, strong) UIColor* handleColor;
@property (nonatomic) EFHandleType handleType;

@property (nonatomic, strong) UIFont* labelFont;
@property (nonatomic, strong) UIColor* labelColor;
@property (nonatomic, assign) NSInteger labelDisplacement;
@property (nonatomic) BOOL snapToLabels;

/**
 Calling this method sets currentValue of `EFCircularSlider` without triggering UIControlEventValueChanged action.
 
 @param currentValue value for `EFCircularSlider`
 */
-(void)setCurrentValueManually:(float)currentValue;

-(void)setInnerMarkingLabels:(NSArray*)labels;

@end
