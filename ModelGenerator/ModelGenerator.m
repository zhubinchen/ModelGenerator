//
//  ModelGenerator.m
//  daizi
//
//  Created by zhubch on 15/8/10.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import "ModelGenerator.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>

#define kCodeFormat @"@property (nonatomic,strong) %@ *%@;\n"

static ModelGenerator *generator = nil;

@interface ModelGenerator ()

@property (nonatomic,strong) NSMutableAttributedString *code;

@property (nonatomic,copy) NSString*(^block)(id unResolvedObject) ;

@end

@interface NSObject (ModelGenerator)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

@implementation NSObject (ModelGenerator)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSString *propertyClass = [self resolveClassOfObjet:value];
    
//    if ([value respondsToSelector:@selector(integerValue)] && ([value integerValue] != 0 || [value isEqualToString:@"0"])) {
//        propertyClass = @"NSNumber";    
//    }
    NSString *propertyName = key;
    NSMutableAttributedString *fullPropertyDefine = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:kCodeFormat,propertyClass,propertyName]];
    
    NSRange typeRange = [fullPropertyDefine.string rangeOfString:propertyClass];
    
    NSColor *pinkColor = [NSColor colorWithRed:200/255.0 green:30/255.0 blue:160.0/255.0 alpha:1];
    [fullPropertyDefine addAttribute:NSForegroundColorAttributeName value:pinkColor range:NSMakeRange(0, 9)];
    [fullPropertyDefine addAttribute:NSForegroundColorAttributeName value:pinkColor range:NSMakeRange(11, 9)];
    [fullPropertyDefine addAttribute:NSForegroundColorAttributeName value:pinkColor range:NSMakeRange(21, 6)];
    
    [fullPropertyDefine addAttribute:NSForegroundColorAttributeName value:[NSColor colorWithCalibratedRed:91/255.0 green:38/255.0 blue:153/255.0 alpha:1] range:typeRange];
    [generator.code appendAttributedString:fullPropertyDefine];
}

- (NSString*)resolveClassOfObjet:(id)obj
{
    if(obj == nil){
        return @"NSString";
    }
    Class clazz = [obj class];
    NSString *name = NSStringFromClass(clazz);

    if ([name isEqualToString:@"__NSCFConstantString"]||[name isEqualToString:@"NSString"] || [name isEqualToString:@"__NSCFString"]) {
        return @"NSString";
    }else if ([name isEqualToString:@"__NSCFNumber"] || [name isEqualToString:@"NSNumber"]) {
        return @"NSNumber";
    }else if ([name isEqualToString:@"NSDictionary"] || [name isEqualToString:@"__NSCFDictionary"]){
        if (generator.block) {
            return generator.block(obj);
        }
    }
    
    Class superClazz = class_getSuperclass(clazz);
    if (!strcmp(class_getName(clazz), "NSObject")) {
        return name;
    }
    return [self resolveClassOfObjet:superClazz];
}

@end


@implementation ModelGenerator

+ (instancetype)sharedGenerator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[ModelGenerator alloc]init];
    });
    return generator;
}

- (NSAttributedString *)generateModelFromDictionary:(NSDictionary *)dic
{
    self.code = [[NSMutableAttributedString alloc]init];
    NSObject *obj = [[NSObject alloc]init];
    [obj setValuesForKeysWithDictionary:dic];
    return self.code;
}

- (NSAttributedString *)generateModelFromDictionary:(NSDictionary *)dic withBlock:(NSString* (^)(id))block
{
    _block = block;
    return [self generateModelFromDictionary:dic];
}

@end
