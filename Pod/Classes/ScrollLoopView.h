//
//  ScrollLoopView.h
//  examinationTest
//
//  Created by ioszhe on 15/11/12.
//  Copyright © 2015年 ioszhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSObject(customIndex)
@property(nonatomic, assign)NSInteger customIndex;
@end

@protocol ScrollLoopViewDelegate;
@interface ScrollLoopView : UIView

@property(nonatomic, assign)id<ScrollLoopViewDelegate> target;
@property(nonatomic, assign)NSInteger rowNum;
@property(nonatomic, assign)CGSize itemSize;
@property(nonatomic, assign)CGFloat boundOffset;
@property(nonatomic, assign)NSInteger currentItemIndex;//当前索引;

@property(nonatomic, copy)void    (^currSelectRow)(UIView*, NSInteger);//当前滑动到的位置
@property(nonatomic, copy)UIView* (^itemForRow)(UIView*, NSInteger);//相当于cellForRow
//@property(nonatomic, copy)CGSize  (^itemSizeForRow)(NSInteger);//相当于cellForRow
@property(nonatomic, copy)BOOL    (^canScrollToIdx)(NSInteger);        //是否可以滚动到响应页面

- (void)scrollToNext;//滚动到下一页
- (void)scrollToIndex:(NSInteger)idx;
@end

@protocol ScrollLoopViewDelegate <NSObject>

- (NSInteger)rowNum;

- (UIView*)itemForRow:(NSInteger)row;

@end