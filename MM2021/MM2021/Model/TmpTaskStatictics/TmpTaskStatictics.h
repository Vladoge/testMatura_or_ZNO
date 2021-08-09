//
//  TmpTaskStatictics.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "YourAnswerAndTaskModel.h"
#import "FullTask.h"

@interface TmpTaskStatictics : NSObject

@property (nonatomic, assign) NSInteger numberTrueAnswer;
@property (nonatomic, assign) NSInteger numberPrimaryScores;
@property (nonatomic, assign) NSInteger numberCompletedTask; // deprecate
@property (nonatomic, assign) NSInteger currentIndexTask;

@property (nonatomic, strong) NSMutableArray* arrayYourAnswer;

-(instancetype) init;

// РЕАЛИЗОВАТЬ ЗДЕСЬ ЛОГИКУ REALIZE LOGIC HERE
-(BOOL) oneCorrectAnswerInTask:(FullTask*) task withYourAnswer:(NSString*) yAnswer;
-(BOOL) multipleCorrectAnswersAndDivideBySymbol:(FullTask*) task withYourAnswer:(NSString*) yAnswer;
-(BOOL) multipleCorrectAnswersAndSplitBySymbolWithOrder:(FullTask*) task withYourAnswer:(NSString*) yAnswer;

// Много правильных ответов, но по символам не делить и порядок не важен
// Wiele poprawnych odpowiedzi, ale nie dziel je symbolami, a kolejność nie jest ważna
// Many correct answers, but do not divide by symbols and the order is not important
-(BOOL) multipleCorrectAnswers_OrderAndSequenceAreNotImportant:(FullTask*) task withYourAnswer:(NSString*) yAnswer;
-(NSString*) description;
@end
