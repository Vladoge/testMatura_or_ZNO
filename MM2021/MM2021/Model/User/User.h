//
//  User.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger numberOfExecutedVariants;
@property (nonatomic, assign) NSInteger primaryAverageScore;

-(NSString*) description;
@end
