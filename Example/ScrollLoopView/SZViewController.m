//
//  SZViewController.m
//  ScrollLoopView
//
//  Created by ioszhe on 11/24/2015.
//  Copyright (c) 2015 ioszhe. All rights reserved.
//

#import "SZViewController.h"
#import "ScrollLoopView.h"
#import "ExaminationCell.h"

@interface SZViewController ()

@end

@implementation SZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSInteger i=1; i< 5; i++) {
        ExamModel *exam = [ExamModel new];
        exam.title = [NSString stringWithFormat:@"考试题目 %ld考试题目考试题目考试题目考试题目考试题目考试题目考试题目\n123\n123\n123\n123\n123\n123\n123", (long)i];
        exam.answers =  @[@"答案1\n123", @"答案2\n123\n123", @"答案3\n123\n123\n123\n123", @"答案4\n123\n123"];
        exam.theAnswer = 1 + rand()%4;
        [tmp addObject:exam];
    }
    self.contentList = tmp;
    [tmp addObject:@(1)];
    ScrollLoopView *loopView = [[ScrollLoopView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 400)];
    loopView.rowNum = _contentList.count;
    
    __unsafe_unretained ScrollLoopView * tmpLoopView = loopView;
    loopView.itemForRow = ^UIView *(UIView *item, NSInteger row) {
        ExaminationCell *tmp = (ExaminationCell *)item;
        if (tmp == nil) {
            tmp = [[ExaminationCell alloc] initWithFrame:loopView.bounds];
            tmp.onSelectAnswer= ^(NSInteger idx){
                if (idx == self.contentList.count-1) {
                    //最后一个
                    [self handelAllAnswer];
                }else {
                    [tmpLoopView performSelector:@selector(scrollToNext) withObject:nil afterDelay:0.5];
                }
            };
        }
        tmp.exam = row < self.contentList.count ? self.contentList[row] : nil;
        return tmp;
    };
    loopView.canScrollToIdx = ^BOOL (NSInteger row){
        if (row > 0 && row < self.contentList.count) {
            ExamModel *exam = self.contentList[row-1];
            return exam.selectAnswer > 0;
        }
        return YES;
    };
    loopView.currSelectRow = ^(UIView *item, NSInteger idx){
        NSLog(@"滚动到%ld", idx);
    };
    [self.view addSubview:loopView];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)handelAllAnswer{
    NSInteger score = 0;
    for (ExamModel *exam in _contentList) {
        score += exam.selectAnswer;
    }
    NSLog(@"得分为%ld", score);
}

@end
