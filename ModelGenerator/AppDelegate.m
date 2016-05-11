//
//  AppDelegate.m
//  ModelGenerator
//
//  Created by zhubch on 15/8/11.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import "AppDelegate.h"

static NSMutableArray *windows = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSTimer *timer;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkWindow) userInfo:nil repeats:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)applicationWillBecomeActive:(NSNotification *)notification
{
}

- (IBAction)newDocument:(id)sender
{
    NSWindowController *newWin = [[NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateInitialController];
    [newWin showWindow:self];
    
    if (windows == nil) {
        windows = [NSMutableArray array];
    }
    
    [windows addObject:newWin]; //以免自己被释放
}

- (void)checkWindow
{
    for (NSWindowController *win in windows) {
        NSLog(@"%@",win.window);
    }
}

@end
