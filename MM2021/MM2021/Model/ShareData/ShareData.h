//
//  ShareData.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "FEMMapping.h"

@interface ShareData : NSObject

@property (nonatomic, strong) NSString* mainText;
@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* link;

- (void) description;
- (instancetype) initWithServerResponse:(NSDictionary*) responseObject;
+ (FEMMapping *)defaultMapping;

@end
