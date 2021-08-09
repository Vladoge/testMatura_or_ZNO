//
//  StatisticsTVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

// Network
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "ServerManager.h"

// Library
#import "ANHelperFunctions.h"
#import "MBProgressHUD.h"
#import "SCLAlertView.h"
#import "Chameleon.h"
#import "Utilities.h"
#import "SDImageCache.h"

// Cell
#import "ImgCell_StatisticsTVC.h"
#import "AvgScoresCell_StatisticsTVC.h"
#import "ShareCell_StatisticsTVC.h"

// Model
#import "User.h"
#import "EvaluatorResultTest.h"
#import "ShareData.h"

// Other
#import <Social/Social.h>


@interface StatisticsTVC : UITableViewController <MBProgressHUDDelegate, NYTPhotosViewControllerDelegate>

@property (strong, nonatomic) User* currentUser;
@property (strong, nonatomic) EvaluatorResultTest* currentEvalutorTest;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) ShareData* myShareData;

@end
