//
//  YourAnswerAndTaskModel.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "YourAnswerAndTaskModel.h"

@implementation YourAnswerAndTaskModel

- (instancetype)initWithYourAnswer:(NSString*) answer andFullTask:(FullTask*) task
{
    self = [super init];
    if (self) {
        
        self.yourAnswer = answer;
        self.modelFullTask = [[FullTask alloc] init];
        self.modelFullTask = task;
    }
    return self;
}

- (NSString*) description {
     return [NSString stringWithFormat:@"yourAnswer = %@\nmodelFullTask = %@",self.yourAnswer,self.modelFullTask];
}
@end
