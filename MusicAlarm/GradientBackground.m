//
//  GradientBackground.m
//  QuantumDemo
//
//  Created by Phillip Pasqual on 11/17/15.
//  Copyright © 2015 Misfit. All rights reserved.
//

#import "GradientBackground.h"
#import <UIKit/UIKit.h>

@implementation GradientBackground

+ (CAGradientLayer*) purpleGradient {
    
    UIColor *colorOne = [UIColor colorWithRed:(101/255.0)  green:(78/255.0)  blue:(129/255.0)  alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithRed:(90/255.0) green:(53/255.0) blue:(139/255.0) alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.startPoint = CGPointMake(0.0, 1.0);
    headerLayer.endPoint = CGPointMake(1.0,0.0);
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}

@end