//
//  ClassViewController.m
//  ModelGenerator
//
//  Created by zhubch on 15/8/12.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import "ClassViewController.h"

@implementation ClassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(250, 300);
    [self.textView insertText:[_objectToResolve description]];
}

- (IBAction)resolve:(id)sender {
    if (_classTextField.currentEditor.string.length) {
        [self.delegate didResolvedWithClassName:_classTextField.currentEditor.string];
        [self dismissViewController:self];
    }
}

@end
