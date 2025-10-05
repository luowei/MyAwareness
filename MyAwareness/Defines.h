//
//  Defines.h
//  MyAwareness
//
//  Created by luowei on 15/6/11.
//  Copyright (c) 2015 luosai. All rights reserved.
//

#ifndef MyAwareness_Defines____FILEEXTENSION___
#define MyAwareness_Defines____FILEEXTENSION___

#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define PERSONALSIGN_KEY @"PersonalSign"
#define TABLENAME_SUMMARY @"summary.sqlite"
#define TABLECREATED_KEY @"TableCreated_Key"

#define ADD_AWARENESS @"添加感悟"
#define EDIT_AWARENESS @"编辑感悟"

#define WEAKSELF typeof(self) __weak weakSelf = self;

#define PATH_OF_DOCUMENT NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define PATH_OF_DB [PATH_OF_DOCUMENT stringByAppendingPathComponent:TABLENAME_SUMMARY]




// @interface
#define singleton_interface(className) \
+ (className *)shared##className;


// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone]; \
    }); \
    return _instance; \
} \
+ (className *)shared##className \
{ \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        _instance = [[self alloc] init]; \
    }); \
    return _instance; \
}


#endif
