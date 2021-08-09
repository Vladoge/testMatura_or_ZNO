//
//  MainTVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

//#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

//Fraemworks
#import "ANHelperFunctions.h"
#import "MBProgressHUD.h"
#import "SCLAlertView.h"
#import "Chameleon.h"
#import "UIColor+Chameleon.h"
#import "Utilities.h"

// ServerManager
#import "ServerManager.h"

// Model
#import "ReduceVariant.h"

//Controllers
#import "ExecutionTestTVC.h"
#import "InfoAppTVC.h"

// Category
#import "UIImage+imageWithColor.h"


@interface MainTVC : UITableViewController  <UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>

@end
