//
//  AppDelegate.m
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-31.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
{
  BOOL _changeFlag;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  NSMutableArray *vcs = [NSMutableArray array];
  for (int i = 0; i < 5; i++) {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = [NSString stringWithFormat:@"%d", i];
    if (i % 2 == 0) {
      vc.view.backgroundColor = [UIColor blueColor];
    } else {
      vc.view.backgroundColor = [UIColor redColor];
    }
    [vcs addObject:vc];
  }
  self.slideSegmentController = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
  self.slideSegmentController.title = @"JYSlideSegmentController";
  self.slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
  self.slideSegmentController.indicator.backgroundColor = [UIColor redColor];
  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:self.slideSegmentController];
  self.window.rootViewController = navi;

  UIBarButtonItem *changeVCsItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                 target:self
                                                                                 action:@selector(changeVCs)];
  self.slideSegmentController.navigationItem.rightBarButtonItem = changeVCsItem;
  [self.window makeKeyAndVisible];
  return YES;
}


- (void)changeVCs
{
  NSMutableArray *vcs = [NSMutableArray array];
  for (int i = 0; i < 5; i++) {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = _changeFlag ? [NSString stringWithFormat:@"%d", i] : [NSString stringWithFormat:@"vc %d", i];
    if (_changeFlag ? (i % 2 == 0) : (i % 2 != 0)) {
      vc.view.backgroundColor = [UIColor blueColor];
    } else {
      vc.view.backgroundColor = [UIColor redColor];
    }
    [vcs addObject:vc];
  }
  self.slideSegmentController.viewControllers = vcs;
  _changeFlag = !_changeFlag;
}

@end
