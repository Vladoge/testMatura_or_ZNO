//
//  FullVariant.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "FullVariant.h"

@implementation FullVariant


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject{
    
    self = [super init];
    if (self) {
        self.variantName            = [responseObject objectForKey:@"variantName"];
        self.variantDescription     = [responseObject objectForKey:@"variantDescription"];
        self.executionTimeInSeconds = [[responseObject objectForKey:@"executionTimeInSeconds"] floatValue];

        self.maxPrimaryBall = [[responseObject objectForKey:@"maxPrimaryBall"] integerValue];
        self.countTask      = [[responseObject objectForKey:@"countTask"] integerValue];
        self.variantImages  = [responseObject objectForKey:@"variantImages"];
        self.tasks          = [responseObject objectForKey:@"tasks"];
    }
    
    return self;
}

#pragma mark - Mapping

+ (FEMMapping *) defaultMapping {
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:[FullVariant class]];
    
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"variantName"        : @"variantName",
                                            @"variantDescription" : @"variantDescription",
                                            @"executionTimeInSeconds"  : @"executionTimeInSeconds",
                                            @"maxPrimaryBall"          : @"maxPrimaryBall",
                                            @"countTask"               : @"countTask",
                                            @"tasks"                   : @"tasks",
                                            @"variantImages"           : @"variantImages"
                                            }];
    return mapping;
}

#pragma mark - Helper methods


-(void) description {
    
    NSLog(@"\n\n\n\n\n\n");
    NSLog(@"variantName            = %@",self.variantName);
    NSLog(@"Desc                   = %@",self.variantDescription);
    NSLog(@"ExecutionTimeInSeconds = %f",self.executionTimeInSeconds);
    NSLog(@"MaxPrimaryBall  = %ld ",(long)self.maxPrimaryBall);
    NSLog(@"CountTask       = %ld ",(long)self.countTask);
    NSLog(@"Tasks           = %@ ",self.tasks);
    NSLog(@"VariantsImages  = %@",self.variantImages);
}



@end
