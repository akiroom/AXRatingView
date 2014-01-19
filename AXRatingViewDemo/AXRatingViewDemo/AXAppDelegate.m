//
//  AXAppDelegate.m
//  AXRatingViewDemo
//

#import "AXAppDelegate.h"
#import "AXViewController.h"

@implementation AXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  AXViewController *viewController = [[AXViewController alloc] init];
  self.window.rootViewController = viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
