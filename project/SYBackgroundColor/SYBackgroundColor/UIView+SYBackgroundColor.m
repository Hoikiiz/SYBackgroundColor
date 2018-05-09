//
//  UIView+SYBackgroundColor.m
//  SYBackgroundColor
//
//  Created by SunYang on 2017/12/24.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "UIView+SYBackgroundColor.h"
#import <objc/runtime.h>

#define SY_Angle(x) M_PI/180.0*x

static CAShapeLayer *__SY_AnimationShapeLayer;
static const CGFloat __SY_Defualt_Duration = 0.25;
static BOOL __SY_Animating = false;
static BOOL __SY_OriginClip = false;


@implementation UIView (SYBackgroundColor)

- (CALayer *)getAnimatonLayer {
    if (__SY_Animating) {
        if (__SY_AnimationShapeLayer == nil) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.frame = self.bounds;
            [self.layer addSublayer:shapeLayer];
            shapeLayer.contentsScale = [[UIScreen mainScreen] scale];
            __SY_AnimationShapeLayer = shapeLayer;
        }
        return __SY_AnimationShapeLayer;
    } else {
        return nil;
    }
}

- (void)setSYBackgroundImage:(UIImage *)image {
    __SY_Animating = true;

    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self getAnimatonLayer];
    shapeLayer.fillColor = [UIColor colorWithPatternImage:image].CGColor;
    
    // set animation completion call back
    [CATransaction setCompletionBlock:^{
        self.backgroundColor = [UIColor colorWithCGColor:__SY_AnimationShapeLayer.fillColor];
        [__SY_AnimationShapeLayer removeFromSuperlayer];
        __SY_AnimationShapeLayer = nil;
        __SY_Animating = false;
        self.clipsToBounds = __SY_OriginClip;
    }];
    
    // init fromValue
    CGPoint center = [self adjustFromPoint:CGPointZero];
    UIBezierPath *originPath = [UIBezierPath bezierPathWithArcCenter:center radius:1.0 startAngle:SY_Angle(0) endAngle:SY_Angle(360) clockwise:true];
    shapeLayer.path = originPath.CGPath;
    UIBezierPath *newPath = [UIBezierPath bezierPathWithArcCenter:center radius:[self raduisWithPoint:center] startAngle:SY_Angle(0) endAngle:SY_Angle(360) clockwise:true];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
    animation.duration = 1.0;
    animation.toValue = (__bridge id)newPath.CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeIn"];
    animation.removedOnCompletion = false;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:@""];
}

- (BOOL)setSYBackgroundColor:(UIColor *)backgroundColor {
    return [self setSYBackgroundColor:backgroundColor duration:__SY_Defualt_Duration direction:SYBackgroundAnimationDirectionDiffuse fromPoint:CGPointZero];
}

- (BOOL)setSYBackgroundColor:(UIColor *)backgroundColor direction:(SYBackgroundAnimationDirection)direction {
    return [self setSYBackgroundColor:backgroundColor duration:__SY_Defualt_Duration direction:SYBackgroundAnimationDirectionDiffuse fromPoint:CGPointZero];
}

- (BOOL)setSYBackgroundColor:(UIColor *)backgroundColor
                    duration:(CGFloat)duration
                   direction:(SYBackgroundAnimationDirection)direction
                   fromPoint:(CGPoint)fromPoint {
    if (backgroundColor != nil &&
        __SY_AnimationShapeLayer == nil) {
        __SY_Animating = true;
        __SY_OriginClip = self.clipsToBounds;
        self.clipsToBounds = true;
        switch (direction) {
            case SYBackgroundAnimationDirectionDiffuse:
                [self sy_diffuseColro:backgroundColor duration:duration fromPotin:fromPoint];
                break;
            case SYBackgroundAnimationDirectionShrink:
                [self sy_shrinkColro:backgroundColor duration:duration fromPotin:fromPoint];
                break;
        }
        return true;
    } else {
        return false;
    }
}

- (void)sy_shrinkColro:(UIColor *)newColor duration:(CGFloat)duration fromPotin:(CGPoint)fromPoint {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self getAnimatonLayer];
    shapeLayer.fillColor = self.backgroundColor.CGColor;
    
    // set animation completion call back
    [CATransaction setCompletionBlock:^{
        [__SY_AnimationShapeLayer removeFromSuperlayer];
        __SY_AnimationShapeLayer = nil;
        __SY_Animating = false;
        self.clipsToBounds = __SY_OriginClip;
    }];
    
    // init fromValue
    CGPoint center = [self adjustFromPoint:fromPoint];
    UIBezierPath *originPath = [UIBezierPath bezierPathWithArcCenter:center radius:[self raduisWithPoint:center] startAngle:SY_Angle(0) endAngle:SY_Angle(360) clockwise:true];
    shapeLayer.path = originPath.CGPath;
    
    self.backgroundColor = newColor;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
    animation.duration = duration;
    animation.toValue = (__bridge id)[UIBezierPath bezierPathWithArcCenter:center radius:1.0 startAngle:SY_Angle(0) endAngle:SY_Angle(360) clockwise:true].CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeOut"];
    animation.removedOnCompletion = false;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:@""];
}

- (void)sy_diffuseColro:(UIColor *)newColor duration:(CGFloat)duration fromPotin:(CGPoint)fromPoint {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)[self getAnimatonLayer];
    shapeLayer.fillColor = newColor.CGColor;
    
    // set animation completion call back
    [CATransaction setCompletionBlock:^{
        self.backgroundColor = [UIColor colorWithCGColor:__SY_AnimationShapeLayer.fillColor];
        [__SY_AnimationShapeLayer removeFromSuperlayer];
        __SY_AnimationShapeLayer = nil;
        __SY_Animating = false;
        self.clipsToBounds = __SY_OriginClip;
    }];
    
    // init fromValue
    CGPoint center = [self adjustFromPoint:fromPoint];
    UIBezierPath *originPath = [UIBezierPath bezierPathWithArcCenter:center radius:1.0 startAngle:SY_Angle(0) endAngle:SY_Angle(360) clockwise:true];
    shapeLayer.path = originPath.CGPath;
    UIBezierPath *newPath = [UIBezierPath bezierPathWithArcCenter:center radius:[self raduisWithPoint:center] startAngle:SY_Angle(0) endAngle:SY_Angle(360) clockwise:true];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
    animation.duration = duration;
    animation.toValue = (__bridge id)newPath.CGPath;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeIn"];
    animation.removedOnCompletion = false;
    animation.fillMode = kCAFillModeForwards;
    [shapeLayer addAnimation:animation forKey:@""];
}

- (CGPoint)adjustFromPoint:(CGPoint)fromPoint {
    fromPoint = CGPointEqualToPoint(fromPoint, CGPointZero) ? CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0) : fromPoint;
    return fromPoint;
}

- (CGFloat)raduisWithPoint:(CGPoint)fromPoint {
    
    CGFloat leftTopDistance = sqrt(pow(fromPoint.x, 2) + pow(fromPoint.y, 2));
    CGFloat rightTopDistance = sqrt(pow(self.frame.size.width - fromPoint.x, 2) + pow(fromPoint.y, 2));
    CGFloat leftBttomDistance = sqrt(pow(fromPoint.x, 2) + pow(self.frame.size.height - fromPoint.y, 2));
    CGFloat rightBttomDistance = sqrt(pow(self.frame.size.width - fromPoint.x, 2) + pow(self.frame.size.height - fromPoint.y, 2));
    
    CGFloat largerRight = MAX(rightTopDistance, rightBttomDistance);
    CGFloat largerleft = MAX(leftTopDistance, leftBttomDistance);
    return MAX(largerRight, largerleft);
}

#pragma mark - Properties



@end
