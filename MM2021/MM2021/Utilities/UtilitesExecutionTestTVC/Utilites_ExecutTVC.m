//
//  Utilites_ExecutTVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "Utilites_ExecutTVC.h"

@implementation Utilites_ExecutTVC

+ (void) addConstraintToMyResult:(UIView*) myResult andSecondItem:(UIView*) selfView {
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:myResult
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:CGRectGetWidth(myResult.frame)]];
    
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:myResult
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:CGRectGetHeight(myResult.frame)]];
    // Center horizontally
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:myResult
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:selfView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
    // Center vertically
    [selfView addConstraint:[NSLayoutConstraint constraintWithItem:myResult
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:selfView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
}



+ (void) addConstraintForProgressView:(UIProgressView*) progressView withNavContr:(UINavigationController*) navContr {
    
    NSLayoutConstraint* bottomConstraint = [NSLayoutConstraint constraintWithItem:navContr.navigationBar
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:progressView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    NSLayoutConstraint* leftConstraint = [NSLayoutConstraint constraintWithItem:navContr.navigationBar
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:progressView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1
                                                                       constant:0];
    
    NSLayoutConstraint* rightConstraint = [NSLayoutConstraint constraintWithItem:navContr.navigationBar
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:progressView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1
                                                                        constant:0];
    
    progressView.translatesAutoresizingMaskIntoConstraints = FALSE;
    [navContr.view addConstraints:@[bottomConstraint, leftConstraint, rightConstraint]];
}


+ (void) partialConfigurationUI_ForControllerWithTopView:(UIView*) topView
                                 withDownView:(UIView*) downView
                                 withSelfView:(UIView*) selfView
                                withTableView:(UITableView*) tableView
                                 withTextView:(UITextView*) textView
                     withActionDirectionLabel:(UILabel*)    actionDirectionLabel
                               withNextButton:(UIButton*)   nextButton
                               withBackButton:(UIButton*)   backButton
                         withShowAnswerButton:(UIButton*)   showAnswerButton
                      withExpectedAnswerField:(UITextField*) expectedAnswerField
                           withDarkShadowView:(UIView*) darkShadowView
                                      withHUD:(MBProgressHUD*) HUD
                           withRefreshControl:(UIRefreshControl*) refreshControl
                              withTimerButton:(UIBarButtonItem*) timerButton {
    
    // Setup View
    topView.backgroundColor = downView.backgroundColor = [UIColor colorWithHexString:@"fef0e5"];
    
    // Setup TextView
    textView.editable = NO;
    textView.font     = [UIFont fontWithName:@"SFUIDisplay-Light" size:18.f];
    //self.textView.backgroundColor = [UIColor colorWithHexString:@"f5f0ec"];
    textView.layer.borderWidth = 2.5f;
    textView.layer.borderColor = [UIColor colorWithHexString:@"f5e7de"].CGColor;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius  = 5.f;
    //[self.textView setContentOffset:CGPointZero animated:NO];
    [textView scrollRangeToVisible:NSMakeRange(0, 1)];
    
    
    // Setup ActionDirection
    //self.actionDirectionLabel.backgroundColor = [UIColor colorWithHexString:@"f5f0ec"]; // desert color
    actionDirectionLabel.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"]; // gray color
    
    actionDirectionLabel.layer.shadowColor = [[UIColor flatGrayColor] CGColor];
    actionDirectionLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    actionDirectionLabel.layer.shadowOpacity = 1.0f;
    actionDirectionLabel.layer.shadowRadius = 1.0f;
    
    // Next Button
    nextButton.titleLabel.font     = [UIFont fontWithName:@"System" size:17.0];
    nextButton.backgroundColor     = [UIColor colorWithHexString:@"25d87a"];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius  = 7.f;
    
    // Back Button
    backButton.titleLabel.font     = [UIFont fontWithName:@"System" size:17.0];
    backButton.backgroundColor     = [UIColor colorWithHexString:@"ecdfd6"];  // grown
    [backButton setTitleColor:[UIColor colorWithHexString:@"77726c"] forState:UIControlStateNormal];
    backButton.layer.masksToBounds = YES;
    backButton.layer.cornerRadius  = 7.f;
    
    // Show Answer Button
 
    showAnswerButton.titleLabel.font     = [UIFont fontWithName:@"System" size:17.0];
    showAnswerButton.backgroundColor     = [UIColor colorWithHexString:@"fe4e72"]; // light red
    [showAnswerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    showAnswerButton.layer.masksToBounds = YES;
    showAnswerButton.layer.cornerRadius  = 5.f;
    
    // UITextField
    expectedAnswerField.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    UIColor *placeholderFieldColor = [UIColor colorWithHexString:@"bfbec3"];
    expectedAnswerField.attributedPlaceholder =  [[NSAttributedString alloc] initWithString:expectedAnswerField.placeholder attributes:@{NSForegroundColorAttributeName: placeholderFieldColor}];
    
    
    // Dark Shadow View For ResultView
    darkShadowView.backgroundColor = [UIColor blackColor];
    darkShadowView.alpha = 0.5;
    darkShadowView.translatesAutoresizingMaskIntoConstraints = NO;
    darkShadowView.hidden = YES;

     // Initialize the MBProgressHUD
     HUD.labelText        = @" Downloading the task...";
     HUD.mode = MBProgressHUDModeIndeterminate;

     // Initialize the refresh control.

     refreshControl.backgroundColor = [UIColor flatGrayColor];
     refreshControl.tintColor = [UIColor whiteColor];
    
    // Timer UIBarButtonItem
    [timerButton  setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"SFUIDisplay-Light" size:25.0], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName, nil]
                                         forState:UIControlStateNormal];

}

+ (NSArray*) getRectForShowTutorialWithTimerButton:(UIBarButtonItem*) timerButton
                                      withTextView:(UITextView*)  textView
                          withActionDirectionLabel:(UILabel*)     actionDirectionLabel
                           withExpectedAnswerField:(UITextField*) expectedAnswerField
                                    withNextButton:(UIButton*)    nextButton
                                    withBackButton:(UIButton*)    backButton
                                      withSelfView:(UIView*)        selfView
                                        withNavBar:(UINavigationBar*) navBar
{
        float radius = 5.f;
        float heightNavAndStatusBar = CGRectGetHeight(navBar.bounds) + CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        // Timer
        CGRect coachmarkTimerButton       = [Utilities getBarItemRc:timerButton];
        coachmarkTimerButton.origin.y    += CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
        coachmarkTimerButton.origin.x    -= radius;
        coachmarkTimerButton.size.height += radius;
        coachmarkTimerButton.size.width  += (radius * 2);
        
        // TextView
        CGRect coachmarkTextView    = [textView   convertRect:textView.bounds  toView:selfView];
        coachmarkTextView.origin.y += heightNavAndStatusBar;
        coachmarkTextView.origin.y     -=  (radius * 1);
        coachmarkTextView.origin.x     -=  (radius * 1.5);
        coachmarkTextView.size.height  +=  (radius * 2);
        coachmarkTextView.size.width   +=  (radius * 4);
        
        
        
        // UILabel
        CGRect coachmarkActionLabel        = [actionDirectionLabel   convertRect:actionDirectionLabel.bounds  toView:selfView];
        coachmarkActionLabel.origin.y     += heightNavAndStatusBar;
        coachmarkActionLabel.origin.y     -=  (radius * 1);
        coachmarkActionLabel.origin.x     -=  (radius * 1.5);
        coachmarkActionLabel.size.height  +=  (radius * 2);
        coachmarkActionLabel.size.width   +=  (radius * 4);
        
        
        // TextField
        CGRect coachmarkTextField        = [expectedAnswerField convertRect:expectedAnswerField.bounds  toView:selfView];
        coachmarkTextField.origin.y     += heightNavAndStatusBar;
        coachmarkTextField.origin.y     -=  (radius * 1);
        coachmarkTextField.origin.x     -=  (radius * 1.5);
        coachmarkTextField.size.height  +=  (radius * 2);
        coachmarkTextField.size.width   +=  (radius * 4);
        
        // Next Button
        CGRect coachmarkNextButton        = [nextButton convertRect:nextButton.bounds toView:selfView];
        coachmarkNextButton.origin.y     += heightNavAndStatusBar;
        coachmarkNextButton.origin.y     -=  (radius * 1);
        coachmarkNextButton.origin.x     -=  (radius * 1.5);
        coachmarkNextButton.size.height  +=  (radius * 2);
        coachmarkNextButton.size.width   +=  (radius * 4);
        
        // Back Button
        CGRect coachmarkBackButton        =  [backButton convertRect:backButton.bounds toView:selfView];
        coachmarkBackButton.origin.y     += heightNavAndStatusBar;
        
        coachmarkBackButton.origin.y     -=  (radius * 1);
        coachmarkBackButton.origin.x     -=  (radius * 1.5);
        coachmarkBackButton.size.height  +=  (radius * 2);
        coachmarkBackButton.size.width   +=  (radius * 4);
        
        // Setup coach marks
        NSArray *coachMarks = @[
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkTimerButton],
                                    @"caption": @"Test time",
                                    @"shape"  : @"other"
                                    },
                                
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkTextView],
                                    @"caption": @"The main task",
                                    @"shape": @"square"
                                    },
                                
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkActionLabel],
                                    @"caption": @"Explanation of the task",
                                    @"shape": @"other"
                                    },
                                
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkTextField],
                                    @"caption": @"Answer input field",
                                    @"shape": @"other"
                                    },
                                
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkNextButton],
                                    @"caption": @"Go to the next task",
                                    @"shape": @"other"
                                    },
                                
                                @{
                                    @"rect": [NSValue valueWithCGRect:coachmarkBackButton],
                                    @"caption": @"Return to the previous task",
                                    @"shape": @"other"
                                    }
                                
                                ];
    return coachMarks;
}
@end
