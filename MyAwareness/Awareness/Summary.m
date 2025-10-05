//
//  Summary.m
//  TabAndTable
//
//  Created by luowei on 15/6/10.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import "Summary.h"

@implementation Summary

- (instancetype)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        self.content = dic[@"content"];
        self.createTime = dic[@"createTime"];
    }
    return self;
}

- (instancetype)initWithCreateAt:(NSDate *)createTime content:(NSString *)content id:(NSNumber *)_id{
    if (self = [super init]) {
        self.createTime = createTime;
        self.content = content;
        self._id = _id;
    }
    return self;
}

@end
