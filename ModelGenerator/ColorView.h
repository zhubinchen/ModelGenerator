//
//  ColorView.h
//  MarkLite
//
//  Created by zhubch on 12/1/15.
//  Copyright © 2015 zhubch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorView : NSView

@property (nonatomic,strong) IBInspectable NSColor *backgroundColor;

@property (nonatomic,strong) NSString *title;

@property (nonatomic,assign) CGFloat cornorRadius;

@end
