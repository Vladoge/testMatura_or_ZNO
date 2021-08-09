//
//  InfoTVC_Model.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "InfoTVC_Model.h"

@implementation InfoTVC_Model

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {

        self.titleForWeInVK       = [responseObject objectForKey:@"titleForWeInVK"];
        self.titleForMyStatistics = [responseObject objectForKey:@"titleForMyStatistics"];
        self.titleForTableBalls   = [responseObject objectForKey:@"titleForTableBalls"];
        
        self.linkOnWeInVK     = [responseObject objectForKey:@"linkOnWeInVK"];
        self.linkOnTableBalls = [responseObject objectForKey:@"linkOnTableBalls"];

    }
  return self;
}

#pragma mark - Mapping

+ (FEMMapping *) defaultMapping {
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:[InfoTVC_Model class]];
    
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"titleForWeInVK"       : @"titleForWeInVK",
                                            @"titleForMyStatistics" : @"titleForMyStatistics",
                                            @"titleForTableBalls"   : @"titleForTableBalls",
                                            @"linkOnWeInVK"         : @"linkOnWeInVK",
                                            @"linkOnTableBalls"     : @"linkOnTableBalls"
                                            }];
    return mapping;
}


-(NSString*) description {
    
    NSLog(@"\n\n\n\n\n\n");
    return [NSString stringWithFormat:@"TitleForVk = %@\n"
                                      @"TitleForMyStat = %@\n"
                                      @"TitleForTableBalls = %@\n"
                                      @"LinkOnVK = %@\n"
                                      @"LinkOnTableBalls = %@\n--------", self.titleForWeInVK,
                                                                          self.titleForMyStatistics,
                                                                          self.titleForTableBalls,
                                                                          self.linkOnWeInVK,
                                                                          self.linkOnTableBalls];
   
}


@end
