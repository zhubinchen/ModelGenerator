//
//  ViewController.m
//  ModelGenerator
//
//  Created by zhubch on 15/8/11.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import "ViewController.h"
#import "ModelGenerator.h"
#import "ResolveClassViewController.h"

@interface ViewController ()<ResolveClassViewControllerDelegate,NSComboBoxDataSource>

@end

@implementation ViewController
{
    ModelGenerator *generater;
    id objectToResolve;
    NSString *result;
    NSArray *languageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferredContentSize = CGSizeMake(700, 400);
    generater = [ModelGenerator sharedGenerator];
    
    languageArray = @[@"Objective-C",@"Swift",@"Java",@"C++"];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

- (IBAction)generate:(id)sender {
    NSLog(@"%@",_classNameField.stringValue);
    generater.className = _classNameField.stringValue;
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
    self.codeTextView.editable = YES;
    [self.codeTextView insertText:@"" replacementRange:NSMakeRange(0, self.codeTextView.textStorage.string.length)];
    
    dispatch_async(dispatch_queue_create("generate", DISPATCH_QUEUE_CONCURRENT), ^{
        NSString *code = [generater generateModelFromDictionary:dic withBlock:^NSString *(id unresolvedObject) {

            objectToResolve = unresolvedObject;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSegueWithIdentifier:@"showModal" sender:self];
            });
            result = nil;
            
            while (result == nil) {
                sleep(0.1);
            }
            return result;
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.codeTextView insertText:code replacementRange:NSMakeRange(0, 1)];
            self.codeTextView.editable = NO;
        });

    });
}

- (IBAction)selectedLanguage:(NSComboBox*)sender {
    generater.language = sender.indexOfSelectedItem;
}

- (void)prepareForSegue:(NSStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showModal"]) {
        ResolveClassViewController *vc = segue.destinationController;
        vc.objectToResolve = objectToResolve;
        vc.delegate = self;
    }
}

#pragma ResolveClassViewControllerDelegate

- (void)didResolvedWithClassName:(NSString *)name
{
    result = name;
}

#pragma NSComboBoxDelegate & NSComboBoxDataSource

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox
{
    return languageArray.count;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index
{
    return languageArray[index];
}

@end
