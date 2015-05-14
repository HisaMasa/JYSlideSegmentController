//
//  JYSlideSegmentController.m
//  JYSlideSegmentController
//
//  Created by Alvin on 14-3-16.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "JYSlideSegmentController.h"

#define SEGMENT_BAR_HEIGHT (44)
#define INDICATOR_HEIGHT (3)

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

NSString * const segmentBarItemID = @"JYSegmentBarItem";

@interface JYSegmentBarItem : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation JYSegmentBarItem

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self.contentView addSubview:self.titleLabel];
  }
  return self;
}

- (UILabel *)titleLabel
{
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
    _titleLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _titleLabel;
}

@end

@interface JYSlideSegmentController ()
<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *indicator;
@property (nonatomic, strong) UIView *indicatorBgView;
@property (nonatomic, strong) UIView *separator;

@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;


- (void)reset;

@end

@implementation JYSlideSegmentController
@synthesize viewControllers = _viewControllers;
@synthesize itemWidth = _itemWidth;
@synthesize separatorColor = _separatorColor;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
  self = [super init];
  if (self) {
    _viewControllers = [viewControllers copy];
    _selectedIndex = NSNotFound;
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  [self setupSubviews];
  [self reset];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
  [self.slideView setContentSize:conentSize];
}

- (void)viewDidLayoutSubviews
{
  CGRect frame = CGRectMake(0, self.segmentBar.frame.size.height - self.indicatorHeight,
                            self.itemWidth, self.indicatorHeight);
  self.indicatorBgView.frame = frame;
  CGFloat indicatorWidth = self.itemWidth - self.indicatorInsets.left - self.indicatorInsets.right;
  CGRect indicatorFrame = CGRectMake(self.indicatorInsets.left, 0, indicatorWidth, self.indicatorHeight);
  self.indicator.frame = indicatorFrame;
  CGRect separatorFrame = CGRectMake(0, CGRectGetMaxY(self.segmentBar.frame),
                                     CGRectGetWidth(self.segmentBar.frame), 1);
  self.separator.frame = separatorFrame;
}

#pragma mark - Setup
- (void)setupSubviews
{
  // iOS7 set layout
  if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  [self.view addSubview:self.segmentBar];
  [self.view addSubview:self.slideView];
  [self.segmentBar registerClass:[JYSegmentBarItem class] forCellWithReuseIdentifier:segmentBarItemID];
  [self.segmentBar addSubview:self.indicatorBgView];

  CGRect separatorFrame = CGRectMake(0, CGRectGetMaxY(self.segmentBar.frame),
                                     CGRectGetWidth(self.segmentBar.frame), 1);
  _separator = [[UIView alloc] initWithFrame:separatorFrame];
  [_separator setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
  [_separator setBackgroundColor:self.separatorColor];
  [self.view addSubview:_separator];
}

#pragma mark - Property
- (UIScrollView *)slideView
{
  if (!_slideView) {
    CGRect frame = self.view.bounds;
    frame.size.height -= _segmentBar.frame.size.height;
    frame.origin.y = CGRectGetMaxY(_segmentBar.frame);
    _slideView = [[UIScrollView alloc] initWithFrame:frame];
    [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                     | UIViewAutoresizingFlexibleHeight)];
    [_slideView setShowsHorizontalScrollIndicator:NO];
    [_slideView setShowsVerticalScrollIndicator:NO];
    [_slideView setPagingEnabled:YES];
    [_slideView setBounces:NO];
    [_slideView setDelegate:self];
  }
  return _slideView;
}

- (UICollectionView *)segmentBar
{
  if (!_segmentBar) {
    CGRect frame = self.view.bounds;
    frame.size.height = SEGMENT_BAR_HEIGHT;
    _segmentBar = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.segmentBarLayout];
    _segmentBar.backgroundColor = [UIColor whiteColor];
    _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _segmentBar.delegate = self;
    _segmentBar.dataSource = self;
    _segmentBar.showsHorizontalScrollIndicator = NO;
    _segmentBar.showsVerticalScrollIndicator = NO;
    _segmentBar.scrollsToTop = NO;
  }
  return _segmentBar;
}

- (UIView *)indicatorBgView
{
  if (!_indicatorBgView) {
    CGRect frame = CGRectMake(0, self.segmentBar.frame.size.height - self.indicatorHeight,
                              self.itemWidth, self.indicatorHeight);
    _indicatorBgView = [[UIView alloc] initWithFrame:frame];
    _indicatorBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _indicatorBgView.backgroundColor = [UIColor clearColor];
    [_indicatorBgView addSubview:self.indicator];
  }
  return _indicatorBgView;
}

- (UIView *)indicator
{
  if (!_indicator) {
    CGFloat width = self.itemWidth - self.indicatorInsets.left - self.indicatorInsets.right;
    CGRect frame = CGRectMake(self.indicatorInsets.left, 0, width, self.indicatorHeight);
    _indicator = [[UIView alloc] initWithFrame:frame];
    _indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _indicator.backgroundColor = self.indicatorColor ? : [UIColor yellowColor];
  }
  return _indicator;
}

- (CGFloat)indicatorHeight
{
  if (!_indicatorHeight) {
    _indicatorHeight = INDICATOR_HEIGHT;
  }
  return _indicatorHeight;
}

- (CGFloat)itemWidth
{
  if (!_itemWidth) {
    _itemWidth = self.view.frame.size.width / self.viewControllers.count;
  }
  return _itemWidth;
}

- (void)setItemWidth:(CGFloat)itemWidth
{
  _itemWidth = itemWidth;
  if (_segmentBarLayout && _segmentBar) {
    _segmentBarLayout.itemSize = CGSizeMake(_itemWidth, SEGMENT_BAR_HEIGHT);
    [_segmentBar setCollectionViewLayout:_segmentBarLayout animated:NO];
    [self.view setNeedsLayout];
  }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
  _indicatorColor = indicatorColor;
  _indicator.backgroundColor = _indicatorColor;
}

- (UIColor *)separatorColor
{
  if (!_separatorColor) {
    _separatorColor = UIColorFromRGB(0xdcdcdc);
  }
  return _separatorColor;
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
  _separatorColor = separatorColor;
  self.separator.backgroundColor = _separatorColor;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
  if (!_segmentBarLayout) {
    _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
    _segmentBarLayout.itemSize = CGSizeMake(self.itemWidth, SEGMENT_BAR_HEIGHT);
    _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
    _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _segmentBarLayout.minimumLineSpacing = 0;
    _segmentBarLayout.minimumInteritemSpacing = 0;
  }
  return _segmentBarLayout;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
  if (_selectedIndex == selectedIndex) {
    return;
  }

  NSParameterAssert(selectedIndex >= 0 && selectedIndex < self.viewControllers.count);

  UIViewController *toSelectController = [self.viewControllers objectAtIndex:selectedIndex];

  // Add selected view controller as child view controller
  if (!toSelectController.parentViewController) {
    [self addChildViewController:toSelectController];
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width * selectedIndex;
    toSelectController.view.frame = rect;
    [self.slideView addSubview:toSelectController.view];
    [toSelectController didMoveToParentViewController:self];
  }
  _selectedIndex = selectedIndex;
  if ([_delegate respondsToSelector:@selector(didSelectViewController:)]) {
    [_delegate didSelectViewController:self.selectedViewController];
  }
}

- (void)setViewControllers:(NSArray *)viewControllers
{
  // Need remove previous viewControllers
  for (UIViewController *vc in _viewControllers) {
    [vc removeFromParentViewController];
  }
  _viewControllers = [viewControllers copy];
  [self reset];
}

- (NSArray *)viewControllers
{
  return [_viewControllers copy];
}

- (UIViewController *)selectedViewController
{
  return self.viewControllers[self.selectedIndex];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  if ([_dataSource respondsToSelector:@selector(numberOfSectionsInslideSegment:)]) {
    return [_dataSource numberOfSectionsInslideSegment:collectionView];
  }
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  if ([_dataSource respondsToSelector:@selector(slideSegment:numberOfItemsInSection:)]) {
    return [_dataSource slideSegment:collectionView numberOfItemsInSection:section];
  }
  return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  if ([_dataSource respondsToSelector:@selector(slideSegment:cellForItemAtIndexPath:)]) {
    return [_dataSource slideSegment:collectionView cellForItemAtIndexPath:indexPath];
  }

  JYSegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:segmentBarItemID
                                                                               forIndexPath:indexPath];
  UIViewController *vc = self.viewControllers[indexPath.row];
  segmentBarItem.titleLabel.text = vc.title;
  return segmentBarItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
    return;
  }

  [self setSelectedIndex:indexPath.row];
  [self scrollToViewWithIndex:self.selectedIndex animated:NO];
  [self segmentBarScrollToIndex:_selectedIndex animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
    return NO;
  }

  BOOL flag = YES;
  UIViewController *vc = self.viewControllers[indexPath.row];
  if ([_delegate respondsToSelector:@selector(shouldSelectViewController:)]) {
    flag = [_delegate shouldSelectViewController:vc];
  }
  return flag;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if (scrollView == self.slideView) {
    // set indicator frame
    CGRect frame = self.indicatorBgView.frame;
    CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
    frame.origin.x = self.segmentBar.contentSize.width * percent;
    self.indicatorBgView.frame = frame;

    NSInteger index = ceilf(percent * self.viewControllers.count);
    if (index >= 0 && index < self.viewControllers.count) {
      [self setSelectedIndex:index];
    }
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if (scrollView == self.slideView) {
    [self segmentBarScrollToIndex:_selectedIndex animated:YES];
    if ([_delegate respondsToSelector:@selector(didFullyShowViewController:)]) {
      [_delegate didFullyShowViewController:self.selectedViewController];
    }
  }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
  if (scrollView == self.slideView) {
    [self segmentBarScrollToIndex:_selectedIndex animated:YES];
    if ([_delegate respondsToSelector:@selector(didFullyShowViewController:)]) {
      [_delegate didFullyShowViewController:self.selectedViewController];
    }
  }
}

#pragma mark - Action
- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated
{
  CGRect rect = self.slideView.bounds;
  rect.origin.x = rect.size.width * index;
  [self.slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
  if (!animated && [_delegate respondsToSelector:@selector(didFullyShowViewController:)]) {
    [_delegate didFullyShowViewController:self.selectedViewController];
  }
}

- (void)reset
{
  _selectedIndex = NSNotFound;
  [self setSelectedIndex:0];
  [self scrollToViewWithIndex:0 animated:NO];
  [self segmentBarScrollToIndex:0 animated:NO];
  [self.segmentBar reloadData];
}

- (void)segmentBarScrollToIndex:(NSInteger)index animated:(BOOL)animated
{
  [self.segmentBar scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                          atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
}

@end

