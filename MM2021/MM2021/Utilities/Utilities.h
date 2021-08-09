//
//  Utilities.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <Foundation/Foundation.h>
@import UIKit;

#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <SystemConfiguration/SCNetworkReachability.h>

#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import "ResultOfTheAssignmentView.h"

// Model
#import "PhotoModel.h"
#import "User.h"

#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SDImageCache.h"

static NSString* kUserInfo = @"kUserInfo";

@interface Utilities : NSObject


#pragma mark - Frames & Bounds

    //---- Используем для окраски navBar и StatusBar ----//
    // ---- Use navBar and StatusBar for coloring ---- //
+ (CGRect) getFrameStatusBarWithNavBar:(UINavigationBar*) navBar;

    //---- Расчет высоты - Не используем ----//
    // ---- Calculation of height - Don't use ---- //
+ (CGFloat)getLabelHeight:(UILabel*)label;
    // ---- Take self.view and subtract navBar.frame & status.frame from it ---- //
+ (CGRect) getFreeSpaceWithOut_NavAndStatusBar:(UINavigationBar*) navBar;
    //---- Берет self.view и вычитает из нее navBar.frame ----//
    // ---- Take self.view and subtract navBar.frame from it ---- //
+ (CGRect) getFreeSpaceWithOut_NavBar:(UINavigationBar*) navBar;
    //---- Возвращает размеры вьюхи результата тестирования ----//
    // ---- Returns the dimensions of the test result view ---- //
+ (CGRect) getRectForResultOfTheAssignmentView:(CGRect) viewFrame withNavBar:(UINavigationBar*) navBar;
    //---- Возвращает кооринаты кнопки на navigation bar ----//
    // ---- Returns the coordinates of the button on the navigation bar ---- //
    
+ (CGRect) getBarItemRc :(UIBarButtonItem *)item;


#pragma mark - Files

// ---- Достаем файлы локально ---- //
// ---- Get files locally ---- //
+ (NSData*) getFileFromOnLink:(NSString*) link;
+ (NSDictionary*) getJSONDictionaryFromFileOnLink:(NSString*) link;
+ (NSDictionary*) getDictFromJSONFile:(NSString*) nameFile andExtensionWithPoint:(NSString*) extension;



#pragma mark - Models

+ (void) writeUser:(User*) user;
+ (User*) readUserWithKey;



#pragma mark - Work with Images

+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

+ (UIImage*) changeColorFromUIColor:(UIColor*) color withImg:(UIImage*) img;

// --- Insert Photo For HPTextViewTapGestureRecognizerDelegate --- //
+ (void) insertPhotoFromArray:(NSArray*) arrImg withSelfPhotosArr:(NSMutableArray*) photos withTextView:(UITextView*) textView addInTop:(BOOL) addPhotoInTop andSelfView:(UIView*) selfView;


#pragma mark - Init UI Component

+ (UIAlertController*) getUIAlertViewControllerWithTitle:(NSString*) title andMessage:(NSString*) message;
/*
+ (MWPhotoBrowser*) getPhotoBrowserWithPhotos:(NSArray*) arrPhotos;
+ (MWPhotoBrowser*) getPhotoBrowserWithDelegate:(id <MWPhotoBrowserDelegate>) delegate;
*/
+ (void) toEmptyTheEntireInterface:(NSArray*) arrUI;

// --- Add Custom Back Button In Navigation Controller --- //
+ (void) setBackButtonInNavigationBarWithController:(id) controller withNavigationItem:(UINavigationItem*) navItem  sel:(SEL) selector;

// ---  Constraint ---- ///
+ (void) addConstraintToCenterXandCenterY:(id) firstItem andSecondItem:(id) secondItem;

#pragma mark - Action

+ (NSArray*) divideStringIntoIndividualCharacters:(NSString*) str;

+ (BOOL) isInternetConnection;

@end







