   //
//  Utilities.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "Utilities.h"

@implementation Utilities


#pragma mark - Frames & Bounds

+(CGRect) getFrameStatusBarWithNavBar:(UINavigationBar*) navBar {
    
   return  CGRectMake(0, 0,  [UIApplication sharedApplication].statusBarFrame.size.width,
                             CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) +
                             CGRectGetHeight(navBar.frame));
}

+ (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}



+ (CGRect) getFreeSpaceWithOut_NavAndStatusBar:(UINavigationBar*) navBar {

    if ([UIApplication sharedApplication].isStatusBarHidden) {
        [[UIApplication sharedApplication]setStatusBarHidden:NO];
    }

    CGRect statusBarFrame =   [UIApplication sharedApplication].statusBarFrame;
    CGRect navBarFrame    =   navBar.frame;
    CGRect screenFrame    =   [[UIScreen mainScreen] bounds];
    
    CGRect freeSpace = CGRectMake(0, 0,
                                  CGRectGetWidth(navBar.frame),
                                  CGRectGetHeight(screenFrame) - (CGRectGetHeight(statusBarFrame)+ CGRectGetHeight(navBarFrame)) );
    return freeSpace;
}


+ (CGRect) getFreeSpaceWithOut_NavBar:(UINavigationBar*) navBar {
    
    // For Landscape
    if (![UIApplication sharedApplication].isStatusBarHidden) {
        [[UIApplication sharedApplication]setStatusBarHidden:YES];
    }
    
    CGRect navBarFrame    =   navBar.frame;
    CGRect screenFrame    =   [[UIScreen mainScreen] bounds];
    
    CGRect freeSpace = CGRectMake(0, 0,
                                  CGRectGetWidth(navBar.frame),
                                  CGRectGetHeight(screenFrame) -  CGRectGetHeight(navBarFrame));
    return freeSpace;
}

+ (CGRect) getRectForResultOfTheAssignmentView:(CGRect) viewFrame withNavBar:(UINavigationBar*) navBar {
    
    CGFloat oneProcent_W = (CGRectGetWidth(viewFrame) / 100);
    CGFloat tenProcent_W = (oneProcent_W * 10);
    CGFloat eightyProcent_W = (oneProcent_W * 80);
    
    CGRect rectForView = CGRectZero;
    
    if (navBar) {
        
        CGRect statusBarFrame =   [UIApplication sharedApplication].statusBarFrame;
        CGRect navBarFrame    =   navBar.frame;
        
        CGFloat heightStatusBar = CGRectGetHeight(statusBarFrame);
        CGFloat heightNavBar    = CGRectGetHeight(navBarFrame);
        CGFloat heigthStatusNavBars = (heightStatusBar + heightNavBar);
        
        // 4.
        CGFloat oneProcentWithOutNavBar_H = ((CGRectGetHeight(viewFrame) - heigthStatusNavBars)/100);
        //CGFloat tenProcentWithOutNavBar_H = (oneProcentWithOutNavBar_H * 10);
        //CGFloat yCoord_WithOutNavBar_H    = (tenProcentWithOutNavBar_H + heigthStatusNavBars);
        CGFloat yCoord_WithOutNavBar_H    = heigthStatusNavBars;
        
        CGFloat eightyProcentWithOutNavBar_H = (oneProcentWithOutNavBar_H * 80);
        
        rectForView = CGRectMake(tenProcent_W, yCoord_WithOutNavBar_H, eightyProcent_W, eightyProcentWithOutNavBar_H);
    } else {
        
        CGFloat oneProcent_SimpleView_H = (CGRectGetHeight(viewFrame)/100);
        CGFloat tenProcent_SimpleView_H = (oneProcent_SimpleView_H * 10);
        CGFloat eightyProcent_SimpleView_H = (oneProcent_SimpleView_H * 80);
        
        rectForView = CGRectMake(tenProcent_W, tenProcent_SimpleView_H, eightyProcent_W, eightyProcent_SimpleView_H);
    }
    
    return rectForView;
}

+ (CGRect) getBarItemRc :(UIBarButtonItem *)item{
    UIView *view = [item valueForKey:@"view"];
    return [view frame];
}




#pragma mark - Files


+ (NSData*) getFileFromOnLink:(NSString*) link {
    
    NSRange searchSlashRange          = [link rangeOfString:@"/" options:NSCaseInsensitiveSearch|NSBackwardsSearch];
    NSRange searchExtensionPointRange = [link rangeOfString:@"." options:NSCaseInsensitiveSearch|NSBackwardsSearch];
    NSString* nameFile = nil;
    NSString* extensionFile = nil;
    
    if ((searchSlashRange.location && searchExtensionPointRange.location) != NSNotFound) {
        NSUInteger lenghtNameFile = searchExtensionPointRange.location - searchSlashRange.location;
        //nameFile      = [link substringWithRange:NSMakeRange(searchSlashRange.location, lenghtNameFile)];
        // Захват слэша
        // Capture slash
        nameFile      = [link substringWithRange:NSMakeRange(searchSlashRange.location+1, lenghtNameFile-1)];
        extensionFile = [link substringFromIndex:searchExtensionPointRange.location];
    }
    
    NSString* filePath   = [[NSBundle mainBundle] pathForResource:nameFile ofType:extensionFile];
    NSData*   data       = [NSData dataWithContentsOfFile:filePath];
    
    return  (data) ? data : nil;
}

//  Вытаскиваем локально, но уже из url адресса
// We pull it out locally, but already from the url address
+ (NSDictionary*) getJSONDictionaryFromFileOnLink:(NSString*) link {
    NSRange searchSlashRange          = [link rangeOfString:@"/" options:NSCaseInsensitiveSearch|NSBackwardsSearch];
    NSRange searchExtensionPointRange = [link rangeOfString:@"." options:NSCaseInsensitiveSearch|NSBackwardsSearch];
    NSString* nameFile = nil;
    
    if ((searchSlashRange.location && searchExtensionPointRange.location) != NSNotFound) {
        NSUInteger lenghtNameFile = searchExtensionPointRange.location - searchSlashRange.location;
        nameFile = [link substringWithRange:NSMakeRange(searchSlashRange.location, lenghtNameFile)];
    }
    NSString* filePath   = [[NSBundle mainBundle] pathForResource:nameFile ofType:@".json"];
    NSData*   data       = [NSData dataWithContentsOfFile:filePath];
    NSError*  errorJSON  = nil;
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&errorJSON];
    
    return result;
}

// Вытаскиваем просто локально по имени
// We just pull it out locally by name
+ (NSDictionary*) getDictFromJSONFile:(NSString*) nameFile andExtensionWithPoint:(NSString*) extension {
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:nameFile ofType: extension];
    NSData*   data     = [NSData dataWithContentsOfFile:filePath];
    NSError*  error    = nil;
    NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:kNilOptions error:&error];
    return result;
}




#pragma mark - NSUserDefaults & Model

+ (void) writeUser:(User*) user {
    NSData* userObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userObject forKey:kUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (User*) readUserWithKey {
    
    NSData* userObject = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfo];
    User* user;
    if (userObject)
        user = [NSKeyedUnarchiver unarchiveObjectWithData:userObject];
    else
         user = [[User alloc] init];
    
    return user;
}



#pragma mark - Work with Images


+ (UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    
    /*
    Тут нужно внимательно следить что-бы сюда не приходили
    отрицательные координаты. Было падение и ошибка "invalid context 0x0”
    потому-что я сюда передавал textView у которого был фрейм с минусом
    и поэтому не отображались картинки на textview
    Tutaj musisz uważnie monitorować, aby nie przyszli tutaj
    ujemne współrzędne. Wystąpiła awaria i błąd „nieprawidłowy kontekst 0x0”
    ponieważ przekazałem tutaj textView, który miał ramkę z minusem
    i dlatego obrazy nie były wyświetlane w widoku tekstowym
    Here you need to carefully monitor so that they do not come here
    negative coordinates. There was a crash and an error "invalid context 0x0"
    because I passed here a textView which had a frame with a minus
    and therefore images were not displayed on the textview
    */
   
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    // 1 Variant
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage*) changeColorFromUIColor:(UIColor*) color withImg:(UIImage*) img{
    
    UIGraphicsBeginImageContextWithOptions(img.size, NO, img.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, img.size.width, img.size.height), [img CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, img.size.width, img.size.height));
    
    UIImage* coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return coloredImg;
}


+ (void) insertPhotoFromArray:(NSArray*) arrImg withSelfPhotosArr:(NSMutableArray*) photos withTextView:(UITextView*) textView addInTop:(BOOL) addPhotoInTop andSelfView:(UIView*) selfView {
    
    [photos removeAllObjects];
    
    for (NSString* urlImg in arrImg) {
        
        UIImageView* imgView = [[UIImageView alloc] init]; // placeholader
        [selfView addSubview:imgView];
        // SD_WebImage
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:urlImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];

        if (!image) {
            NSData*  data  = [Utilities getFileFromOnLink:urlImg];
            
            if (data) {
                UIImage* localeImage = [UIImage imageWithData:data];
                textAttachment.image = [Utilities imageWithImage:localeImage scaledToWidth:CGRectGetWidth(textView.bounds)-10.f];
                [photos addObject:[[PhotoModel alloc] initFromUIImage:localeImage]];
            }
        } else {
            textAttachment.image = [Utilities imageWithImage:image scaledToWidth:CGRectGetWidth(textView.bounds)-10.f];
            [photos addObject:[[PhotoModel alloc] initFromUIImage:image]];
               }

        NSMutableAttributedString *attrStringWithImage = [[NSAttributedString attributedStringWithAttachment:textAttachment] mutableCopy];
              
        NSMutableAttributedString *tempMutableAttributedText = [[NSMutableAttributedString alloc] initWithAttributedString:textView.attributedText];
                                
                    if (addPhotoInTop) {
                        [attrStringWithImage appendAttributedString:[[NSAttributedString alloc] initWithString: @"\n\n"]];
                        [tempMutableAttributedText insertAttributedString:attrStringWithImage atIndex:0];
                    } else {
                    
                    [tempMutableAttributedText appendAttributedString:[[NSAttributedString alloc] initWithString: @"\n\n"]];
                   // [tempMutableAttributedText insertAttributedString:attrStringWithImage atIndex:textView.selectedRange.location];
                    [tempMutableAttributedText insertAttributedString:attrStringWithImage atIndex:textView.attributedText.length];
                    }

            __weak UITextView *weakTextView = textView;
            __weak UIImageView *weakImgView = imgView;

            ANDispatchBlockToMainQueue(^{
                [weakTextView setAttributedText:tempMutableAttributedText];
                [weakImgView removeFromSuperview];
                weakTextView.selectable = YES;
            });
            
           
                }];
    }
}


#pragma mark - Init UI Component

+ (UIAlertController*) getUIAlertViewControllerWithTitle:(NSString*) title andMessage:(NSString*) message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
   
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    return  alertController;
}

+ (void) toEmptyTheEntireInterface:(NSArray*) arrUI {
    
    
    for (id uiObj in arrUI)
    {
            if ([uiObj isKindOfClass:[UITextField class]])
            {
                if ([uiObj isFirstResponder])
                    [uiObj resignFirstResponder];
            }
            
        
            if ([uiObj isKindOfClass:[UITextView class]])
            {
                UITextView* txtView = uiObj;
                if (txtView.text.length > 0)
                    txtView.text  = @"";
            }
            
            
            if ([uiObj isKindOfClass:[UITextField class]])
            {
                UITextField* txtField = uiObj;
                txtField.placeholder = @"";
                txtField.text = @"";
            }
            
            if ([uiObj isKindOfClass:[UILabel class]])
            {
                UILabel* txtLabel = uiObj;
                if (txtLabel.text.length > 0)
                    txtLabel.text  = @"";
            }
            
            if ([uiObj isKindOfClass:[UIButton class]])
            {
                UIButton* btn = uiObj;
                if (btn.userInteractionEnabled)
                    btn.userInteractionEnabled = NO;
            }
    }
}

+ (void) setBackButtonInNavigationBarWithController:(id) controller withNavigationItem:(UINavigationItem*) navItem  sel:(SEL) selector {

    UIImage* image = [Utilities changeColorFromUIColor:[UIColor blackColor] withImg:[UIImage imageNamed:@"backArrow"]];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithImage:image
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:controller
                                                                      action:selector];
    navItem.leftBarButtonItem = backButtonItem;
    navItem.hidesBackButton = YES;
}


#pragma mark - Constraints

+ (void) addConstraintToCenterXandCenterY:(id) firstItem andSecondItem:(id) secondItem {

    [secondItem addConstraint:[NSLayoutConstraint constraintWithItem:firstItem
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:secondItem
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1
                                                            constant:0]];
    
    [secondItem addConstraint:[NSLayoutConstraint constraintWithItem:firstItem
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:secondItem
                                                           attribute:NSLayoutAttributeWidth
                                                          multiplier:1
                                                            constant:0]];
}





#pragma mark - Action

+ (NSArray*) divideStringIntoIndividualCharacters:(NSString*) str {
    
    NSMutableArray* arrEachCharAsAnswer = [NSMutableArray array];
    
    for (int i=0; i < [str length]; i++) {
        NSString* ch = [str substringWithRange:NSMakeRange(i, 1)];
        [arrEachCharAsAnswer addObject:ch];
    }
    
    return arrEachCharAsAnswer;
}


+(BOOL) isInternetConnection
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable) {
        //NSLog(@"There IS NO internet connection");
        return NO;
    }
    return YES;
}

@end
