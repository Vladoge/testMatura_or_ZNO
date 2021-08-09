//
//  EvaluatorResultTest.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "FEMMapping.h"

// Add Key For dict 

#define kSmallImg   @"smallImg"
#define kMiddleImg  @"middleImg"
#define kBigImg     @"bigImg"

@interface EvaluatorResultTest : NSObject

@property (nonatomic, strong) NSString* phrase;
@property (nonatomic, strong) NSDictionary* imagesForiPhoneDevice;
@property (nonatomic, strong) NSDictionary* imagesForiPadDevice;

- (NSString*) description;
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;
+ (FEMMapping *)defaultMapping;

@end
