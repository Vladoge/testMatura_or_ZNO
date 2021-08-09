//
//  DetailReviewTaskVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

#import "ANHelperFunctions.h"
#import "MBProgressHUD.h"
#import "SCLAlertView.h"
#import "Chameleon.h"
#import "Utilities.h"


#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "PhotoModel.h"


#import "SDImageCache.h"
#import "HPTextViewTapGestureRecognizer.h"

// Model
#import "FullVariant.h"
#import "FullTask.h"
#import "YourAnswerAndTaskModel.h"

//Utilites
#import "Utilites_DetailReviewVC.h"
#import "Utilities.h"

@import CoreText;

@interface DetailReviewTaskVC : UIViewController <MBProgressHUDDelegate, HPTextViewTapGestureRecognizerDelegate>

@property (strong, nonatomic) YourAnswerAndTaskModel* currentYourAnswerAndModel;
@property (strong, nonatomic) HPTextViewTapGestureRecognizer *textViewTapGestureRecognizer;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UITextView* textView;
@property (strong, nonatomic) UILabel*    yourAnswLabel;

@end
