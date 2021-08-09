//
//  FullTask.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "FullTask.h"

@implementation FullTask


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {

        self.taskName       = [responseObject objectForKey:@"taskName"];
        self.taskDefinition = [responseObject objectForKey:@"taskDefinition"];
        self.mainText       = [responseObject objectForKey:@"mainText"];
        
        self.noValidAnswerTotheRecord = [[responseObject objectForKey:@"noValidAnswerTotheRecord"] boolValue];
        self.pictureForNoValidAnswer  = [responseObject objectForKey:@"pictureForNoValidAnswer"];

        self.primaryScore          = [[responseObject objectForKey:@"primaryScore"] integerValue];
        self.onlyOneCorrectAnswer  = [[responseObject objectForKey:@"onlyOneCorrectAnswer"] boolValue];
        self.divideTheAnswerForEachCharacter  = [[responseObject objectForKey:@"divideTheAnswerForEachCharacter"] boolValue];
        self.mandatorySequence  = [[responseObject objectForKey:@"mandatorySequence"] boolValue];

        self.expectedAnswer        = [responseObject objectForKey:@"expectedAnswer"];

        self.answers                = [responseObject objectForKey:@"answers"];
        self.addPictureInTop        = [[responseObject objectForKey:@"addPictureInTop"] boolValue];
        self.chooseAnswerFromPicker = [[responseObject objectForKey:@"chooseAnswerFromPicker"] boolValue];

        self.arrayExpectedAnswerForPicker = [responseObject objectForKey:@"arrayExpectedAnswerForPicker"];
        self.actionDirection              = [responseObject objectForKey:@"actionDirection"];
        self.arrURLImageForTask           = [responseObject objectForKey:@"arrURLImageForTask"];

    }
    
    return self;
}

#pragma mark - Mapping

+ (FEMMapping *)defaultMapping
{
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[FullTask class]];
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"taskName"          : @"taskName",
                                            @"taskDefinition"    : @"taskDefinition",
                                            @"mainText"          : @"mainText",
                                            @"primaryScore"      : @"primaryScore",
                                            @"onlyOneCorrectAnswer"   : @"onlyOneCorrectAnswer",
                                            @"divideTheAnswerForEachCharacter" : @"divideTheAnswerForEachCharacter",
                                            @"mandatorySequence"      : @"mandatorySequence",
                                            @"expectedAnswer"         : @"expectedAnswer",
                                            @"answers"                : @"answers",
                                            
                                            @"actionDirection"        : @"actionDirection",
                                            @"arrURLImageForTask"     : @"arrURLImageForTask",
                                          
                                            @"addPictureInTop"          : @"addPictureInTop",
                                            @"chooseAnswerFromPicker"   : @"chooseAnswerFromPicker",
                                            @"noValidAnswerTotheRecord" : @"noValidAnswerTotheRecord",
                                          
                                            @"pictureForNoValidAnswer"      : @"pictureForNoValidAnswer",
                                            @"arrayExpectedAnswerForPicker" : @"arrayExpectedAnswerForPicker"
                                            }];
    
    return mapping;
}


#pragma mark - Helper methods

- (NSString*) description {
    
    // На случай того, что если строка может быть короче
    // Na wypadek, gdyby ciąg mógł być krótszy
    // In case the string could be shorter
    
    NSString* tmpDefn      = ([self.taskDefinition length] < 10) ? self.taskDefinition : [self.taskDefinition substringToIndex:10];
    NSString* tmpMainText  = ([self.taskName length] < 10)       ? self.taskName       : [self.taskName substringToIndex:10];
    
    return [NSString stringWithFormat:@"Name        = %@\nDefin       = %@\nMainText    = %@\nPrimaryScore = %ld\nOnlyOneCorrectAnswer             = %d\nDivideTheAnswerForEachCharacter  = %d \nMandatorySequence                = %d \nExpectedAnswer  = %@ \nAnswers         = %@ \nActionDirection  = %@ \nArrURLImageForTask  = %@\nAddPictureInTop  = %d \nChooseAnswerFromPicker    = %d \nNoValidAnswerTotheRecord  = %d \nPictureForNoValidAnswer  = %@ \nArrayExpectedAnswerForPicker  = %@ \n\n\n--------------------------", self.taskName,
                                      tmpDefn,
                                      tmpMainText,
                                      (long)self.primaryScore,
                                      self.onlyOneCorrectAnswer,
                                      self.divideTheAnswerForEachCharacter,
                                      self.mandatorySequence,
                                      self.expectedAnswer,
                                      self.answers,
                                      self.actionDirection,
                                      self.arrURLImageForTask,
                                      self.addPictureInTop,
                                      self.chooseAnswerFromPicker,
                                      self.noValidAnswerTotheRecord,
                                      self.pictureForNoValidAnswer,
                                      self.arrayExpectedAnswerForPicker];
}


@end
