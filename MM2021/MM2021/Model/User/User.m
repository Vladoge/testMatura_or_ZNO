//
//  User.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "User.h"

@implementation User

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self != nil) {
        
        self.numberOfExecutedVariants = [aDecoder decodeIntegerForKey:@"kNumberOfExecutedVariants"];
        self.primaryAverageScore      = [aDecoder decodeIntegerForKey:@"kPrimaryAverageScore"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeInteger:[self numberOfExecutedVariants] forKey:@"kNumberOfExecutedVariants"];
    [aCoder encodeInteger:[self primaryAverageScore]      forKey:@"kPrimaryAverageScore"];
}


-(NSString*) description {
    return [NSString stringWithFormat:@"numberOfExecutedVariants = %ld\nprimaryAverageScore = %ld",
                            (long)self.numberOfExecutedVariants,
                            (long)self.primaryAverageScore];
}
@end
