//
//  ExamAnswerItem.m
//  examinationTest
//
//  Created by ioszhe on 15/11/11.
//  Copyright © 2015年 ioszhe. All rights reserved.
//

#import "ExamAnswerItem.h"
@interface ExamAnswerItem(){
    UIImageView *selectImg;
    UILabel *titleLbl;
}

@end
@implementation ExamAnswerItem

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViews];
    }
    return self;
}
- (void)loadViews{
    //self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    selectImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    selectImg.layer.cornerRadius = selectImg.frame.size.width/2;
    selectImg.layer.masksToBounds = YES;
    [self addSubview:selectImg];
    titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, self.frame.size.width - 60, self.frame.size.height-20)];
    titleLbl.numberOfLines = 0;
    [self addSubview:titleLbl];
}

- (void)setAnswer:(NSString *)answer{
    if (![_answer isEqualToString:answer]) {
        _answer = answer;
        titleLbl.text = _answer;
        CGSize lblsize = [titleLbl sizeThatFits:CGSizeMake(self.frame.size.width - 60, CGFLOAT_MAX)];
        CGRect sRect = self.frame;
        sRect.size.height = lblsize.height + 20;
        self.frame = sRect;
        titleLbl.frame = CGRectMake(40, 10, self.frame.size.width - 60, self.frame.size.height-20);
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    [UIView animateWithDuration:0.3 animations:^{
        selectImg.backgroundColor = selected?[UIColor redColor]:[UIColor lightGrayColor];
        self.backgroundColor = selected?[UIColor grayColor]:[UIColor colorWithWhite:0.6 alpha:1];
    }];
}

@end
