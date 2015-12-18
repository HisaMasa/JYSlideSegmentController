//
//  JYSlideSegmentController.h
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const segmentBarItemID;

@class JYSlideSegmentController;

/**
 *  Need to be implemented this methods for custom UI of segment button
 */
@protocol JYSlideSegmentDataSource <NSObject>
@required

- (NSInteger)slideSegment:(UICollectionView *)segmentBar
   numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)slideSegment:(UICollectionView *)segmentBar
                cellForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)slideSegment:(UICollectionView *)segmentBar
                layout:(UICollectionViewLayout *)segmentBarViewLayout
sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInslideSegment:(UICollectionView *)segmentBar;

@end

@protocol JYSlideSegmentDelegate <NSObject>
@optional
- (void)didSelectViewController:(UIViewController *)viewController;
- (void)didFullyShowViewController:(UIViewController *)viewController;
- (BOOL)shouldSelectViewController:(UIViewController *)viewController;
@end

@protocol JYSlideViewDelegate <NSObject>

@optional
- (BOOL)slideViewPanGestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)slideViewPanGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface JYSlideView : UIScrollView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<JYSlideViewDelegate> slideDelegate;

@end

@interface JYSlideSegmentController : UIViewController

/**
 *  Child viewControllers of SlideSegmentController
 */
@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, strong, readonly) UICollectionView *segmentBar;
@property (nonatomic, strong, readonly) JYSlideView *slideView;

@property (nonatomic, weak, readonly) UIViewController *selectedViewController;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/**
 *  Custom UI
 */
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat segmentBarWidth;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, assign) UIEdgeInsets indicatorInsets;
@property (nonatomic, strong) UIColor *separatorColor;

/**
 *  By default segmentBar use viewController's title for segment's button title
 *  You should implement JYSlideSegmentDataSource & JYSlideSegmentDelegate instead of segmentBar delegate & datasource
 */
@property (nonatomic, assign) id <JYSlideSegmentDelegate> delegate;
@property (nonatomic, assign) id <JYSlideSegmentDataSource> dataSource;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;
- (instancetype)initWithViewControllers:(NSArray *)viewControllers
                             startIndex:(NSInteger)startIndex;

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

@end
