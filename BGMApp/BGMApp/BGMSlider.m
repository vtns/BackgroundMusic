//
//  BGMSlider.m
//  Background Music
//
//  Created by koyama on 2021/06/15.
//  Copyright © 2021 Background Music contributors. All rights reserved.
//

#import "BGMSlider.h"

@interface BGMSliderLayer : CALayer
@end

@implementation BGMSliderLayer : CALayer

- (void)setMasksToBounds:(BOOL)val {
}

- (BOOL)asksToBounds {
    return NO;
}

@end


@implementation BGMSlider

- (BOOL)wantsDefaultClipping {
    return NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.wantsLayer = YES;
    self.layer = [BGMSliderLayer new];
}

@end

@implementation BGMSliderCell

- (void)drawKnob:(NSRect)knobRect {
    [[NSColor textColor] set];
    CGContextRef ctx;
    if (@available(macOS 10.10, *)) {
        ctx = [NSGraphicsContext currentContext].CGContext;
    } else {
        // Fallback on earlier versions
        ctx = [[NSGraphicsContext currentContext] graphicsPort];
    }
    CGContextAddEllipseInRect(ctx, knobRect);
    CGContextFillPath(ctx);
//    NSRectFill(knobRect);
}

- (NSRect)knobRectFlipped:(BOOL)flipped
{
    NSRect defaultRect = [super knobRectFlipped:flipped];
    NSSlider* theSlider = (NSSlider*) [self controlView];
    NSRect myBounds = [theSlider bounds];
    CGFloat knobDiag = round(CGRectGetHeight(myBounds)/2);
    NSSize knobSize = CGSizeMake(knobDiag, knobDiag);
    CGFloat travelLength = myBounds.size.width - knobSize.width;
    double valueFrac = ([theSlider doubleValue] - [theSlider minValue]) /
        ([theSlider maxValue] - [theSlider minValue]);
    CGFloat knobLeft = round( valueFrac * travelLength );
    CGFloat defaultCenterY = CGRectGetMidY(defaultRect);
    CGFloat knobMinY = round( defaultCenterY - 0.5 * knobSize.height );
    NSRect knobRect = NSMakeRect( knobLeft, knobMinY,
        knobSize.width, knobSize.height );

    if (knobSize.height > 9)
        knobRect = CGRectOffset(knobRect, 0, -2);
    
    return knobRect;
}

@end
