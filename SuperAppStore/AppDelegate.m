//
//  AppDelegate.m
//  SuperAppStore
//
//  Created by mac on 2018/3/16.
//  Copyright © 2018年 FlyYardAppStore. All rights reserved.
//

#import "AppDelegate.h"
#import "RDVTabBarController.h"

#import "MainPageViewController.h"//skill part main page
#import "IdeaMainViewController.h"
#import "AssetMainViewController.h"
#import "BlackHoleMainVc.h"
#import "TodayMainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIWindow *mainWindow = [[UIWindow alloc] initWithFrame:bounds];
    
    RDVTabBarController *rootVc = [self setupTabNavController];
    [mainWindow setRootViewController:rootVc];
    [mainWindow setBackgroundColor:[UIColor whiteColor]];
    [mainWindow makeKeyAndVisible];
    self.window = mainWindow;
    
    return YES;
}

- (RDVTabBarController *)setupTabNavController {
    RDVTabBarController *rootVc = [[RDVTabBarController alloc] init];
    
    //skill main page
    MainPageViewController *skillVc = [[MainPageViewController alloc] init];
    UINavigationController *skillNav = [[UINavigationController alloc] init];
    [skillNav pushViewController:skillVc animated:YES];
    
    //idea main page
    IdeaMainViewController *ideaVc = [[IdeaMainViewController alloc] init];
    UINavigationController *ideaNav = [[UINavigationController alloc] init];
    [ideaNav pushViewController:ideaVc animated:YES];
    
    //Asset main page secret attempt to add secret strategy
//    AssetMainViewController *assetVc = [[AssetMainViewController alloc] init];
    
    //black hole main page
    BlackHoleMainVc *blackHoleVc = [[BlackHoleMainVc alloc] init];
    
    //today main page
    TodayMainViewController *todayVc = [[TodayMainViewController alloc] init];
    
    
    NSArray *childVcs = @[skillNav,ideaNav,blackHoleVc,todayVc];
    [rootVc setViewControllers:childVcs];
//    [rootVc setValuesForKeysWithDictionary:<#(nonnull NSDictionary<NSString *,id> *)#>];
    
    NSArray *tabBarItemImages = @[@"first",@"second",@"third",@"fourth"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[rootVc tabBar] items]) {
        
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
    
    return rootVc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
