//
//  TmpTaskStatictics.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "TmpTaskStatictics.h"
#import "Utilities.h"

@implementation TmpTaskStatictics

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.numberTrueAnswer    = 0;
        self.numberPrimaryScores = 0;
        self.numberCompletedTask = 0;
        self.currentIndexTask    = 0;
        self.arrayYourAnswer = [NSMutableArray array];
    }
    return self;
}

-(BOOL) oneCorrectAnswerInTask:(FullTask*) task withYourAnswer:(NSString*) yAnswer
{
    
    // self.currentYourAnswerAndModel.yourAnswer = self.expectedAnswerField.text;
    // 1. Записывать ответ в модель в контроллере
    
    if (task.onlyOneCorrectAnswer)
    {
        for (NSString* trueAnswer in task.answers)
        {
            if ([yAnswer isEqualToString:trueAnswer])
            {
                self.numberTrueAnswer++;
                self.numberPrimaryScores += task.primaryScore;
                //break;
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL) multipleCorrectAnswersAndDivideBySymbol:(FullTask*) task withYourAnswer:(NSString*) yAnswer
{
    if ( !(task.onlyOneCorrectAnswer) && (task.divideTheAnswerForEachCharacter))
    {
        NSArray* separateSymbols = [Utilities divideStringIntoIndividualCharacters:yAnswer];
        BOOL thereWasAtLeastOneCorrectAnswer = NO;
        
        for (NSString* myAnsw in separateSymbols)
        {
            for (NSString* trueAnsw in task.answers)
            {
                if ([myAnsw isEqualToString:trueAnsw])
                {
                    self.numberPrimaryScores += task.primaryScore;
                    thereWasAtLeastOneCorrectAnswer = YES;
                }
            }
        }
        if (thereWasAtLeastOneCorrectAnswer){
            self.numberTrueAnswer++;
            return YES;
        }
     }
   return NO;
}

-(BOOL) multipleCorrectAnswersAndSplitBySymbolWithOrder:(FullTask*) task withYourAnswer:(NSString*) yAnswer
{
    if ( !(task.onlyOneCorrectAnswer) && (task.divideTheAnswerForEachCharacter) && (task.mandatorySequence))
    {
        NSArray* separateSymbols = [Utilities divideStringIntoIndividualCharacters:yAnswer];
        BOOL thereWasAtLeastOneCorrectAnswer = NO;
        
        for (NSString* myAnsw in separateSymbols) {
            
            NSInteger indexOfObj = [separateSymbols indexOfObject:myAnsw];
            
            if ([myAnsw isEqualToString:task.answers[indexOfObj]]) {
                self.numberPrimaryScores += task.primaryScore;
                thereWasAtLeastOneCorrectAnswer = YES;
            }
        }
        if (thereWasAtLeastOneCorrectAnswer){
            self.numberTrueAnswer++;
            return YES;
        }
    }
  return NO;
}

-(BOOL) multipleCorrectAnswers_OrderAndSequenceAreNotImportant:(FullTask*) task withYourAnswer:(NSString*) yAnswer{
 
    
    if (yAnswer.length<1) // Нечего оценивать, сразу возвращаем NO
        return NO;
    
    if (task.answers.count==0) { // Неможем оценивать т.к. массив ответов пуст
        NSLog(@"Ошибка в JSON модели нету правильных ответов");
        return NO;
    }
 
    
    
    if (!(task.onlyOneCorrectAnswer && task.divideTheAnswerForEachCharacter && task.mandatorySequence))
    {
        for (NSString* strFromTrueArrayAnswers in task.answers) {
            if ([yAnswer isEqualToString:strFromTrueArrayAnswers])
            {
                self.numberTrueAnswer++;
                self.numberPrimaryScores += task.primaryScore;
                return YES;
            }
        }
    }    
    return NO;
}


-(NSString*) description {
    return [NSString stringWithFormat:@"numberTrueAnswer = %ld\nnumberPrimaryScores = %ld\ncurrentIndexTask = %ld \n\n\n", (long)self.numberTrueAnswer, (long)self.numberPrimaryScores, (long)self.currentIndexTask];
}



@end








