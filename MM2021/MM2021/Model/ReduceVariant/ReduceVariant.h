//
//  ReduceVariant.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "FEMMapping.h"

@interface ReduceVariant : NSObject

@property (nonatomic, strong) NSString* variantName;
@property (nonatomic, strong) NSString* variantDescription;
@property (nonatomic, strong) NSString* linkOnFullVariant;
@property (nonatomic, strong) NSDictionary* variantImages;

- (void) description;
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;

+ (FEMMapping *)defaultMapping;

@end
