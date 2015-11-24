//
//  ExaminationCell.m
//  examinationTest
//
//  Created by ioszhe on 15/11/11.
//  Copyright © 2015年 ioszhe. All rights reserved.
//

#import "ExaminationCell.h"
#import "ScrollLoopView.h"
@interface ExaminationCell(){
    UILabel *titleLbl;
    UIScrollView *contentView;
}
@end
@implementation ExaminationCell

- (void)dealloc {
    self.onSelectAnswer = nil;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViews];
    }
    return self;
}

- (void)loadViews{
    contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:contentView];
    self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height-20)];
    titleLbl.numberOfLines = 0;
    [contentView addSubview:titleLbl];
}

- (void)setExam:(ExamModel *)exam{
    if (_exam != exam){
        [contentView setContentOffset:CGPointZero animated:NO];
        _exam = exam;
        titleLbl.text = _exam.title;
        CGSize lblSize = [titleLbl sizeThatFits:CGSizeMake(self.frame.size.width - 20, CGFLOAT_MAX)];
        titleLbl.frame = CGRectMake(10, 10, self.frame.size.width - 20, lblSize.height);
        [self updateItems];
    }
}
- (void)updateItems{
    ExamAnswerItem *item = nil;
    CGRect itemRect = CGRectMake(0, titleLbl.frame.size.height + 20, self.frame.size.width, 50);
    for (int i = 0; i< 4; i++) {
        item = (ExamAnswerItem *)[contentView viewWithTag:10+i];
        if (i < _exam.answers.count) {
            if (!item) {
                item = [[ExamAnswerItem alloc] initWithFrame:itemRect];
                item.tag = 10+i;
                [item addTarget:self action:@selector(onSelected:) forControlEvents:UIControlEventTouchUpInside];
                [contentView addSubview:item];
            }
            item.hidden = NO;
            item.answer = _exam.answers[i];
            item.selected = _exam.selectAnswer == (i+1);
            itemRect.origin.y += item.frame.size.height;
        }else {
            item.selected = NO;
            item.hidden = YES;
        }
    }
    CGFloat height = MAX(itemRect.origin.y, self.frame.size.height + 1);
    contentView.contentSize = CGSizeMake(self.frame.size.width, height);
}
- (void)onSelected:(ExamAnswerItem *)item{
    NSInteger tmpIdx = item.tag - 9;
    if (tmpIdx != _exam.selectAnswer){
        ExamAnswerItem *lastItem = (ExamAnswerItem *)[contentView viewWithTag:9+_exam.selectAnswer];
        lastItem.selected = NO;
        item.selected = YES;
        _exam.selectAnswer = tmpIdx;
    }
    self.onSelectAnswer(self.customIndex-1000);
}
@end
