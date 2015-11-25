//
//  Template.h
//  ModelGenerator
//
//  Created by zhubch on 15/8/13.
//  Copyright (c) 2015年 zhubch. All rights reserved.
//

#ifndef ModelGenerator_Template_h
#define ModelGenerator_Template_h

#define kObjcClassFormat @"@interface %@ : NSObject\n%@\n@end"
#define kObjcPropertyFormat @"\n@property (nonatomic,%@) %@ %@;\n"

#define kSwiftClassFormat @"class %@ {\n%@\n}"
#define kSwiftPropertyFormat @"\n\tvar %@: %@?\n"

#define kJavaClassFormat @"public class %@ {\n%@%@\n}"
#define kJavaPropertyFormat @"\n\tprivate %@ %@;\n"
#define kJavaGetterFormat @"\n\tpublic %@ get%@(){\n\t\treturn %@;\n\t}\n"
#define kJavaSetterFormat @"\n\tpublic void set%@(%@ %@){\n\t\tthis.%@ = %@;\n\t}\n"

#endif
