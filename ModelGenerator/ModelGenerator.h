//
//  ModelGenerator.h
//  daizi
//
//  Created by zhubch on 15/8/10.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelGenerator : NSObject

+ (instancetype)sharedGenerator;

- (NSString*)generateModelFromDictionary:(NSDictionary*)dic;

@end
