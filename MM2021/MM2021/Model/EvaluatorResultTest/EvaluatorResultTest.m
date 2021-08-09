//
//  EvaluatorResultTest.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "EvaluatorResultTest.h"

@implementation EvaluatorResultTest


-(instancetype) initWithServerResponse:(NSDictionary*) responseObject {
    
    self = [super init];
    if (self) {
        
        self.phrase                = [responseObject objectForKey:@"phrase"];
        self.imagesForiPhoneDevice = [responseObject objectForKey:@"imagesForiPhoneDevice"];
        self.imagesForiPadDevice   = [responseObject objectForKey:@"imagesForiPadDevice"];
        // Проверить не nil ли тут словарь !
        // Sprawdź, czy słownik jest  nil!
    }
    return self;
}

#pragma mark - Mapping

+ (FEMMapping *)defaultMapping
{
    FEMMapping *mapping = [[FEMMapping alloc] initWithObjectClass:[EvaluatorResultTest class]];
    // property from nsobject : keypath from json
    [mapping addAttributesFromDictionary:@{ @"phrase"                 : @"phrase",
                                            @"imagesForiPhoneDevice"  : @"imagesForiPhoneDevice",
                                            @"imagesForiPadDevice"    : @"imagesForiPadDevice"
                                            }];
    return mapping;
}

#pragma mark - Helper methods

- (NSString*) description {
    return [NSString stringWithFormat:@"Phrase = %@\nImagesForiPhoneDevice = %@\nImagesForiPadDevice = %@",self.phrase, self.imagesForiPhoneDevice, self.imagesForiPadDevice];
}

@end
