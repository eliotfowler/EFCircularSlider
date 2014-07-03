//
//  EFCircularTrig.m
//  
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "EFCircularTrig.h"

/**
 *  Macro for converting radian degrees from cartesian reference (0 radians is along X axis) 
 *   to 'compass style' reference (0 radians is along Y axis (ie North on a compass)).
 *
 *  @param rad Radian degrees to convert from Cartesian reference
 *
 *  @return Radian Degrees in 'Compass' reference
 */
#define CartesianToCompass(rad) ( rad + M_PI/2 )
/**
 *  Macro for converting radian degrees from 'compass style' reference (0 radians is along Y axis (ie North on a compass))
 *   to cartesian reference (0 radians is along X axis).
 *
 *  @param rad Radian degrees to convert from 'Compass' reference
 *
 *  @return Radian Degrees in Cartesian reference
 */
#define CompassToCartesian(rad) ( rad - M_PI/2 )
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@implementation EFCircularTrig

+(CGFloat) angleRelativeToNorthFromPoint:(CGPoint)fromPoint
                                 toPoint:(CGPoint)toPoint
{
    CGPoint v = CGPointMake(toPoint.x-fromPoint.x,toPoint.y-fromPoint.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y));
    v.x /= vmag;
    v.y /= vmag;
    double cartesianRadians = atan2(v.y,v.x);
    // Need to convert from cartesian style radians to compass style
    double compassRadians = CartesianToCompass(cartesianRadians);
    if (compassRadians < 0)
    {
        compassRadians += (2 * M_PI);
    }
    NSAssert(compassRadians >= 0 && compassRadians <= 2 * M_PI, @"angleRelativeToNorth should be always positive");
    return ToDeg(compassRadians);
}

+(CGPoint)pointOnRadius:(CGFloat)radius
       atAngleFromNorth:(CGFloat)angleFromNorth
{
    //Get the point on the circle for this angle
    CGPoint result;
    // Need to adjust from 'compass' style angle to cartesian angle
    float cartesianAngle = CompassToCartesian(ToRad(angleFromNorth));
    result.y = round(radius * sin(cartesianAngle)) ;
    result.x = round(radius * cos(cartesianAngle));
    
    return result;
}

#pragma mark - Draw arcs

+(void) drawFilledCircleInContext:(CGContextRef)ctx
                           center:(CGPoint)center
                           radius:(CGFloat)radius
{
    CGContextFillEllipseInRect(ctx, CGRectMake(center.x - (radius),
                                               center.y - (radius),
                                               2 * radius,
                                               2 * radius));
}

+(void) drawUnfilledCircleInContext:(CGContextRef)ctx
                             center:(CGPoint)center
                             radius:(CGFloat)radius
                          lineWidth:(CGFloat)lineWidth
{
    [self drawUnfilledArcInContext:ctx center:center radius:radius lineWidth:lineWidth fromAngleFromNorth:0 toAngleFromNorth:360]; // 0 - 360 is full circle
}

+(void) drawUnfilledArcInContext:(CGContextRef)ctx
                          center:(CGPoint)center
                          radius:(CGFloat)radius
                       lineWidth:(CGFloat)lineWidth
              fromAngleFromNorth:(CGFloat)fromAngleFromNorth
                toAngleFromNorth:(CGFloat)toAngleFromNorth
{
    float cartesianFromAngle = CompassToCartesian(ToRad(fromAngleFromNorth));
    float cartesianToAngle   = CompassToCartesian(ToRad(toAngleFromNorth));
    
    CGContextAddArc(ctx,
                    center.x,   // arc start point x
                    center.y,   // arc start point y
                    radius,     // arc radius from center
                    cartesianFromAngle, cartesianToAngle,
                    0); // iOS flips the y coordinate so anti-clockwise (specified here by 0) becomes clockwise (desired)!
    
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
}

+(CGFloat) degreesForArcLength:(CGFloat)arcLength
            onCircleWithRadius:(CGFloat)radius
{
    float totalCircumference = 2 * M_PI * radius;
    
    float arcRatioToCircumference = arcLength / totalCircumference;
    
    return 360 * arcRatioToCircumference; // If arcLength is exactly half circumference, that is exactly half a circle in degrees
}


#pragma mark - Calculate radii of arcs with line widths
/*
 *  For an unfilled arc.
 *
 *  Radius of outer arc (center to outside edge)  |          ---------
 *      = radius + 0.5 * lineWidth                |      +++++++++++++++
 *                                                |    /++/++++ --- ++++\++\
 *  Radius of inner arc (center to inside edge)   |   /++/++/         \++\++\
 *      = radius - (0.5 * lineWidth)              |  |++|++|     .     |++|++|
 *                                         outer edge^  ^-radius-^     ^inner edge
 *
 */
+(CGFloat) outerRadiuOfUnfilledArcWithRadius:(CGFloat)radius
                                   lineWidth:(CGFloat)lineWidth
{
    return radius + 0.5 * lineWidth;
}

+(CGFloat)innerRadiusOfUnfilledArcWithRadius:(CGFloat)radius
                                   lineWidth:(CGFloat)lineWidth
{
    return radius - 0.5 * lineWidth;
}

@end
