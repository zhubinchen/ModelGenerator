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

@property (nonatomic,strong) NSArray *objcTypeArray;
@property (nonatomic,strong) NSArray *swiftTypeArray;
@property (nonatomic,strong) NSArray *javaTypeArray;

@property (nonatomic,strong) NSMutableArray *properties;

@property (nonatomic,copy) NSString*(^block)(id unResolvedObject) ;

@end


@implementation ModelGenerator

+ (instancetype)sharedGenerator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        generator = [[ModelGenerator alloc]init];
        generator.language = Unknow;
        generator.objcTypeArray = @[@"NSString*",@"NSInteger",@"CGFloat",@"NSInteger",@"CGFloat",@"BOOL",@"NSArray*"];
        generator.swiftTypeArray = @[@"String",@"Int",@"Float",@"Double",@"Double",@"BOOL",@"NSArray"];
        generator.javaTypeArray = @[@"String",@"Int",@"Float",@"Double",@"Double",@"Boolean",@"ArrayList<Object>"];
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
                NSString *s = ([dic[@"type"] isEqualToString:@"NSInteger"] || [dic[@"type"] isEqualToString:@"CGFloat"]) ? @"assign" : @"strong";
                [propertyDefins appendFormat:kObjcPropertyFormat,s,dic[@"type"],dic[@"name"]];
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
            
        default:
            break;
    }
    
    return code;
}

- (NSString*)nameOfType:(NSInteger)type InLanguage:(Language)language
{
    switch (language) {
        case ObjectiveC:
            return _objcTypeArray[type];
            break;
        case Swift:
            return _swiftTypeArray[type];
            break;
        case Java:
            return _javaTypeArray[type];
            break;
        default:
            return @"unknow";
    }
    
}
/**
 *  解析类型
 *
 *  @param obj 要解析的对象
 *{"registPhone":"15652684654","area":{"county":"CHN","province":"Beijing","city":"Beijing","code":0},"serverSerialNo":3.14,"password":"zbc123456","nickName":"zhubch","phoneModel":"iPhone Simulator","registerTime":"null","updateTime":"null","phoneOs":"iPhone OS","osVersion":8.4,"serialNo":1,"authors": [{ "firstName": "Isaac", "lastName": "Asimov", "genre": "science fiction" },{ "firstName": "Tad", "lastName": "Williams", "genre": "fantasy" },{ "firstName": "Frank", "lastName": "Peretti", "genre": "christian fiction" }]}
 *  @return 0:字符串 1:整数 2:浮点 3:长整数 4:双精度 5:布尔 6:数组 7:其他
 */
- (NSInteger)resolveClassOfObjet:(id)obj
{
    if(obj == nil){
        return 0;
    }

    Class clazz = [obj class];
    NSString *name = NSStringFromClass(clazz);
//    NSLog(@"%@",name);
    if ([name isEqualToString:@"__NSCFConstantString"]||[name isEqualToString:@"NSString"] || [name isEqualToString:@"__NSCFString"]) {
        if ([obj respondsToSelector:@selector(isEqualToString:)] && ([obj isEqualToString:@"true"] || [obj isEqualToString:@"false"])) {
            return 5;
        }
        return 0;
    }else if ([name isEqualToString:@"__NSCFNumber"] || [name isEqualToString:@"NSNumber"]) {
        if (strcmp([obj objCType], @encode(float)) == 0)
        {
            return 2;
        }
        else if (strcmp([obj objCType], @encode(double)) == 0)
        {
            return 4;
        }
        else if (strcmp([obj objCType], @encode(int)) == 0)
        {
            return 1;
        } else if (strcmp([obj objCType], @encode(long)) == 0)
        {
            return 3;
        }
        return 1;
    }else if ([name isEqualToString:@"__NSArrayI"] || [name isEqualToString:@"NSArray"]){
        return 6;
    }else if ([name isEqualToString:@"NSDictionary"] || [name isEqualToString:@"__NSCFDictionary"]){
        return 7;
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
        if (type == 7) {
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
