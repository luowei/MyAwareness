//
//  AwarenessViewController.h
//  MyAwareness
//
//  Created by luowei on 15/6/11.
//  Copyright (c) 2015 luosai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AwarenessViewController : UIViewController

@property(nonatomic, copy) void (^updateAwarenessItemBlock)(NSString *);
@property(nonatomic, copy) NSString *awareness;
@end
