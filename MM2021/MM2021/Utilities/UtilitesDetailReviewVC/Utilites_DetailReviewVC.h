//
//  Utilites_DetailReviewVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>

@import UIKit;
@interface Utilites_DetailReviewVC : NSObject

+ (void) addContraintForYourAnswLabel:(UILabel*) yourAnswLabel withSelfView:(UIView*) selfView;
+ (void) addConstraintForTextView:(UITextView*) textView withSelfView:(UIView*) selfView andYourAnswLabel:(UILabel*) yourAnswLabel;

@end
