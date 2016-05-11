//
//  ClassViewController.h
//  ModelGenerator
//
//  Created by zhubch on 15/8/12.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ClassViewControllerDelegate <NSObject>

- (void)didResolvedWithClassName:(NSString*)name;

@end

@interface ClassViewController : NSViewController

@property (nonatomic,weak) id<ClassViewControllerDelegate> delegate;

@property (nonatomic,strong) id objectToResolve;

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (weak) IBOutlet NSTextField *classTextField;

- (IBAction)resolve:(id)sender;

@end
