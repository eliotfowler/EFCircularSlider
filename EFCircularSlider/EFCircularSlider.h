//
//  EFCircularSlider.h
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Class used to define a circular control with a handle that can be moved around the circumference to represent a value
 */
@interface EFCircularSlider : UIControl

typedef enum : NSUInteger {
    CircularSliderHandleTypeSemiTransparentWhiteCircle,
    CircularSliderHandleTypeSemiTransparentBlackCircle,
    CircularSliderHandleTypeDoubleCircleWithOpenCenter,
    CircularSliderHandleTypeDoubleCircleWithClosedCenter,
    CircularSliderHandleTypeBigCircle
} CircularSliderHandleType;

#pragma mark - Default Autolayout initialiser
/**
 *  Initialise the class with a desired radius
 *  This initialiser should be used for autolayout - use initWithFrame otherwise
 *  Note: Intrinsice content size will be based on this parameter, lineWidth and handleType
 *
 *  @param radius Desired radius of circular slider
 *
 *  @return Allocated instance of this class
 */
-(id)initWithRadius:(CGFloat)radius;


#pragma mark - Values
/**
 *  @property Value at North/midnight (start)
 */
@property (nonatomic) float minimumValue;
/**
 *  @property Value at North/midnight (end)
 */
@property (nonatomic) float maximumValue;
/**
 *  @property Current value between North/midnight (start) and North/midnight (end) - clockwise direction
 */
@property (nonatomic) float currentValue;


#pragma mark - Labels
/**
 *  @property BOOL indicating whether values snap to nearest label
 */
@property (nonatomic) BOOL snapToLabels;
/**
 *  Note: The LAST label will appear at North/midnight
 *        The FIRST label will appear at the first interval after North/midnight
 *
 *  @property NSArray of strings used to render labels at regular intervals within the circle
 */
@property (nonatomic, strong) NSArray *innerMarkingLabels;


#pragma mark - Visual Customisation
/**
 *  @property Width of the line to draw for slider
 */
@property (nonatomic) int lineWidth;
/**
 *  @property Color of filled portion of line (from North/midnight start to currentValue)
 */
@property (nonatomic, strong) UIColor* filledColor;
/**
 *  @property Color of unfilled portion of line (from currentValue to North/midnight end)
 */
@property (nonatomic, strong) UIColor* unfilledColor;
/**
 *  Note: If this property is not set, filledColor will be used.
 *        If handleType is semiTransparent*, specified color will override this property.
 *
 *  @property Color of the handle
 */
@property (nonatomic, strong) UIColor* handleColor;
/**
 *  @property Font of the inner marking labels within the circle
 */
@property (nonatomic, strong) UIFont*  labelFont;
/**
 *  @property Color of the inner marking labels within the circle
 */
@property (nonatomic, strong) UIColor* labelColor;
/**
 *  Note: A negative value will move the label closer to the center. A positive value will move the label closer to the circumference
 *  @property Value with which to displace all labels along radial line from center to slider circumference.
 */
@property (nonatomic) CGFloat labelDisplacement;
/**
 *  @property Type of the handle to display to represent draggable current value
 */
@property (nonatomic) CircularSliderHandleType handleType;

@end
