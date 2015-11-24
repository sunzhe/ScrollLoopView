
//
//  ScrollLoopView.m
//  examinationTest
//
//  Created by ioszhe on 15/11/12.
//  Copyright © 2015年 ioszhe. All rights reserved.
//

#import "ScrollLoopView.h"
#import <objc/runtime.h>

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 568
#define IMAGEVIEW_COUNT 3
const NSString * OBJC_ASSOCIATION_CUSTOMINDEX = @"OBJC_ASSOCIATION_CUSTOMINDEX";
@implementation NSObject(customIndex)

- (void)setCustomIndex:(NSInteger)customIndex{
    objc_setAssociatedObject(self, (__bridge const void *)(OBJC_ASSOCIATION_CUSTOMINDEX), @(customIndex), OBJC_ASSOCIATION_ASSIGN);
}
- (NSInteger)customIndex {
    NSNumber *tmp = objc_getAssociatedObject(self, (__bridge const void *)(OBJC_ASSOCIATION_CUSTOMINDEX));
    return tmp.integerValue;
}

@end


@interface ScrollLoopView()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UILabel *_label;
    
    CGFloat _lastOffset;
    BOOL shouldCanMove;
}
@property(nonatomic, retain)NSMutableArray *cacheItems;
@property(nonatomic, retain)NSMutableArray *currentItems;
@end
@implementation ScrollLoopView
- (void)dealloc{
    self.currSelectRow = nil;
    self.itemForRow = nil;
    self.canScrollToIdx = nil;
    [_cacheItems removeAllObjects];
    _cacheItems = nil;
    [_currentItems removeAllObjects];
    _currentItems = nil;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.cacheItems = [NSMutableArray array];
        self.currentItems = [NSMutableArray array];
        _boundOffset = frame.size.width;
        _scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator=NO;
        [self addSubview:_scrollView];
        self.itemSize = _scrollView.frame.size;
        //设置代理
        _scrollView.delegate=self;
    }
    return self;
}
- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    [self reloadData];
}
- (void)scrollToNext{
    [self scrollToIndex:_currentItemIndex+1];
}
- (void)scrollToIndex:(NSInteger)idx{
    [_scrollView setContentOffset:CGPointMake(MIN(idx, _rowNum-1)*_itemSize.width, 0) animated:YES];
}
- (void)setItemSize:(CGSize)itemSize{
    if (!CGSizeEqualToSize(_itemSize, itemSize)) {
        _itemSize = itemSize;
        _scrollView.pagingEnabled = _itemSize.width == _scrollView.frame.size.width;
        [self reloadData];
    }
}
#pragma mark 滚动停止事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    shouldCanMove = YES;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    scrollView.scrollEnabled = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //判断是否可滑动
    if (_canScrollToIdx && scrollView.isDragging && scrollView.contentOffset.x > _currentItemIndex*_itemSize.width){
        NSInteger toIdx = _currentItemIndex;
        if (scrollView.contentOffset.x > _lastOffset) {//右
            toIdx = _currentItemIndex + 1;
        }else if (scrollView.contentOffset.x < _lastOffset){//左
            toIdx = _currentItemIndex - 1;
        }
        if (!_canScrollToIdx(toIdx)) {
            scrollView.contentOffset = CGPointMake(_currentItemIndex*_itemSize.width, 0);
            _lastOffset = scrollView.contentOffset.x;
            scrollView.scrollEnabled = NO;
            scrollView.scrollEnabled = YES;
            return;
        }
    }
    _lastOffset = scrollView.contentOffset.x;
    //重新加载图片
    NSInteger tmpIdx = (NSInteger)((2*_scrollView.contentOffset.x + _itemSize.width) / _itemSize.width/2);
    if (tmpIdx != _currentItemIndex) {
        _currentItemIndex = tmpIdx;
        shouldCanMove = NO;
        [self reloadData];
    }
}

#pragma mark 重新加载
-(void)reloadData{
    
    _scrollView.contentSize=CGSizeMake(_rowNum*_itemSize.width, _scrollView.frame.size.height);
    for (UIView *item in _currentItems) {
        if (![self itemInScreen:item]) {
            [_cacheItems addObject:item];
            [item removeFromSuperview];
        }
    }
    [_currentItems removeObjectsInArray:_cacheItems];
    CGRect rect = CGRectMake(0, 0, _itemSize.width, _itemSize.height);
    for (NSInteger i = MAX(0, _currentItemIndex-1); i < MIN(_currentItemIndex+2, _rowNum); i++) {
        rect.origin.x = i*_itemSize.width;
        UIView *item = [self getItemWithRow:i];
        item.frame = rect;
        if (i == _currentItemIndex && _currSelectRow) {
            self.currSelectRow(item, _currentItemIndex);
        }
    }
}
//通过行获取view
- (UIView *)getItemWithRow:(NSInteger)row{
    for (UIView *item in _currentItems) {
        if (item.customIndex == row+1000) {
            return item;
        }
    }
    UIView *tmp = _cacheItems.firstObject;
    if (tmp) {
        [_cacheItems removeObject:tmp];
    }
    tmp = self.itemForRow(tmp, row);
    tmp.customIndex = row+1000;
    [_scrollView addSubview:tmp];
    [_currentItems addObject:tmp];
    return tmp;
}
//保留在屏幕上
- (BOOL)itemInScreen:(UIView *)item{
    CGRect screenRect = CGRectMake(_scrollView.contentOffset.x-_boundOffset, 0, _scrollView.frame.size.width+2*_boundOffset, _scrollView.frame.size.height);
    if (CGRectContainsRect(screenRect, item.frame)) {
        return YES;
    }
    return NO;
}
@end
