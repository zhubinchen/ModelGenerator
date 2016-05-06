//
//  ColorView.m
//  MarkLite
//
//  Created by zhubch on 12/1/15.
//  Copyright © 2015 zhubch. All rights reserved.
//

#import "ColorView.h"

@implementation ColorView

- (void)setBackgroundColor:(NSColor *)color
{
    _backgroundColor = color;
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSColor *color = _backgroundColor;
    [color set];
    
    const CGFloat radius = _cornorRadius;
    NSRect bounds = self.bounds;
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:NSMakePoint(NSMinX(bounds), NSMinY(bounds))];
    [path appendBezierPathWithArcFromPoint:NSMakePoint(NSMinX(bounds), NSMaxY(bounds))
                                   toPoint:NSMakePoint(NSMinX(bounds)+radius, NSMaxY(bounds))
                                    radius:radius];
    [path appendBezierPathWithArcFromPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds))
                                   toPoint:NSMakePoint(NSMaxX(bounds), NSMaxY(bounds)-radius)
                                    radius:radius];
    [path lineToPoint:NSMakePoint(NSMaxX(bounds), NSMinY(bounds))];
    [path closePath];
    [path fill];
    
    if (_title.length == 0) {
        return;
    }
    NSColor *textColor = nil;
    if ([self.window isKeyWindow])
        textColor = [NSColor whiteColor];
    else
        textColor = [NSColor whiteColor];
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:self.window.title
                                                                attributes:@{NSFontAttributeName: [NSFont labelFontOfSize:18.0],
                                                                             NSForegroundColorAttributeName: textColor}];
    
    [title drawAtPoint:NSMakePoint(NSMidX(bounds)-title.size.width/2, NSMidY(bounds)-title.size.height/2)];
}

@end
