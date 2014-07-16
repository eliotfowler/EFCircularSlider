//
//  EFCircularTrig.h
//  
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Helper class that provides interfaces for calculations involving trigonometry.
 *  Also includes function for drawing arcs.
 */
@interface EFCircularTrig : NSObject

/**
 *  Determines the angle between two points on a circle
 *
 *  @param fromPoint Point on the circle circumference
 *  @param toPoint   Point on the circle circumference
 *
 *  @return Angle in degrees between the two points, relative to North as 0 degrees (clockwise)
 */
+(CGFloat) angleRelativeToNorthFromPoint:(CGPoint)fromPoint
                                 toPoint:(CGPoint)toPoint;

/**
 *  Determine the coordinates of a point on a circle at a given angle
 *
 *  @param radius         Radius of the circle
 *  @param angleFromNorth Angle from North as 0 degrees (clockwise)
 *
 *  @return Point on the circle circumference
 */
+(CGPoint)pointOnRadius:(CGFloat)radius
       atAngleFromNorth:(CGFloat)angleFromNorth;

/**
 *  Draw a filled circle using current context settings
 *
 *  @param ctx    Graphics context within which to fill a circle
 *  @param center Center of the circle to draw
 *  @param radius Radius of the circle to draw
 */
+(void) drawFilledCircleInContext:(CGContextRef)ctx
                           center:(CGPoint)center
                           radius:(CGFloat)radius;

/**
 *  Draw an empty circle with a variable line width using current context settings
 *
 *  @param ctx       Graphics context within which to fill a circle
 *  @param center    Center of the circle to draw
 *  @param radius    Radius of the circle to draw
 *  @param lineWidth Width of line to draw around circle (centered on radius)
 */
+(void) drawUnfilledCircleInContext:(CGContextRef)ctx
                             center:(CGPoint)center
                             radius:(CGFloat)radius
                          lineWidth:(CGFloat)lineWidth;

/**
 *  Draw an unfilled arc (ie partial circle) with a variable line width using current context settings
 *
 *  @param ctx                Graphics context within which to fill a circle
 *  @param center             Center of the circle to draw
 *  @param radius             Radius of the circle to draw
 *  @param lineWidth          Width of line to draw around circle (centered on radius)
 *  @param fromAngleFromNorth Angle in degrees to draw arc from (clockwise)
 *  @param toAngleFromNorth   Angle in degrees to draw arc to (clockwise)
 */
+(void) drawUnfilledArcInContext:(CGContextRef)ctx
                          center:(CGPoint)center
                          radius:(CGFloat)radius
                       lineWidth:(CGFloat)lineWidth
              fromAngleFromNorth:(CGFloat)fromAngleFromNorth
                toAngleFromNorth:(CGFloat)toAngleFromNorth;

/**
 *  Calculates how many degrees an arc spans along the circumference of a circle
 *
 *  @param arcLength Length of arc segment along circle circumference
 *  @param radius    Radius of circle whose circumference arc sits upon
 *
 *  @return Degrees from start of arc to end of arc along circle's circumference
 */
+(CGFloat) degreesForArcLength:(CGFloat)arcLength
            onCircleWithRadius:(CGFloat)radius;

/**
 *  Given an unfilled arc or circle, determine width from arc center to outside edge of line
 *
 *  @param radius    Radius of the arc
 *  @param lineWidth Width of line drawn around arc
 *
 *  @return Distance from center to outer edge of unfilled arc
 */
+(CGFloat) outerRadiuOfUnfilledArcWithRadius:(CGFloat)radius
                                   lineWidth:(CGFloat)lineWidth;

/**
 *  Given an unfilled arc or circle, determine width from arc center to inside edge of line
 *
 *  @param radius    Radius of the arc
 *  @param lineWidth Width of line drawn around arc
 *
 *  @return Distance from center to inner edge of unfilled arc
 */
+(CGFloat)innerRadiusOfUnfilledArcWithRadius:(CGFloat)radius
                                   lineWidth:(CGFloat)lineWidth;

@end
