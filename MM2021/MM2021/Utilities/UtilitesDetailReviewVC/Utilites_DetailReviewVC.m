//
//  Utilites_DetailReviewVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "Utilites_DetailReviewVC.h"

@implementation Utilites_DetailReviewVC

+ (void) addContraintForYourAnswLabel:(UILabel*) yourAnswLabel withSelfView:(UIView*) selfView {
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:yourAnswLabel
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem: nil
                                                          attribute: NSLayoutAttributeNotAnAttribute
                                                         multiplier: 1
                                                           constant:CGRectGetHeight(yourAnswLabel.bounds)]];
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:yourAnswLabel
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:selfView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:10]];
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:yourAnswLabel
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:selfView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:-10]];
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:yourAnswLabel
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:selfView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-10]];
}

+ (void) addConstraintForTextView:(UITextView*) textView withSelfView:(UIView*) selfView andYourAnswLabel:(UILabel*) yourAnswLabel{
 
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:textView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:selfView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:10]];
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:textView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:selfView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:-10]];
    
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:textView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:selfView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:10]];
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:textView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:yourAnswLabel
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:-10]];
}

@end
