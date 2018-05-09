//
//  UIView+SYBackgroundColor.h
//  SYBackgroundColor
//
//  Created by SunYang on 2017/12/24.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SYBackgroundAnimationDirection) {
    SYBackgroundAnimationDirectionDiffuse = 0,
    SYBackgroundAnimationDirectionShrink = 1
};

@interface UIView (SYBackgroundColor)

- (CALayer *)getAnimatonLayer;


/**
 set background image with animation
 not finish yet

 @param image image
 */
- (void)setSYBackgroundImage:(UIImage *)image;

- (BOOL)setSYBackgroundColor:(UIColor *)backgroundColor;

- (BOOL)setSYBackgroundColor:(UIColor *)backgroundColor
                   direction:(SYBackgroundAnimationDirection)direction;

- (BOOL)setSYBackgroundColor:(UIColor *)backgroundColor
                    duration:(CGFloat)duration
                   direction:(SYBackgroundAnimationDirection)direction
                   fromPoint:(CGPoint)fromPoint;

@end
