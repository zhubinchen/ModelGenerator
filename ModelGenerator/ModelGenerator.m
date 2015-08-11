//
//  ModelGenerator.m
//  daizi
//
//  Created by zhubch on 15/8/10.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import "ModelGenerator.h"
#import <objc/runtime.h>

#define kCodeFormat @"@property (nonatomic,strong) %@ *%@;\n"

static ModelGenerator *generator = nil;

@interface ModelGenerator ()

@property (nonatomic,strong) NSMutableString *code;

@end

@interface NSObject (ModelGenerator)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

@implementation NSObject (ModelGenerator)

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSString *propertyClass = [self convertClassName:[value class]];

    NSString *propertyName = key;
    NSString *fullPropertyDefine = [NSString stringWithFormat:kCodeFormat,propertyClass,propertyName];
    [generator.code appendString:fullPropertyDefine];
}

- (NSString*)convertClassName:(Class)clazz
{
    NSString *name = NSStringFromClass(clazz);
    if ([name isEqualToString:@"__NSCFConstantString"]||[name isEqualToString:@"NSString"] || [name isEqualToString:@"__NSCFConstantString"]) {
        return @"NSString";
    }else if ([name isEqualToString:@"__NSCFNumber"] || [name isEqualToString:@"NSNumber"]) {
        return @"NSNumber";
    }
    
    Class superClazz = class_getSuperclass(clazz);
    if (!strcmp(class_getName(clazz), "NSObject")) {
        return name;
    }
    return [self convertClassName:superClazz];
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

- (NSString *)generateModelFromDictionary:(NSDictionary *)dic
{
    self.code = [NSMutableString string];
    NSObject *obj = [[NSObject alloc]init];
    [obj setValuesForKeysWithDictionary:dic];
    return self.code;
}

@end
