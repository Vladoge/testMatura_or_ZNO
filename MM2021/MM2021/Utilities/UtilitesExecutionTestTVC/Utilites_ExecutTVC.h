//
//  Utilites_ExecutTVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
#import "Chameleon.h"
#import "MBProgressHUD.h"
#import "Utilities.h"

@import UIKit;

@interface Utilites_ExecutTVC : NSObject

+ (void) addConstraintToMyResult:(UIView*) myResult andSecondItem:(UIView*) selfView;
+ (void) addConstraintForProgressView:(UIProgressView*) progressView withNavContr:(UINavigationController*) navContr;


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
                                         withTimerButton:(UIBarButtonItem*) timerButton;

+ (NSArray*) getRectForShowTutorialWithTimerButton:(UIBarButtonItem*) timerButton
                                      withTextView:(UITextView*)  textView
                          withActionDirectionLabel:(UILabel*)     actionDirectionLabel
                           withExpectedAnswerField:(UITextField*) expectedAnswerField
                                    withNextButton:(UIButton*)    nextButton
                                    withBackButton:(UIButton*)    backButton
                                      withSelfView:(UIView*)        selfView
                                        withNavBar:(UINavigationBar*) navBar;



@end
