//
//  DetailAnalyticsTaskTVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

#import "Reachability.h"
#import "ANHelperFunctions.h"
#import "MBProgressHUD.h"
#import "SCLAlertView.h"
#import "Utilities.h"
#import "Chameleon.h"

#import "UIView+SuperTableViewCell.h"

// Model
#import "FullTask.h"
#import "YourAnswerAndTaskModel.h"

// Cell
#import "DetailAnalyticsCell.h"

// Controller
#import "DetailReviewTaskVC.h"

@import CoreText;

@interface DetailAnalyticsTaskTVC : UITableViewController

@property (strong, nonatomic) NSMutableArray* arrYourAnswer;

@end
