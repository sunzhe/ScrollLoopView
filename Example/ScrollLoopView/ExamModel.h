//
//  ExamModel.h
//  examinationTest
//
//  Created by ioszhe on 15/11/11.
//  Copyright © 2015年 ioszhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamModel : NSObject

@property(nonatomic, retain)NSString *title;
@property(nonatomic, assign)NSInteger selectAnswer; //从1开始
@property(nonatomic, retain)NSArray *answers;
@property(nonatomic, assign)NSInteger theAnswer;
@end
