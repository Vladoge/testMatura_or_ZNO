//
//  ResultOfTheAssignmentView.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "Utilities.h"
#import "ANHelperFunctions.h"

#import "SDImageCache.h"
#import "SDImageCache.h"

#import "ServerManager.h"
#import "EvaluatorResultTest.h"

@interface ResultOfTheAssignmentView : UIView

@property (weak, nonatomic) IBOutlet UILabel *statusOfTestExecutionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageEvaluatingTestResults;

@property (weak, nonatomic) IBOutlet UILabel *numberOfCorrectAnswerLabel;
@property (weak, nonatomic) IBOutlet UIButton *goToDetailReviewButton;
@property (weak, nonatomic) IBOutlet UILabel *primaryScoresLabel;

@property (strong, nonatomic) EvaluatorResultTest* modelEvaluator;

+ (instancetype)myView:(NSString*) nameXib withFrame:(CGRect) rect;


@end
