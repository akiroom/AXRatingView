//
//  AXAppDelegate.m
//  AXRatingViewDemo
//

#import "AXAppDelegate.h"
#import "AXMenuViewController.h"

@implementation AXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  
  AXMenuViewController *menuViewCon = [[AXMenuViewController alloc] init];
  UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:menuViewCon];
  self.window.rootViewController = navCon;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
