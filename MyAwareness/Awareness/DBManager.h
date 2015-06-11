//
//  DBManager.h
//  MyAwareness
//
//  Created by luowei on 15/6/11.
//  Copyright (c) 2015 luosai. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "Defines.h"

@class Summary;

@interface DBManager : NSObject

singleton_interface(DBManager)

- (BOOL)createTable;

- (BOOL)insertContent:(NSString *)content;

- (BOOL)updateContent:(NSString *)content byId:(NSNumber *)_id;

- (Summary *)findById:(NSNumber *)_id;

- (NSArray *)listContent;

- (BOOL)clearAll;

- (NSArray *)findByContent:(NSString *)awareness;
@end
