//
//  ServerManager.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

// Model
#import "ReduceVariant.h"
#import "FullVariant.h"
#import "FullTask.h"
#import "EvaluatorResultTest.h"
#import "InfoTVC_Model.h"
#import "ShareData.h"


typedef NS_ENUM(NSInteger, TypeOfTheRequestedEvaluator) {
    forTheResultTest = 1,
    forTheStatistics = 2,
};

typedef NS_ENUM(NSInteger, QualityExecutionTestEnum) {
    qualityExcellent = 1,
    qualityGood      = 2,
    qualityMedium    = 3,
    qualityBad       = 4,
    qualityVeryBad   = 5
};


@interface ServerManager : NSObject

+ (ServerManager*) sharedManager;

//----- ReduceVariant -----//
- (void) getListReduceVariants:(void(^)(NSArray* arrayReduceVariants)) success
                     onFailure:(void(^)(NSError* errorBlock, NSInteger statusCode, NSArray* localReduceVariants)) failure;

//----- FullVariant -----//
- (void) getFullVariantForLink:(NSString *)link
                     onSuccess:(void(^)(FullVariant* fVariant)) success
                     onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, FullVariant* fVariant)) failure;

//----- FullTask -----//
- (void) getFullTaskForLink:(NSString *)link
                  onSuccess:(void(^)(FullTask* fTask)) success
                  onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, FullTask* fTask)) failure;

//----- EvaluatorResultTest -----//
- (void) getResultEvaluatorModelWithEnumValue:(QualityExecutionTestEnum) qualityJob
                onTypeOfTheRequestedEvaluator:(TypeOfTheRequestedEvaluator) typeRequestedJSON
                                    onSuccess:(void(^)(EvaluatorResultTest* evaResultTest)) success
                                    onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, EvaluatorResultTest* evaResultTest)) failure;

//----- InfoTVC_Model -----//
- (void) getInfoModel:(void(^)(InfoTVC_Model* modelForTableView)) success
            onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, InfoTVC_Model* modelForTableView)) failure;

//----- ShareData -----//
- (void) getShareData:(void(^)(ShareData* sData)) success
            onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, ShareData* sData)) failure;

@end



