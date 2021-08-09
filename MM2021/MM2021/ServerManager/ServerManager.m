//
//  ServerManager.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "ServerManager.h"
#import "FEMDeserializer.h"
#import "Utilities.h"

#define email           @"gediti69@gmail.com"


@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *manager;
@property (strong, nonatomic) dispatch_queue_t requestQueue;

@end

@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        self.requestQueue = dispatch_queue_create("EGE_2017_Math.requestEGE", DISPATCH_QUEUE_PRIORITY_DEFAULT);
        
        self.manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"application/json", @"text/json",@"text/html", nil];
        
    }
    return self;
}



// 2.0
- (void) getListReduceVariants:(void(^)(NSArray* arrayReduceVariants)) success
                     onFailure:(void(^)(NSError* errorBlock, NSInteger statusCode, NSArray* localReduceVariants)) failure {
    
    
    NSString*     linkOnGitlab  = @"https://raw.githubusercontent.com/Vladoge/datas_matura/main/api.ege.Math_app/MainJSON.json";
    
    
    [self.manager GET:linkOnGitlab parameters:nil progress:nil success:^(NSURLSessionDataTask *  task, NSDictionary*   responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      success([self parseWithMapping:json andClassModel:[ReduceVariant class]]);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSDictionary* result = [Utilities getDictFromJSONFile:@"MainJSON" andExtensionWithPoint:@".json"];
                  if (result) {
                      failure(error, error.code, [self parseWithMapping:result andClassModel:[ReduceVariant class]]);
                  }
              }];
    
}

- (void) getFullVariantForLink:(NSString *)link
                     onSuccess:(void(^)(FullVariant* fVariant)) success
                     onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, FullVariant* fVariant)) failure {
    
    // NSLog(@"getFullVariantForLink-link = %@",link);
    
    [self.manager GET:link
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      success([self parseWithMapping:json andClassModel:[FullVariant class]]);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSDictionary* result = [Utilities getJSONDictionaryFromFileOnLink:link];
                  if (result) {
                      failure(error, error.code, [self parseWithMapping:result andClassModel:[FullVariant class]]);
                  }
              }];
}

- (void) getFullTaskForLink:(NSString *)link
                  onSuccess:(void(^)(FullTask* fTask)) success
                  onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, FullTask* fTask)) failure {
    
    //NSLog(@"getFullTaskForLink-link = %@",link);
    
    [self.manager GET:link
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      success([self parseWithMapping:json andClassModel:[FullTask class]]);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSDictionary* result = [Utilities getJSONDictionaryFromFileOnLink:link];
                  if (result) {
                      failure(error, error.code, [self parseWithMapping:result andClassModel:[FullTask class]]);
                  }
              }];
}

- (void) getResultEvaluatorModelWithEnumValue:(QualityExecutionTestEnum) qualityJob
                onTypeOfTheRequestedEvaluator:(TypeOfTheRequestedEvaluator) typeRequestedJSON
                                    onSuccess:(void(^)(EvaluatorResultTest* evaResultTest)) success
                                    onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, EvaluatorResultTest* evaResultTest)) failure {
    
    NSDictionary* dictLinks;
    
    if (typeRequestedJSON ==  forTheResultTest)
    {
        dictLinks = @{ [NSString stringWithFormat:@"%zd",qualityExcellent]  : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/Evaluator/ege.Math_Evalutor_1Excellent.json",
                       [NSString stringWithFormat:@"%zd",qualityGood]      : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/Evaluator/ege.Math_Evalutor_2Good.json",
                       [NSString stringWithFormat:@"%zd",qualityMedium]    : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/Evaluator/ege.Math_Evalutor_3Medium.json",
                       [NSString stringWithFormat:@"%zd",qualityBad]       : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/Evaluator/ege.Math_Evalutor_4Bad.json",
                       [NSString stringWithFormat:@"%zd",qualityVeryBad]   : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/Evaluator/ege.Math_Evalutor_5VeryBad.json" };
    } else if (typeRequestedJSON ==  forTheStatistics)
    {
        dictLinks = @{ [NSString stringWithFormat:@"%zd",qualityExcellent] : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/StatisticsEvaluator/ege.Math_StatEvaluator_1Excellent.json",
                       [NSString stringWithFormat:@"%zd",qualityGood]      : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/StatisticsEvaluator/ege.Math_StatEvaluator_2Good.json",
                       [NSString stringWithFormat:@"%zd",qualityMedium]    : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/StatisticsEvaluator/ege.Math_StatEvaluator_3Medium.json",
                       [NSString stringWithFormat:@"%zd",qualityBad]       : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/StatisticsEvaluator/ege.Math_StatEvaluator_4Bad.json",
                       [NSString stringWithFormat:@"%zd",qualityVeryBad]   : @"https://gitlab.com/thisismymail03/api.ege.Math_app/raw/master/StatisticsEvaluator/ege.Math_StatEvaluator_5VeryBad.json"  };
    }
    
    NSString* address = [dictLinks objectForKey:[NSString stringWithFormat:@"%ld",(long)qualityJob]];
    
    
    [self.manager GET:address
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  success([self helperParseResultEvaluators:json]);
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSDictionary* json = [Utilities getJSONDictionaryFromFileOnLink:address];
                  failure(error, error.code, [self helperParseResultEvaluators:json]);
              }];
}

-(void) getInfoModel:(void(^)(InfoTVC_Model* modelForTableView)) success
           onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, InfoTVC_Model* modelForTableView)) failure {
    
    // 1. Обновить API в проекте
    // 1. Update the API in the project
    // 1. Zaktualizuj API w projekcie
    NSString* link = @"https://raw.githubusercontent.com/Vladoge/datas_matura/main/api.ege.Math_app/JSON_InfoController/ege.Math_InfoController.json";
    
    
    [self.manager GET:link
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      success([self parseWithMapping:json andClassModel:[InfoTVC_Model class]]);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSDictionary* result = [Utilities getJSONDictionaryFromFileOnLink:link];
                  if (result) {
                      failure(error, error.code, [self parseWithMapping:result andClassModel:[InfoTVC_Model class]]);
                  }
              }];
}


- (void) getShareData:(void(^)(ShareData* sData)) success
            onFailure:(void(^)(NSError* errorBlock,  NSInteger statusCode, ShareData* sData)) failure {
    
    NSString* link = @"https://raw.githubusercontent.com/Vladoge/datas_matura/main/api.ege.Math_app/dataForShare.json";
    
    
    [self.manager GET:link
           parameters:nil
             progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  
                  NSDictionary *json = (NSDictionary *)responseObject;
                  if (json) {
                      success([self parseWithMapping:json andClassModel:[ShareData class]]);
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  
                  NSDictionary* result = [Utilities getJSONDictionaryFromFileOnLink:link];
                  if (result) {
                      failure(error, error.code, [self parseWithMapping:result andClassModel:[ShareData class]]);
                  }
              }];
}

#pragma mark - Server Helpers Method -

#pragma  mark - Helper ResultEvaluators

- (EvaluatorResultTest*) helperParseResultEvaluators:(NSDictionary*) json {
    
    if (json) {
        NSArray* arrEvaluator = [self parseWithMapping:json andClassModel:[EvaluatorResultTest class]];
        
        if (arrEvaluator.count > 1) {
            int fromNumber = 0;
            int toNumber   = (int)arrEvaluator.count;
            int randomNumber = (arc4random()%(toNumber-fromNumber))+fromNumber;
            
            return arrEvaluator[randomNumber];
        }
        return [arrEvaluator firstObject];
    }
    return nil;
}

#pragma mark - Helpers Method


- (id) parseWithMapping:(NSDictionary*) responDict andClassModel:(Class) modelClass {
    
    if ([modelClass isSubclassOfClass:[ReduceVariant class]]) {
        FEMMapping* objectMapping = [ReduceVariant defaultMapping];
        NSArray*    modelsArray   = [FEMDeserializer collectionFromRepresentation:responDict[@"variants"] mapping:objectMapping];
        return modelsArray;
    }
    
    if ([modelClass isSubclassOfClass:[FullVariant class]]) {
        
        FEMMapping *mapping = [FullVariant defaultMapping];
        FullVariant *fullVariant = [FEMDeserializer objectFromRepresentation:responDict mapping: mapping];
        return fullVariant;
    }
    
    if ([modelClass isSubclassOfClass:[FullTask class]]) {
        
        FEMMapping *mapping = [FullTask defaultMapping];
        FullTask *fullTask  = [FEMDeserializer objectFromRepresentation:responDict mapping: mapping];
        return fullTask;
    }
    
    if ([modelClass isSubclassOfClass:[EvaluatorResultTest class]]) {
        FEMMapping *mapping      = [EvaluatorResultTest defaultMapping];
        NSArray    *modelsArray  = [FEMDeserializer collectionFromRepresentation:responDict[@"evaluatorModels"] mapping:mapping];
        return modelsArray;
    }
    
    if ([modelClass isSubclassOfClass:[InfoTVC_Model class]]) {
        FEMMapping *mapping   = [InfoTVC_Model defaultMapping];
        InfoTVC_Model *modelForTableView = [FEMDeserializer objectFromRepresentation:responDict mapping: mapping];
        return modelForTableView;
    }
    
    if ([modelClass isSubclassOfClass:[ShareData class]]) {
        FEMMapping *mapping   = [ShareData defaultMapping];
        ShareData *shareData  = [FEMDeserializer objectFromRepresentation:responDict mapping: mapping];
        return shareData;
    }
    
    return @"Not found Classes Model";
}


@end
