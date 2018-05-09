//
//  ViewController.m
//  SYBackgroundColor
//
//  Created by SunYang on 2017/12/24.
//  Copyright © 2017年 SunYang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+SYBackgroundColor.h"

#define SY_Angle(x) M_PI/180.0*x

@interface ViewController ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIView *testView;
@end

@implementation ViewController {
    BOOL _flag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _flag = true;
    self.testView.layer.borderColor = [UIColor blackColor].CGColor;
    self.testView.layer.borderWidth = 1.0;
}

- (UIColor *)randomColor {
    CGFloat red = arc4random()%256 / 255.0;
    CGFloat green = arc4random()%256 / 255.0;
    CGFloat blue = arc4random()%256 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void)diffuseColor:(CGPoint)fromPoint {
    if ([self.testView setSYBackgroundColor:[self randomColor]
                                   duration:0.25
                                  direction: SYBackgroundAnimationDirectionDiffuse
                                  fromPoint:fromPoint]) {
        _flag = !_flag;
    }
}

- (void)shrinkColor:(CGPoint)fromPoint {
    if ([self.testView setSYBackgroundColor:[UIColor whiteColor]
                                   duration:0.25
                                  direction: SYBackgroundAnimationDirectionShrink
                                  fromPoint:fromPoint]) {
        _flag = !_flag;
    }
}

- (IBAction)tapView:(UITapGestureRecognizer *)sender {
    if (_flag) {
        [self diffuseColor:[sender locationInView:self.testView]];
    } else {
        [self shrinkColor:[sender locationInView:self.testView]];
    }
}

@end
