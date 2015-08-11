//
//  ViewController.m
//  ModelGenerator
//
//  Created by zhubch on 15/8/11.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import "ViewController.h"
#import "ModelGenerator.h"

@implementation ViewController
{
    ModelGenerator *generater;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    generater = [ModelGenerator sharedGenerator];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)generate:(id)sender {
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[_jsonTextView.textStorage.string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    if (error) {
        NSAlert *alert = [[NSAlert alloc]init];
        alert.messageText = error.localizedFailureReason;
        [alert addButtonWithTitle:@"好的"];
        alert.alertStyle = NSWarningAlertStyle;
        [alert runModal];
        return;
    }
    NSString *code = [generater generateModelFromDictionary:dic];
    [self.codeTextView insertText:code replacementRange:NSMakeRange(0, 1)];
}

@end
