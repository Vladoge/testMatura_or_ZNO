//
//  FullTask.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "FEMMapping.h"


@interface FullTask : NSObject

@property (nonatomic, strong) NSString* taskName;
@property (nonatomic, strong) NSString* taskDefinition;
@property (nonatomic, strong) NSString* mainText;


@property (nonatomic, assign) NSInteger primaryScore;
@property (nonatomic, assign) BOOL onlyOneCorrectAnswer;
@property (nonatomic, assign) BOOL divideTheAnswerForEachCharacter;
@property (nonatomic, assign) BOOL mandatorySequence;

@property (nonatomic, strong) NSString* expectedAnswer;
@property (nonatomic, strong) NSArray*  answers;

@property (nonatomic, strong) NSString* actionDirection;
@property (nonatomic, strong) NSArray*  arrURLImageForTask;

@property (nonatomic, assign) BOOL addPictureInTop;
@property (nonatomic, assign) BOOL chooseAnswerFromPicker;
@property (nonatomic, assign) BOOL noValidAnswerTotheRecord;

@property (nonatomic, strong) NSString* pictureForNoValidAnswer;
@property (nonatomic, strong) NSArray* arrayExpectedAnswerForPicker;

- (NSString*) description;
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;
+ (FEMMapping *)defaultMapping;

@end

