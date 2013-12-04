//
//  EFCircularSlider.m
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "EFCircularSlider.h"
#import <QuartzCore/QuartzCore.h>

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@implementation EFCircularSlider {
    CGFloat radius;
    CGFloat lineWidth;
    int angle;
    UIColor* handleColor;
    NSMutableDictionary* labelsWithPercents;
    NSArray* labelsEvenSpacing;
    UIFont* labelFont;
    BOOL snapToLabels;
    UIColor* filledColor;
    UIColor* unfilledColor;
    int handleType;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _maximumValue = 12.0f;
        _minimumValue = 0.0f;
        _currentValue = 0.0f;
        angle = 0;
        
        lineWidth = 5;
        radius = self.frame.size.height/2 - lineWidth/2 - 10;
        unfilledColor = [UIColor blueColor];
        filledColor = [UIColor redColor];
        handleColor = [UIColor redColor];
        labelFont = [UIFont systemFontOfSize:10.0f];
        labelsEvenSpacing = @[@"12", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11"];
        //labelsEvenSpacing = @[@"12", @"6"];
        snapToLabels = NO;
        handleType = doubleCircleWithClosedCenter;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - drawing methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Draw the unfilled circle
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 0, M_PI *2, 0);
    [unfilledColor setStroke];
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //Draw the filled circle
    if(handleType == doubleCircleWithClosedCenter || handleType == doubleCircleWithOpenCenter) {
        CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius, 3*M_PI/2, 3*M_PI/2-ToRad(angle+5), 0);
    } else {
        CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, radius, 3*M_PI/2, 3*M_PI/2-ToRad(angle), 0);
    }
    [filledColor setStroke];
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Add the labels (if necessary)
    if(labelsEvenSpacing != nil) {
        [self drawLabels:ctx];
    }
    
    //The draggable part
    [self drawHandle:ctx];
}

-(void) drawHandle:(CGContextRef)ctx{
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle: angle];
    if(handleType == semiTransparentWhiteCircle) {
        [[UIColor colorWithWhite:1.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, lineWidth, lineWidth));
    } else if(handleType == semiTransparentBlackCircle) {
        [[UIColor colorWithWhite:0.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, lineWidth, lineWidth));
    } else if(handleType == doubleCircleWithClosedCenter) {
        [handleColor set];
        CGContextAddArc(ctx, handleCenter.x - (lineWidth-10)/2, handleCenter.y + (lineWidth)/2, 8, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, lineWidth-2);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, lineWidth, lineWidth));
    } else if(handleType == doubleCircleWithOpenCenter) {
        [handleColor set];
        CGContextAddArc(ctx, handleCenter.x - (lineWidth-10)/2, handleCenter.y + (lineWidth)/2, 8, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, lineWidth-2);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextAddArc(ctx, handleCenter.x + lineWidth/4, handleCenter.y + lineWidth/4, lineWidth/2, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 1);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    CGContextRestoreGState(ctx);
}

-(void) drawLabels:(CGContextRef)ctx {
    if(labelsEvenSpacing == nil || [labelsEvenSpacing count] == 0) {
        return;
    } else {
        NSString* firstLabel = [labelsEvenSpacing objectAtIndex:0];
        CGFloat firstLabelXPos = self.frame.size.width/2 - [self widthOfString:firstLabel withFont:labelFont]/2;
        CGRect firstLabelLocation = CGRectMake(firstLabelXPos, lineWidth + 15, [self widthOfString:firstLabel withFont:labelFont], [self heightOfString:firstLabel withFont:labelFont]);
        NSDictionary *attributes = @{ NSFontAttributeName: labelFont,
                                      NSForegroundColorAttributeName: [UIColor redColor]};
        [firstLabel drawInRect:firstLabelLocation withAttributes:attributes];
        
        for (int i=1; i<[labelsEvenSpacing count]; i++) {
            NSString* label = [labelsEvenSpacing objectAtIndex:[labelsEvenSpacing count] - i];
            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            CGPoint closestPointOnCircleToLabel = [self pointFromAngle:degreesForLabel];
            CGRect labelLocation = CGRectMake(closestPointOnCircleToLabel.x, closestPointOnCircleToLabel.y, [self widthOfString:label withFont:labelFont], [self heightOfString:firstLabel withFont:labelFont]);
            int distanceToMove = -15;
            CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            float radiansTowardsCenter = ToRad(AngleFromNorth(centerPoint, closestPointOnCircleToLabel, NO));
            labelLocation.origin.x =  (labelLocation.origin.x + distanceToMove * cos(radiansTowardsCenter)) - labelLocation.size.width/4;
            labelLocation.origin.y = (labelLocation.origin.y + distanceToMove * sin(radiansTowardsCenter))- labelLocation.size.height/4;
            [label drawInRect:labelLocation withAttributes:attributes];
        }
    }
}

#pragma mark - UIControl functions

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    return YES;
}

-(BOOL) continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGPoint lastPoint = [touch locationInView:self];
    [self moveHandle:lastPoint];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    int currentAngle = floor(AngleFromNorth(centerPoint, point, NO));
    angle = 360 - 90 - currentAngle;
    _currentValue = [self valueFromAngle];
    NSLog(@"Current value is %d", (int)_currentValue);
    [self setNeedsDisplay];
}

#pragma mark - helper functions

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - lineWidth/2, self.frame.size.height/2 - lineWidth/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt-90))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt-90)));
    
    return result;
}

-(CGPoint)pointFromAngle:(int)angleInt withObjectSize:(CGSize)size{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - lineWidth/2, self.frame.size.height/2 - lineWidth/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt-90))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt-90)));
    
    return result;
}

static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

-(float) valueFromAngle {
    if(angle < 0) {
        _currentValue = -angle;
    } else {
        _currentValue = 270 - angle + 90;
    }
    return (_currentValue*(_maximumValue - _minimumValue))/360.0f;
}

- (CGFloat) widthOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
//    NSLog(@"width of string is %f", [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width);
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (CGFloat) heightOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
//    NSLog(@"height of string is %f", [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height);
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}

#pragma mark - public methods
-(void)setHandleColor:(UIColor *)color {
    handleColor = color;
}

-(void)setInnerMarkingLabels:(NSArray*)labels{
    labelsEvenSpacing = labels;
    [self setNeedsDisplay];
}

-(void)setFilledColor:(UIColor *)color {
    filledColor = color;
}

-(void)setUnfilledColor:(UIColor *)color {
    unfilledColor = color;
}

@end
