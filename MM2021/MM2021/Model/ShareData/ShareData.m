//
//  ShareData.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "ShareData.h"

@implementation ShareData

-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
         self.mainText  = [responseObject objectForKey:@"mainText"];
         self.imageURL = [responseObject objectForKey:@"imageURL"];
         self.link     = [responseObject objectForKey:@"link"];
    }
    return self;
}

#pragma mark - Mapping

+ (FEMMapping *) defaultMapping {
    FEMMapping* mapping = [[FEMMapping alloc] initWithObjectClass:[ShareData class]];
    
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"mainText" : @"mainText",
                                            @"imageURL" : @"imageURL",
                                            @"link"     : @"link"
                                            }];
    return mapping;
}


#pragma mark - Helper methods
-(void) description {
    NSLog(@"\n\n\n\n\n\n");
    NSLog(@"MainText  = %@",self.mainText);
    NSLog(@"ImageURL  = %@",self.imageURL);
    NSLog(@"Link      = %@",self.link);
}

@end
