//
//  AppDelegate.m
//  MyAwareness
//
//  Created by luowei on 15/6/10.
//  Copyright (c) 2015年 luosai. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SettingViewController.h"
#import "ListViewController.h"

@interface AppDelegate ()<UITabBarControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;

//    ViewController *viewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
    ListViewController *viewController = [ListViewController new];
    viewController.title = @"我的感悟";
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:10];

    SettingViewController *settingController = [SettingViewController new];
    settingController.title = @"设置";
    settingController.view.backgroundColor = [UIColor lightGrayColor];
    settingController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:11];

    UINavigationController *myNavController = [[UINavigationController alloc] initWithRootViewController:viewController];
    UINavigationController *settingNavController = [[UINavigationController alloc] initWithRootViewController:settingController];


    self.tabBarController.viewControllers = @[myNavController,settingNavController];
    self.window.rootViewController = self.tabBarController;

    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark UITabbarControllerDelegate Implements

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

    //给TabBar设置过渡动画
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
}

@end
