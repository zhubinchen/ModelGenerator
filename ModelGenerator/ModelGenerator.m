//
//  ModelGenerator.m
//  daizi
//
//  Created by zhubch on 15/8/10.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import "ModelGenerator.h"
#import "Template.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>

static ModelGenerator *generator = nil;

@interface ModelGenerator ()

@property (nonatomic,strong) NSMutableArray *properties;

@property (nonatomic,copy) NSString*(^block)(id unResolvedObject) ;

@end


@implementation ModelGenerator

+ (instancetype)sharedGenerator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[ModelGenerator alloc]init];
        generator.language = ObjectiveC;
    });
    return generator;
}

- (NSString*)completeCode
{
    NSMutableString *code = [NSMutableString string];
    switch (_language) {
        case ObjectiveC:
        {
            NSMutableString *propertyDefins = [NSMutableString string];
            
            for (NSDictionary *dic in _properties) {
                [propertyDefins appendFormat:kObjcPropertyFormat,dic[@"type"],dic[@"name"]];
            }
            
            code = [NSMutableString stringWithFormat:kObjcClassFormat,_className,propertyDefins];
            break;
        }
            
        case Swift:
        {
            NSMutableString *propertyDefins = [NSMutableString string];
            
            for (NSDictionary *dic in _properties) {
                [propertyDefins appendFormat:kSwiftPropertyFormat,dic[@"name"],dic[@"type"]];
            }
            
            code = [NSMutableString stringWithFormat:kSwiftClassFormat,_className,propertyDefins];
            break;
        }
            
        case Java:
        {
            NSMutableString *propertyDefins = [NSMutableString string];
            
            NSMutableString *setterGetters = [NSMutableString string];
            
            for (NSDictionary *dic in _properties) {
                [propertyDefins appendFormat:kJavaPropertyFormat,dic[@"type"],dic[@"name"]];
                [setterGetters appendFormat:kJavaGetterFormat,dic[@"type"],[self upcaseFirstChar:dic[@"name"]],dic[@"name"]];
                [setterGetters appendFormat:kJavaSetterFormat,[self upcaseFirstChar:dic[@"name"]],dic[@"type"],dic[@"name"],dic[@"name"],dic[@"name"]];
            }
            
            code = [NSMutableString stringWithFormat:kJavaClassFormat,_className,propertyDefins,setterGetters];
            break;
        }
            
        case CPP:
        {
            NSMutableString *propertyDefins = [NSMutableString string];
                        
            for (NSDictionary *dic in _properties) {
                [propertyDefins appendFormat:kCppPropertyFormat,dic[@"type"],dic[@"name"]];
            }
            
            code = [NSMutableString stringWithFormat:kCppClassFormat,_className,propertyDefins,_className,_className];
            
            break;
        }
            
        default:
            break;
    }
    
    return code;
}

- (NSString*)nameOfType:(NSInteger)type InLanguage:(Language)language
{
    switch (language) {
        case ObjectiveC:
            return type ? @"NSNumber" : @"NSString";
            break;
        case Swift:
            return type ? @"NSNumber" : @"NSString";
            break;
        case Java:
            return type ? @"Int" : @"String";
            break;
        case CPP:
            return type ? @"int" : @"std::string";
        default:
            return @"unknow";
    }
}

/**
 *  解析类型
 *
 *  @param obj 要解析的对象
 *
 *  @return 0:字符串 1:数字 2:其它类型
 */
- (NSInteger)resolveClassOfObjet:(id)obj
{
    if(obj == nil){
        return 0;
    }
    Class clazz = [obj class];
    NSString *name = NSStringFromClass(clazz);
    
    if ([name isEqualToString:@"__NSCFConstantString"]||[name isEqualToString:@"NSString"] || [name isEqualToString:@"__NSCFString"]) {
        return 0;
    }else if ([name isEqualToString:@"__NSCFNumber"] || [name isEqualToString:@"NSNumber"]) {
        return 1;
    }else if ([name isEqualToString:@"NSDictionary"] || [name isEqualToString:@"__NSCFDictionary"]){
        return 2;
    }
    
    Class superClazz = class_getSuperclass(clazz);
    if (!strcmp(class_getName(clazz), "NSObject")) {
        return 0;
    }
    return [self resolveClassOfObjet:superClazz];
}

- (NSString*)upcaseFirstChar:(NSString*)originStr
{
    const char * srcChar = [originStr cStringUsingEncoding:NSUTF8StringEncoding];
    
    char *destChar = malloc(strlen(srcChar) * sizeof(char));
    
    int n = 0;
    for (int i = 0; i < originStr.length; i++) {
        if(srcChar[i] >= 97 && srcChar[i] <= 122 && i == 0) {
            destChar[n] = srcChar[i] - 32;
            n++;
        }else {
            destChar[n] = srcChar[i];
            n++;
        }
        
    }
    
    destChar[n] = '\0';
    NSString *destStr = [[NSString alloc]initWithUTF8String:destChar];
    
    return destStr;
}

- (NSString *)generateModelFromDictionary:(NSDictionary *)dic withBlock:(NSString* (^)(id))block
{
    _block = block;

    self.properties = [[NSMutableArray alloc]init];
    
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSInteger type = [self resolveClassOfObjet:obj];
        
        NSString *propertyType;
        if (type == 2) {
            propertyType = generator.block(obj);
        }else {
            propertyType = [self nameOfType:type InLanguage:generator.language];
        }
        
        NSString *propertyName = key;
        
        [_properties addObject:@{@"type":propertyType,@"name":propertyName}];
    }];
    
    return [self completeCode];
}

@end
