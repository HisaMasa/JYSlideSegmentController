//
//  JYSlideSegmentController.h
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const segmentBarItemID;

/**
 segmentBar vertical position.
 */
typedef NS_ENUM(NSInteger, JYSlideSegmentBarPosition) {
    JYSlideSegmentBarPositionTop = 0,
    JYSlideSegmentBarPositionBottom = 1,
};

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
- (void)slideViewDidScroll:(UIScrollView *)slideView;

/**
 * scrollView delegate for segmentBar
*/
- (void)slideSegmentDidScroll:(UIScrollView *)segmentBar;
- (void)slideSegmentDidEndDecelerating:(UIScrollView *)segmentBar;
- (void)slideSegmentDidEndDragging:(UIScrollView *)segmentBar willDecelerate:(BOOL)decelerate;
- (void)slideSegment:(UICollectionView *)segmentBar didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)slideDidEndScrollingAnimation:(UIScrollView *)segmentBar;
- (void)slideWillBeginDragging:(UIScrollView *)segmentBar;

/**
 *  progress of switching index, range -1 to 1, is influnced by slideView contentOffset.
 *  0 - 1: fromIndex < toIndex (switching to right), 0 - -1: fromIndex > toIndex (switching to left)
 */
- (void)slideViewMovingProgress:(CGFloat)progress fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
@end

@protocol JYSlideViewDelegate <NSObject>

@optional
- (BOOL)slideViewPanGestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)slideViewPanGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface JYSlideView : UICollectionView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<JYSlideViewDelegate> slideDelegate;

@end

@interface JYSlideSegmentController : UIViewController

/**
 *  Child viewControllers of SlideSegmentController
 *  it will reset the selectedIndex to start index, after you setting this property,
 *  if you want to change this performance, you should set startIndex before setting viewControllers
 */
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, strong, readonly) UICollectionView *segmentBar;
@property (nonatomic, strong, readonly) JYSlideView *slideView;

@property (nonatomic, weak, readonly) UIViewController *selectedViewController;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;

/**
 *  Custom UI
 */
@property (nonatomic, assign) CGFloat segmentWidth;
@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) UIEdgeInsets segmentInsets; // segmentBar layout sectionInset

/**
 The segmentBar position in container. Default is JYSlideSegmentBarPositionTop.
 */
@property (nonatomic, assign) JYSlideSegmentBarPosition segmentBarPosition;

@property (nonatomic, strong) UIView *indicator;

@property (nonatomic, assign) UIEdgeInsets indicatorInsets;

@property (nonatomic, assign) CGFloat indicatorWidth;
@property (nonatomic, assign) CGFloat indicatorHeight;

@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) CGFloat separatorHeight;

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
