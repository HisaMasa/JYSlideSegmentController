//
//  AppDelegate.m
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-31.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate
{
  BOOL _changeFlag;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.slideSegmentController = [[JYSlideSegmentController alloc] initWithViewControllers:[self vcs]
                                                                               startIndex:0];
  self.slideSegmentController.title = @"JYSlideSegmentController";
  self.slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
  self.slideSegmentController.indicatorColor = [UIColor greenColor];
  self.slideSegmentController.segmentWidth = 80;
  self.slideSegmentController.indicatorWidth = 22;
  self.slideSegmentController.indicatorType = JYIndicatorWidthTypeFixed;
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
//  self.slideSegmentController.startIndex = 0;
  _changeFlag = !_changeFlag;
  self.slideSegmentController.viewControllers = [self vcs];
}

- (NSArray *)vcs
{
  NSMutableArray *vcs = [NSMutableArray array];
  for (int i = 0; i < 10; i++) {
    ViewController *vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    vc.title = _changeFlag ? [NSString stringWithFormat:@"vc%d", i] : [NSString stringWithFormat:@"%d", i];
    if (_changeFlag ? (i % 2 == 0) : (i % 2 != 0)) {
      vc.view.backgroundColor = [UIColor blueColor];
    } else {
      vc.view.backgroundColor = [UIColor redColor];
    }
    [vcs addObject:vc];
  }
  return [vcs copy];
}

@end
