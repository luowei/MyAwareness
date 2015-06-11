//
//  Summary.h
//  TabAndTable
//
//  Created by luowei on 15/6/10.
//  Copyright (c) 2015年 rootls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Summary : NSObject

@property NSNumber *sid;
@property NSString *content;
@property NSDate *createTime;


- (instancetype)initWithDictionary:(NSDictionary *)dic;
- (instancetype)initWithCreateAt:(NSDate *)createTime content:(NSString *)content id:(NSNumber *)_id;


@end
