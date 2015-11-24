//
//  ExaminationCell.h
//  examinationTest
//
//  Created by ioszhe on 15/11/11.
//  Copyright © 2015年 ioszhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamModel.h"
#import "ExamAnswerItem.h"
@interface ExaminationCell : UIView
@property(nonatomic, retain)ExamModel *exam;

@property(nonatomic, copy)void (^onSelectAnswer)(NSInteger);
@end
