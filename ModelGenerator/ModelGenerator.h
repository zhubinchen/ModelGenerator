//
//  ModelGenerator.h
//  daizi
//
//  Created by zhubch on 15/8/10.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ObjectiveC,
    Swift,
    Java,
    CPP,
} Language;

@interface ModelGenerator : NSObject

@property (nonatomic,assign) Language language;

@property (nonatomic,strong) NSString *className;

+ (instancetype)sharedGenerator;

- (NSString*)generateModelFromDictionary:(NSDictionary*)dic withBlock:(NSString*(^)(id unresolvedObject))block;

@end
