//
//  ExecutionTestVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

// Fraemworks
#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "Reachability.h"
#import "ANHelperFunctions.h"
#import "MBProgressHUD.h"
#import "SCLAlertView.h"
#import "Chameleon.h"
#import "Utilities.h"
#import "Utilites_ExecutTVC.h"
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "PhotoModel.h"


#import "SDImageCache.h"
#import "HPTextViewTapGestureRecognizer.h"

// Tutorials
#import "WSCoachMarksView.h"

// ServerManager & Network configuration
#import "ServerManager.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>


// Model
#import "ReduceVariant.h"
#import "FullVariant.h"
#import "FullTask.h"
#import "TmpTaskStatictics.h"
#import "YourAnswerAndTaskModel.h"
#import "User.h"

// View
#import "ResultOfTheAssignmentView.h"
#import "UIView+DCAnimationKit.h"

// Controllers
#import "DetailAnalyticsTaskTVC.h"

@import CoreText;


@interface ExecutionTestTVC : UITableViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, WSCoachMarksViewDelegate,
                                                     UITextFieldDelegate, MBProgressHUDDelegate,HPTextViewTapGestureRecognizerDelegate, NYTPhotosViewControllerDelegate>

// Pass Data
@property (strong, nonatomic) NSString* linkOnFullVariantModel;
@property (assign, nonatomic) BOOL rotateVC;

// UI
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *downView;

@property (weak, nonatomic) IBOutlet UITextView*  textView;
@property (weak, nonatomic) IBOutlet UITextField* expectedAnswerField;
@property (weak, nonatomic) IBOutlet UILabel*  actionDirectionLabel;

@property (weak, nonatomic) IBOutlet UIButton *showAnswerButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) ResultOfTheAssignmentView* myViewResult;
@property (strong, nonatomic) UIView* darkShadowView;

@property (nonatomic, strong) UIBarButtonItem* timerButton;
@property (nonatomic, strong) UIBarButtonItem* tutorialButton;

// Data UI
@property (assign, nonatomic) BOOL alreadyWriteAnswerInUserModel;
@property (assign, nonatomic) NSInteger heightCell;
@property (assign, nonatomic) float stepForProgressView;
@property (strong, nonatomic) HPTextViewTapGestureRecognizer *textViewTapGestureRecognizer;
@property (strong, nonatomic) NSMutableArray *photos;
// -- Timer
@property (strong, nonatomic) NSTimer*  timer;
@property (assign, nonatomic) float     secondsOfExecutionTimeTest;

// Data model
@property (strong, nonatomic) FullVariant* fullVariant;
@property (strong, nonatomic) TmpTaskStatictics* collectorOfStatVar;

@property (strong, nonatomic) NSMutableArray* arrYourAnswer;
@property (strong, nonatomic) YourAnswerAndTaskModel* currentYourAnswerAndModel;



@end
