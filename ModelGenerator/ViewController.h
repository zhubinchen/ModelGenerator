//
//  ViewController.h
//  ModelGenerator
//
//  Created by zhubch on 15/8/11.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (unsafe_unretained) IBOutlet NSTextView *codeTextView;

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;

- (IBAction)generate:(id)sender;

@end

