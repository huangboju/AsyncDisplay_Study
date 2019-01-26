//
//  GradientLineNode.m
//  AsyncDisplay
//
//  Created by 伯驹 黄 on 2017/5/11.
//  Copyright © 2017年 伯驹 黄. All rights reserved.
//

#import "GradientLineNode.h"

@implementation GradientLineNode
+ (void)drawRect:(CGRect)bounds withParameters:(id<NSObject>)parameters
     isCancelled:(__attribute__((noescape)) asdisplaynode_iscancelled_block_t)isCancelledBlock isRasterizing:(BOOL)isRasterizing {
    CGContextRef myContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(myContext);
    CGContextClipToRect(myContext, bounds);
    
    NSInteger componentCount = 3;

    CGFloat locations[3] = {0.2, 0.5, 0.8};
    CGFloat components[] = {
        0, 0, 0, 0,
        0, 0, 0, 0.2,
        0, 0, 0, 0,
    };

    CGColorSpaceRef myColorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorSpace, components, locations, componentCount);

    CGPoint myStartPoint = CGPointZero;
    CGPoint myEndPoint = CGPointMake(0, bounds.size.height);

    CGContextDrawLinearGradient(myContext, myGradient, myStartPoint, myEndPoint, kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(myContext);
}
@end
