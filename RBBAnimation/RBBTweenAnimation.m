//
//  RBBTweenAnimation.m
//  RBBAnimation
//
//  Created by Robert Böhnke on 10/13/13.
//  Copyright (c) 2013 Robert Böhnke. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RBBTweenAnimation.h"

RBBEasingFunction const RBBEasingFunctionLinear = ^(CGFloat fraction) {
    return fraction;
};

@implementation RBBTweenAnimation

+ (id)tweenWithKeyPath:(NSString *)keyPath from:(NSValue *)from to:(NSValue *)to block:(RBBEasingFunction)easingFunction {
    NSParameterAssert(strcmp(from.objCType, to.objCType) == 0);

    RBBAnimationBlock block;

    if (strcmp(from.objCType, @encode(CGRect)) == 0) {
        return [self tweenWithKeyPath:keyPath fromCGRect:[from CGRectValue] toCGRect:[to CGRectValue] block:easingFunction];
    }

    if ([from isKindOfClass:NSNumber.class]) {
        return [self tweenWithKeyPath:keyPath fromCGFloat:[(NSNumber *) from floatValue] toCGFloat:[(NSNumber *) to floatValue] block:easingFunction];
    }

    NSAssert(block != nil, @"Unsupported value type: %s", from.objCType);
    return nil;
}

+ (id)tweenWithKeyPath:(NSString *)keyPath fromCGRect:(CGRect)from toCGRect:(CGRect)to block:(RBBEasingFunction)easingFunction {
    CGFloat deltaX = to.origin.x - from.origin.x;
    CGFloat deltaY = to.origin.y - from.origin.y;
    CGFloat deltaWidth = to.size.width - from.size.width;
    CGFloat deltaHeight = to.size.height - from.size.height;

    RBBAnimationBlock block = ^(CGFloat fraction) {
        CGFloat scaleFactor = easingFunction(fraction);

        CGRect rect = {
            .origin.x = from.origin.x + scaleFactor * deltaX,
            .origin.y = from.origin.y + scaleFactor * deltaY,
            .size.width = from.size.width + scaleFactor * deltaWidth,
            .size.height = from.size.height + scaleFactor * deltaHeight
        };

        return [NSValue valueWithCGRect:rect];
    };

    return [self animationWithKeyPath:keyPath block:block];
}

+ (id)tweenWithKeyPath:(NSString *)keyPath fromCGFloat:(CGFloat)from toCGFloat:(CGFloat)to block:(RBBEasingFunction)easingFunction {
    CGFloat delta = to - from;

    RBBAnimationBlock block = ^(CGFloat fraction) {
        return @(from + easingFunction(fraction) * delta);
    };

    return [self animationWithKeyPath:keyPath block:block];
}

@end