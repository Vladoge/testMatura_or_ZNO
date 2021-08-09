//
//  InfoTVC_Model.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "FEMMapping.h"

@interface InfoTVC_Model : NSObject

@property (nonatomic, strong) NSString* titleForWeInVK;
@property (nonatomic, strong) NSString* titleForMyStatistics;
@property (nonatomic, strong) NSString* titleForTableBalls;

@property (nonatomic, strong) NSString* linkOnWeInVK;
@property (nonatomic, strong) NSArray* linkOnTableBalls;


- (NSString*) description;
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;
+ (FEMMapping *)defaultMapping;

@end



