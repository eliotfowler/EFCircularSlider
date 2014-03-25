//
//  EFCircularSlider.m
//  Awake
//
//  Created by Eliot Fowler on 12/3/13.
//  Copyright (c) 2013 Eliot Fowler. All rights reserved.
//

#import "EFCircularSlider.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#define kDefaultFontSize 14.0f;
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

@interface EFCircularSlider (private)

@property (readonly, nonatomic) CGFloat radius;

@end

@implementation EFCircularSlider {
    int angle;
    int fixedAngle;
    NSMutableDictionary* labelsWithPercents;
    NSArray* labelsEvenSpacing;
}

- (void)defaults {
    // Defaults
    _maximumValue = 100.0f;
    _minimumValue = 0.0f;
    _currentValue = 0.0f;
    _lineWidth = 5;
    _lineRadiusDisplacement = 0;
    _unfilledColor = [UIColor blackColor];
    _filledColor = [UIColor redColor];
    _handleColor = _filledColor;
    _labelFont = [UIFont systemFontOfSize:10.0f];
    _snapToLabels = NO;
    _handleType = EFSemiTransparentWhiteCircle;
    _labelColor = [UIColor redColor];
    _labelDisplacement = 2;
    
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaults];
        
        [self setFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self=[super initWithCoder:aDecoder])){
        [self defaults];
    }
    
    return self;
}


#pragma mark - Setter/Getter

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    angle = [self angleFromValue];
}

- (CGFloat)radius {
    //radius = self.frame.size.height/2 - [self circleDiameter]/2;
    return self.frame.size.height/2 - _lineWidth/2 - ([self circleDiameter]-_lineWidth) - _lineRadiusDisplacement;
}

- (void)setCurrentValue:(float)currentValue {
    _currentValue=currentValue;
    
    if(_currentValue>_maximumValue) _currentValue=_maximumValue;
    else if(_currentValue<_minimumValue) _currentValue=_minimumValue;
    
    angle = [self angleFromValue];
    [self setNeedsLayout];
    [self setNeedsDisplay];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - drawing methods

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //Draw the unfilled circle
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, self.radius, 0, M_PI *2, 0);
    [_unfilledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    //Draw the filled circle
    if((_handleType == EFDoubleCircleWithClosedCenter || _handleType == EFDoubleCircleWithOpenCenter) && fixedAngle > 5) {
        CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, self.radius, 3*M_PI/2, 3*M_PI/2-ToRad(angle+3), 0);
    } else {
        CGContextAddArc(ctx, self.frame.size.width/2  , self.frame.size.height/2, self.radius, 3*M_PI/2, 3*M_PI/2-ToRad(angle), 0);
    }
    [_filledColor setStroke];
    CGContextSetLineWidth(ctx, _lineWidth);
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
    if(_handleType == EFSemiTransparentWhiteCircle) {
        [[UIColor colorWithWhite:1.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth, _lineWidth));
    } else if(_handleType == EFSemiTransparentBlackCircle) {
        [[UIColor colorWithWhite:0.0 alpha:0.7] set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth, _lineWidth));
    } else if(_handleType == EFDoubleCircleWithClosedCenter) {
        [_handleColor set];
        CGContextAddArc(ctx, handleCenter.x + (_lineWidth)/2, handleCenter.y + (_lineWidth)/2, _lineWidth, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 7);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, _lineWidth-1, _lineWidth-1));
    } else if(_handleType == EFDoubleCircleWithOpenCenter) {
        [_handleColor set];
        CGContextAddArc(ctx, handleCenter.x + (_lineWidth)/2, handleCenter.y + (_lineWidth)/2, _lineWidth/2 + 5, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 4);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
        
        CGContextAddArc(ctx, handleCenter.x + _lineWidth/2, handleCenter.y + _lineWidth/2, _lineWidth/2, 0, M_PI *2, 0);
        CGContextSetLineWidth(ctx, 2);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        CGContextDrawPath(ctx, kCGPathStroke);
    } else if(_handleType == EFBigCircle) {
        [_handleColor set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-2.5, handleCenter.y-2.5, _lineWidth+5, _lineWidth+5));
    }
    
    CGContextRestoreGState(ctx);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint p1 = [self centerPoint];
    CGPoint p2 = point;
    CGFloat xDist = (p2.x - p1.x);
    CGFloat yDist = (p2.y - p1.y);
    double distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance < self.radius + 11;
}

-(void) drawLabels:(CGContextRef)ctx {
    if(labelsEvenSpacing == nil || [labelsEvenSpacing count] == 0) {
        return;
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        NSDictionary *attributes = @{ NSFontAttributeName: _labelFont,
                                      NSForegroundColorAttributeName: _labelColor
                                      };
#endif
        
        CGFloat fontSize = ceilf(_labelFont.pointSize);
        
        NSInteger distanceToMove = -[self circleDiameter]/2 - fontSize/2 - _labelDisplacement;
        
        for (int i=0; i<[labelsEvenSpacing count]; i++)
        {
            NSString *label = [labelsEvenSpacing objectAtIndex:[labelsEvenSpacing count] - i - 1];
            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            
            CGSize labelSize=CGSizeMake([self widthOfString:label withFont:_labelFont], [self heightOfString:label withFont:_labelFont]);
            CGPoint closestPointOnCircleToLabel = [self pointFromAngle:degreesForLabel withObjectSize:labelSize];

            CGRect labelLocation = CGRectMake(closestPointOnCircleToLabel.x, closestPointOnCircleToLabel.y, labelSize.width, labelSize.height);
            
            CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            float radiansTowardsCenter = ToRad(AngleFromNorth(centerPoint, closestPointOnCircleToLabel, NO));
            
            labelLocation.origin.x = (labelLocation.origin.x + distanceToMove * cos(radiansTowardsCenter));
            labelLocation.origin.y = (labelLocation.origin.y + distanceToMove * sin(radiansTowardsCenter));
            
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
            [label drawInRect:labelLocation withAttributes:attributes];
#else
            [_labelColor setFill];
            [label drawInRect:labelLocation withFont:_labelFont];
#endif
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
    if(_snapToLabels && labelsEvenSpacing != nil) {
        CGFloat newAngle=0;
        float minDist = 360;
        for (int i=0; i<[labelsEvenSpacing count]; i++) {
            CGFloat percentageAlongCircle = i/(float)[labelsEvenSpacing count];
            CGFloat degreesForLabel = percentageAlongCircle * 360;
            if(abs(fixedAngle - degreesForLabel) < minDist) {
                newAngle=degreesForLabel ? 360 - degreesForLabel : 0;
                minDist = abs(fixedAngle - degreesForLabel);
            }
        }
        angle = newAngle;
        _currentValue = [self valueFromAngle];
        [self setNeedsDisplay];
    }
}

-(void)moveHandle:(CGPoint)point {
    CGPoint centerPoint;
    centerPoint = [self centerPoint];
    int currentAngle = floor(AngleFromNorth(centerPoint, point, NO));
    angle = 360 - 90 - currentAngle;
    _currentValue = [self valueFromAngle];
    [self setNeedsDisplay];
}

- (CGPoint)centerPoint {
    return CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

#pragma mark - helper functions

-(CGPoint)pointFromAngle:(int)angleInt{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - _lineWidth/2, self.frame.size.height/2 - _lineWidth/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + self.radius * sin(ToRad(-angleInt-90))) ;
    result.x = round(centerPoint.x + self.radius * cos(ToRad(-angleInt-90)));
    
    return result;
}

-(CGPoint)pointFromAngle:(int)angleInt withObjectSize:(CGSize)size{
    
    //Define the Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - size.width/2, self.frame.size.height/2 - size.height/2);
    
    //Define The point position on the circumference
    CGPoint result;
    result.y = round(centerPoint.y + self.radius * sin(ToRad(-angleInt-90))) ;
    result.x = round(centerPoint.x + self.radius * cos(ToRad(-angleInt-90)));
    
    return result;
}

- (CGFloat)circleDiameter {
    if(_handleType == EFSemiTransparentWhiteCircle) {
        return _lineWidth;
    } else if(_handleType == EFSemiTransparentBlackCircle) {
        return _lineWidth;
    } else if(_handleType == EFDoubleCircleWithClosedCenter) {
        return _lineWidth * 2 + 3.5;
    } else if(_handleType == EFDoubleCircleWithOpenCenter) {
        return _lineWidth + 2.5 + 2;
    } else if(_handleType == EFBigCircle) {
        return _lineWidth + 2.5;
    }
    return 0;
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
    fixedAngle = _currentValue;
    return (_currentValue*(_maximumValue - _minimumValue))/360.0f;
}

- (float)angleFromValue {
    angle = 360 - (360.0f*_currentValue/_maximumValue);
    
    if(angle==360) angle=0;
    
    return angle;
}

- (CGFloat) widthOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (CGFloat) heightOfString:(NSString *)string withFont:(UIFont*)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].height;
}

#pragma mark - public methods
-(void)setInnerMarkingLabels:(NSArray*)labels{
    labelsEvenSpacing = labels;
    [self setNeedsDisplay];
}

@end
