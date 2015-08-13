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
#define kObjcPropertyFormat @"\n@property (nonatomic,strong) %@ *%@;\n"

#define kSwiftClassFormat @"class %@: NSObject {\n%@\n}"
#define kSwiftPropertyFormat @"\n\tvar %@: %@?\n"

#define kJavaClassFormat @"public class %@ {\n%@%@\n}"
#define kJavaPropertyFormat @"\n\tprivate %@ %@;\n"
#define kJavaGetterFormat @"\n\tpublic %@ get%@(){\n\t\treturn %@;\n\t}\n"
#define kJavaSetterFormat @"\n\tpublic void set%@(%@ %@){\n\t\tthis.%@ = %@;\n\t}\n"

#define kCppClassFormat @"class %@ {\n\npublic:\n%@\npublic:\n\t%@(void);\n\n\t~%@();\n}"
#define kCppPropertyFormat @"\n\t %@ %@;\n"

//class AppDelegate: UIResponder, UIApplicationDelegate {
//    
//    var window: UIWindow?
//#define kJavaGetterFormat @"\n\tpublic %@ get%@(){\n\t\treturn %@;\n\t}\n"
//#define kJavaSetterFormat @"\n\tpublic void set%@(%@ %@){\n\t\tthis.%@ = %@;\n\t}\n"
//class DemoObserver : public VisageTrackerObserver {
//public:
//    
//    id trackerDelegate;
//    
//    /**
//     * Constructor
//     *
//     */
//    DemoObserver(void);
//    ~
//    
//    /**
//     * Memeber variable that counts how many time Notify() function was called.
//     */
//    int notifyCount;
//    
//    /**
//     * Member variable that serves for getting the tracking results.
//     */
//    FaceData data;
//    
//    /**
//     * Implementation of a virtual function from VisageTrackerObserver.
//     *
//     * This function is called by VisageTracker2 during tracking
//     * whenever a new video frame is processed.
//     *
//     * In this implementation it gets the tracking data and status and displays them in the debug console.
//     */
//    void Notify(VisageTracker2 *vt, long timeStamp);
//    
//    float DistanceOf(FeaturePoint p1,FeaturePoint p2);
//    
//};
#endif
