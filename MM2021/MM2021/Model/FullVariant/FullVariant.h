//
//  FullVariant.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "FEMMapping.h"

@interface FullVariant : NSObject

@property (nonatomic, strong) NSString* variantName;
@property (nonatomic, strong) NSString* variantDescription;
@property (nonatomic, assign) float  executionTimeInSeconds;

@property (nonatomic, assign) NSInteger maxPrimaryBall;
@property (nonatomic, assign) NSInteger countTask;
@property (nonatomic, strong) NSArray*  tasks;
@property (nonatomic, strong) NSDictionary* variantImages;

- (void) description;
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;

+ (FEMMapping *)defaultMapping;

@end
