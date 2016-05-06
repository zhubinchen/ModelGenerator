//
//  Window.m
//  MarkLite
//
//  Created by zhubch on 12/1/15.
//  Copyright © 2015 zhubch. All rights reserved.
//

#import "Window.h"
#import "ColorView.h"

@interface Window ()
{
    ColorView *headerView;
}

@end

@implementation Window

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    if (self)
    {
        self.titleVisibility = NSWindowTitleHidden;
        headerView = [[ColorView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(self.frame), 22)];
        headerView.autoresizingMask = NSViewMinYMargin|NSViewWidthSizable;
        
        NSView *containerView = nil;
        
#ifdef __MAC_10_10
        //Yosemite and later
        if (rint(NSAppKitVersionNumber) > NSAppKitVersionNumber10_9)
        {
            self.titlebarAppearsTransparent = YES;
            NSView *themeView = [[self contentView] superview];
            NSArray *subViews = [themeView subviews];
            for (NSView *subView in subViews)
            {
                if (subView != [self contentView])
                {
                    containerView = subView;
                    break;
                }
            }
        }else
#endif
            //Mavericks and lower
        {
            NSRect frame = headerView.frame;
            frame.origin.y = NSHeight(self.frame)-NSHeight(frame);
            headerView.frame = frame;
            
            containerView = [[self contentView] superview];
        }
        
        [containerView addSubview:headerView positioned:NSWindowBelow relativeTo:nil];
        
        [self setOpaque:YES];
        [self setBackgroundColor:[NSColor colorWithRed:10/255.0 green:142/255.0 blue:237/255.0 alpha:1]];
        [self setMovableByWindowBackground:YES];
    }
    return self;
}


- (void)setBackgroundColor:(NSColor *)color
{
    [headerView setBackgroundColor:color];
    [super setBackgroundColor:color];
}

- (void)setTitle:(NSString *)aString
{
    [super setTitle:aString];
    headerView.title = aString;
    [headerView setNeedsDisplay:YES];
}

@end
