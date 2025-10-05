//
// Created by luowei on 15/6/10.
// Copyright (c) 2015 luosai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PersonalSignViewController : UIViewController

@property(nonatomic, copy) NSString *personalSign;
@property(nonatomic, copy) void (^updateSignBlock)(NSString *);

@end