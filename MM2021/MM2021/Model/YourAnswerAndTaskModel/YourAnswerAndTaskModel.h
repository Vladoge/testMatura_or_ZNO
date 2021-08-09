//
//  YourAnswerAndTaskModel.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "FullTask.h"

@interface YourAnswerAndTaskModel : NSObject

@property (strong, nonatomic) NSString* yourAnswer;
@property (assign, nonatomic) BOOL answerIsCorrect;
@property (strong, nonatomic) FullTask* modelFullTask;

- (instancetype)initWithYourAnswer:(NSString*) answer andFullTask:(FullTask*) task;

- (NSString*) description;
@end

