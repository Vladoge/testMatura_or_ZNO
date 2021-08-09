//
//  ReduceVariant.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "ReduceVariant.h"

@implementation ReduceVariant

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
            self.variantName        = [responseObject objectForKey:@"variantName"] ;
            self.variantDescription = [responseObject objectForKey:@"variantDescription"];
            self.linkOnFullVariant  = [responseObject objectForKey:@"linkOnFullVariant"];
            self.variantImages      = [responseObject objectForKey:@"variantImages"];
    }
    return self;
}

#pragma mark - Mapping

+ (FEMMapping *) defaultMapping {
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:[ReduceVariant class]];
    
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"variantName"        : @"variantName",
                                            @"variantDescription" : @"variantDescription",
                                            @"linkOnFullVariant"  : @"linkOnFullVariant",
                                            @"variantImages"      : @"variantImages"
                                            }];
    
    return mapping;
}


#pragma mark - Helper methods


-(void) description {
    
    NSLog(@"\n\n\n\n\n\n");
    NSLog(@"Name        = %@",self.variantName);
    NSLog(@"Desc        = %@",self.variantDescription);
    NSLog(@"Link        = %@",self.linkOnFullVariant);
    NSLog(@"ImagesDict  = %@ ",self.variantImages);
    
}

@end
