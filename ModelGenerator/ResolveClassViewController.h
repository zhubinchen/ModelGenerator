//
//  ResolveClassViewController.h
//  ModelGenerator
//
//  Created by zhubch on 15/8/12.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ResolveClassViewControllerDelegate <NSObject>

- (void)didResolvedWithClassName:(NSString*)name;

@end

@interface ResolveClassViewController : NSViewController

@property (nonatomic,weak) id<ResolveClassViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *strToResolve;

@property (unsafe_unretained) IBOutlet NSTextView *textView;

@property (weak) IBOutlet NSTextField *classTextField;

- (IBAction)resolve:(id)sender;

@end
