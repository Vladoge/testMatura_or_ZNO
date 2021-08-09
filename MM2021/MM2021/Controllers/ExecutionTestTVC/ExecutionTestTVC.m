//
//  ExecutionTestVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "ExecutionTestTVC.h"
#import "UIImageView+WebCache.h"

@interface ExecutionTestTVC ()

@end

@implementation ExecutionTestTVC

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
    [self initAndSetupProgressView];

    
    if (![Utilities isInternetConnection]) {
        [self reactionToDisconnectFromNetwork:[Utilities isInternetConnection]];
    } else {
        [self getFullVariantFromServer];
    }
}

- (void) dealloc {
    
    if ([_timer isValid])
        [_timer invalidate];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([Utilities isInternetConnection]) {
        BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShown"];
        if (!coachMarksShown) {
            [self showTutorial];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Вызывается после viewDidLoad
    // Вызывается каждый раз когда котроллер становиться активным
    // Wywoływane po viewDidLoad
    // Wywoływane za każdym razem, gdy kontroler staje się aktywny
    // Called after viewDidLoad
    // Called every time the controller becomes active
    
    self.progressView.hidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Вызывается при предупреждения удаление котроллера
    // Called upon warning, deleting the controller
    // Wywołane po ostrzeżeniu, usuwając kontroler
    self.progressView.hidden = YES;
}



#pragma mark - Server

- (void) getFullVariantFromServer
{
    [self.HUD show:YES];
    self.view.userInteractionEnabled = NO;

   [[ServerManager sharedManager] getFullVariantForLink:self.linkOnFullVariantModel
   onSuccess:^(FullVariant *fVariant) {
       
       [self setupFullVariant:fVariant];
   }
   onFailure:^(NSError *errorBlock, NSInteger statusCode, FullVariant *fVariant) {
       [self setupFullVariant:fVariant];
   }];
}

- (void) getFullTaskFromServerWithLink:(NSString*) link {
    
    if (link) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.HUD show:YES];
        self.view.userInteractionEnabled = NO;

        [[ServerManager sharedManager] getFullTaskForLink:link
        onSuccess:^(FullTask *fTask) {
            
            [self setupFullTaskFromModel:fTask];
        }
        onFailure:^(NSError *errorBlock, NSInteger statusCode, FullTask *fTask) {
            
            [self setupFullTaskFromModel:fTask];
        }];
    }
}

- (void) getResultOfEvaluatorFromMyPrimaryBall:(NSInteger) myBall
                                    andMaxBall:(NSInteger) maxBall {
    
    QualityExecutionTestEnum qualityJobs = qualityVeryBad;
    
    NSInteger percentBall = ((myBall * 100) / maxBall);
    
    if (percentBall >= 80)
        qualityJobs = qualityExcellent;
    else if (percentBall >= 60)
        qualityJobs = qualityGood;
    else if (percentBall >= 40)
        qualityJobs = qualityMedium;
    else if (percentBall >= 20)
        qualityJobs = qualityBad;
    else if (percentBall >= 0)
        qualityJobs = qualityVeryBad;
    
    [[ServerManager sharedManager] getResultEvaluatorModelWithEnumValue:qualityJobs
                                          onTypeOfTheRequestedEvaluator:forTheResultTest
                                                              onSuccess:^(EvaluatorResultTest *evaResultTest) {
                                                                  [self setupEvalutorResultTestFromModel:evaResultTest];
                                                              }
                                                              onFailure:^(NSError *errorBlock, NSInteger statusCode, EvaluatorResultTest *evaResultTest) {
                                                                  [self setupEvalutorResultTestFromModel:evaResultTest];
                                                              }];
}

#pragma mark - Server Helpers Method
- (void) setupFullVariant:(FullVariant*) varinat {
   
    self.navigationItem.title = varinat.variantName;

    self.fullVariant = varinat;
    self.timer       =  [NSTimer scheduledTimerWithTimeInterval: 1.0   target: self selector:@selector(onTick:)   userInfo: nil repeats:YES];

    [self setupStepForProgressView:varinat];
    [self getFullTaskFromServerWithLink:[_fullVariant.tasks firstObject]];
}

- (void) setupFullTaskFromModel:(FullTask*) task {
    
    if ([task.taskName isEqualToString:self.currentYourAnswerAndModel.modelFullTask.taskName]) {
        // Jeśli aktualizujemy bieżące zadania
        
        
        [self.arrYourAnswer removeObject:self.currentYourAnswerAndModel];
        self.currentYourAnswerAndModel = [[YourAnswerAndTaskModel alloc] initWithYourAnswer:nil andFullTask:task];
        [self.arrYourAnswer insertObject:self.currentYourAnswerAndModel atIndex:self.collectorOfStatVar.currentIndexTask];
       
        [self setupDataOnTableViewWithModel:_arrYourAnswer[self.collectorOfStatVar.currentIndexTask]];
        [self.HUD hide:YES];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        ANDispatchBlockAfter(0.35f, ^{
            self.view.userInteractionEnabled = YES;
            [self.textView setContentOffset:CGPointZero animated:YES];
        });
        
    } else {
        // Jeśli ustawimy nowe zadanie
        self.currentYourAnswerAndModel = [[YourAnswerAndTaskModel alloc] initWithYourAnswer:nil andFullTask:task];
        [self.arrYourAnswer addObject:self.currentYourAnswerAndModel];
        [self setupDataOnTableViewWithModel:_arrYourAnswer[self.collectorOfStatVar.currentIndexTask]];
        
        [self.HUD hide:YES];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        ANDispatchBlockAfter(0.35f, ^{
            self.view.userInteractionEnabled = YES;
            [self.textView setContentOffset:CGPointZero animated:YES];
        });
    }

}

- (void) setupEvalutorResultTestFromModel:(EvaluatorResultTest*) model {
    
    // Перенаправить в главный поток
    self.myViewResult.statusOfTestExecutionLabel.text = model.phrase;
    NSString* addressImg = (IS_IPAD) ? model.imagesForiPadDevice[kMiddleImg] : model.imagesForiPhoneDevice[kMiddleImg];
    
    [self.myViewResult.imageEvaluatingTestResults sd_setImageWithURL:[NSURL URLWithString:addressImg]
                                                    placeholderImage:[UIImage imageNamed:@"placeholder"]
                                                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                   if (!image) {
                       NSData*  data  = [Utilities getFileFromOnLink:addressImg];
                       if (data) {
                           UIImage* localeImage = [UIImage imageWithData:data];
                           self.myViewResult.imageEvaluatingTestResults.image = localeImage;
                       }
                   }
                   UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView:)];
                   tapped.numberOfTapsRequired = 1;
                   self.myViewResult.imageEvaluatingTestResults.userInteractionEnabled = YES;
                   [self.myViewResult.imageEvaluatingTestResults addGestureRecognizer:tapped];
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    self.tableView.scrollEnabled = YES;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.tableView.scrollEnabled = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ((orientation == UIDeviceOrientationPortrait) || (orientation == UIDeviceOrientationPortraitUpsideDown))
    {
        if (self.navigationController.navigationBar)
        {
            CGRect freeHeightSpace = [Utilities getFreeSpaceWithOut_NavAndStatusBar:self.navigationController.navigationBar];

            // Такой костыль, потому что при перевороте координаты нулевые
            if (self.heightCell == 0)
            {
              self.heightCell =  CGRectGetHeight(freeHeightSpace);
            }
            return self.heightCell;
            
        } else {
                 return CGRectGetHeight(self.view.bounds);
               }
    } else {
                if (self.navigationController.navigationBar)
                {
                    CGRect freeHeightSpace = [Utilities getFreeSpaceWithOut_NavBar:self.navigationController.navigationBar];
                    return CGRectGetWidth(freeHeightSpace); // Тк LandScape
                } else {
                         return CGRectGetWidth(self.view.bounds);
                        }
        
            }
    return 50.f;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIButton Action

-(void) goToDetailReviewResultVC:(UIButton*) sender {
    
    [self hideMyResultsAndDarkShadowView];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailAnalyticsTaskTVC* detailTVC  = (DetailAnalyticsTaskTVC*)[storyboard instantiateViewControllerWithIdentifier:@"DetailAnalyticsTaskTVC"];
    detailTVC.arrYourAnswer = [NSMutableArray arrayWithArray:self.arrYourAnswer];
    
    [self.navigationController pushViewController:detailTVC animated:YES];
}

-(void) nextButtonAction:(UIButton *)sender{
    
    // Записываем результат !
    if ([self.expectedAnswerField isFirstResponder]) {
        [self.expectedAnswerField resignFirstResponder];
    }
    
    // Просто защита, что бы не вылететь за приделы массива
    if (self.collectorOfStatVar.currentIndexTask < [self.fullVariant.tasks count]-1) {
        [self recordYourAnswerInTheMemory];
        [self toEmptyTheEntireInterface];
        self.collectorOfStatVar.currentIndexTask++;
        
        if (self.arrYourAnswer.count > _collectorOfStatVar.currentIndexTask)
        {
            [self setupDataOnTableViewWithModel:_arrYourAnswer[_collectorOfStatVar.currentIndexTask]];
        }
         else{
                 // Проверяем есть ли такой вообще индекст элемента в tasks
                 if (_fullVariant.tasks.count > _collectorOfStatVar.currentIndexTask)
                 {
                     [self getFullTaskFromServerWithLink:_fullVariant.tasks[_collectorOfStatVar.currentIndexTask]];
                 }
             }

        if (_stepForProgressView < 0)
            _stepForProgressView *= -1;
        [self.progressView setProgress:_progressView.progress + _stepForProgressView];
        
    } else {
        [self recordYourAnswerInTheMemory];

        if (!self.alreadyWriteAnswerInUserModel) {
            ANDispatchBlockToBackgroundQueue(^{
                if ([self->_timer isValid])
                    [self->_timer invalidate];
                
                User* userStatistics       = [Utilities readUserWithKey];
                //NSLog(@"userStatistics = %@", userStatistics);
                //NSLog(@"self.collectorOfStatVar.numberPrimaryScores = %ld",(long)self.collectorOfStatVar.numberPrimaryScores);
                userStatistics.numberOfExecutedVariants += 1;
                userStatistics.primaryAverageScore += self.collectorOfStatVar.numberPrimaryScores;
                
                userStatistics.primaryAverageScore = (userStatistics.primaryAverageScore / userStatistics.numberOfExecutedVariants);
                //NSLog(@"userStatistics after = %@", userStatistics);
                
                [Utilities writeUser:userStatistics];
                self.alreadyWriteAnswerInUserModel = YES;
            });
        }
        
        self.tableView.scrollEnabled = YES;
        self.darkShadowView.hidden = NO;
        
        self.myViewResult = [ResultOfTheAssignmentView myView:@"ResultOfTheAssignmentView"
                                                    withFrame:[Utilities getRectForResultOfTheAssignmentView:self.view.frame
                                                   withNavBar:self.navigationController.navigationBar]];
        [self.myViewResult.goToDetailReviewButton addTarget:self
                                                     action:@selector(goToDetailReviewResultVC:)
                                           forControlEvents:UIControlEventTouchUpInside];
        self.myViewResult.translatesAutoresizingMaskIntoConstraints = NO;
       
        // Сетапим
        self.myViewResult.numberOfCorrectAnswerLabel.text = [NSString stringWithFormat:@"Poprawne odpowiedzi:\n%ld/%ld",
                                                             (long)self.collectorOfStatVar.numberTrueAnswer,
                                                             (long)self.fullVariant.countTask];
        
        self.myViewResult.primaryScoresLabel.text = [NSString stringWithFormat:@"Wynik podstawowy: %ld",(long)self.collectorOfStatVar.numberPrimaryScores];
        
        [self getResultOfEvaluatorFromMyPrimaryBall:self.collectorOfStatVar.numberPrimaryScores
                                         andMaxBall:self.fullVariant.maxPrimaryBall];
        
        [self.myViewResult snapIntoView:self.tableView direction:DCAnimationDirectionTop];
   
        // Add Constraint To myViewResult
        [Utilites_ExecutTVC addConstraintToMyResult:self.myViewResult andSecondItem:self.view];
        }
}

-(void) backButtonAction:(UIButton *)sender{
    
    // Записываем результат !
    [self recordYourAnswerInTheMemory];
    [self toEmptyTheEntireInterface];
    
    if (self.collectorOfStatVar.currentIndexTask >= 1) {
        self.collectorOfStatVar.currentIndexTask--;

        // Проверяем, есть ли эта модель у нас в массиве, что бы не скачивать еще раз
        if (self.arrYourAnswer.count-1 > _collectorOfStatVar.currentIndexTask) {
 
            [self setupDataOnTableViewWithModel:_arrYourAnswer[_collectorOfStatVar.currentIndexTask]];
        }
        else
        {
            // Проверяем есть ли такой вообще индекст элемента в tasks
            if (_fullVariant.tasks.count > _collectorOfStatVar.currentIndexTask)
            {
                [self getFullTaskFromServerWithLink:_fullVariant.tasks[_collectorOfStatVar.currentIndexTask]];
            }
        }
        if (_stepForProgressView > 0)
            _stepForProgressView *= -1;
        [self.progressView setProgress:_progressView.progress + _stepForProgressView];
    }
}

-(void) showAnswerButtonAction:(UIButton *)sender{
        
    PhotoModel *photo= [[PhotoModel alloc] init];
    NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
    UIImageView*  imageView = [[UIImageView alloc] init];
    NSURL* urlPic = [NSURL URLWithString: _currentYourAnswerAndModel.modelFullTask.pictureForNoValidAnswer];
    
    __weak NYTPhotosViewController *weakPhotoVC = photoVC;
    __weak PhotoModel *weakPhoto                = photo;
    __weak UIImageView* weakImgView             = imageView;
    
    if ([Utilities isInternetConnection]){
        
        [weakImgView sd_setImageWithURL:urlPic
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  
                                  if (image){
                                      weakPhoto.image = imageView.image;
                                      [weakPhotoVC updateImageForPhoto:weakPhoto];
                                  }
                              }];
    } else {
        NSData*  data  = [Utilities getFileFromOnLink:_currentYourAnswerAndModel.modelFullTask.pictureForNoValidAnswer];
        if (data)
        {
            photo.image = [UIImage imageWithData:data];
            [photoVC updateImageForPhoto:photo];
        }
    }
    
    photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:self.currentYourAnswerAndModel.modelFullTask.taskName
                                                                     attributes: @{NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                   NSFontAttributeName           : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}];
                                      
    [self presentViewController:photoVC animated:YES completion:nil];

}


#pragma mark - HPTextViewTapGestureRecognizerDelegate

-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnURL:(NSURL*)URL inRange:(NSRange)characterRange
{
    [[UIApplication sharedApplication] openURL:URL];
}

-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnTextAttachment:(NSTextAttachment*)textAttachment inRange:(NSRange)characterRange
{
    NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:self.photos initialPhoto:nil delegate:self];
    [self presentViewController:photoVC animated:YES completion:nil];
}

#pragma mark - NYTPhotosViewControllerDelegate

// Метод который устанавливает текст в UINavigationBar. По стандарту мы ставим колличество наших фото, Например 1из3
- (NSString*)photosViewController:(NYTPhotosViewController*)photosViewController titleForPhoto:(id<NYTPhoto>)photo atIndex:(NSUInteger)photoIndex totalPhotoCount:(NSUInteger)totalPhotoCount {
    return [NSString stringWithFormat:@"%luof%lu", (unsigned long)photoIndex+1, (unsigned long)totalPhotoCount];
}

// Если return 'YES' тогда при долгом нажатии не будет появляться кнопка Copy.
- (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleLongPressForPhoto:(id <NYTPhoto>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    return YES;
}

// Если return 'YES' тогда UIActivityViewController показываться не будет. 'NO' будет этот контроллер
- (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleActionButtonTappedForPhoto:(id <NYTPhoto>)photo {
    return YES;
}

#pragma mark - Untils

-(void) initialSetupController
{
    self.fullVariant               = [FullVariant new];
    self.collectorOfStatVar        = [TmpTaskStatictics new];
    self.arrYourAnswer             = [NSMutableArray array];
    self.currentYourAnswerAndModel = [YourAnswerAndTaskModel new];
    self.heightCell = 0;
    self.stepForProgressView = 0.f;
    self.rotateVC = YES;
    self.alreadyWriteAnswerInUserModel = NO;
    
    // Img TextView
    self.photos = [NSMutableArray array];
    self.textViewTapGestureRecognizer = [[HPTextViewTapGestureRecognizer alloc]init];
    self.textViewTapGestureRecognizer.delegate = self;
    [self.textView addGestureRecognizer:self.textViewTapGestureRecognizer];
    self.textView.selectable = YES;
    
    // Add target next & back button
    [self.nextButton       addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton       addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.showAnswerButton addTarget:self action:@selector(showAnswerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
   // Navigation Setup
   [Utilities setBackButtonInNavigationBarWithController:self withNavigationItem:self.navigationItem sel:@selector(popCurrentViewController)];

    //
    self.HUD            = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.progressView   = [[UIProgressView alloc] init];
    self.darkShadowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.timerButton    = [[UIBarButtonItem alloc] initWithTitle:@"00:00" style:UIBarButtonItemStyleDone target:self action:nil];
    //self.tutorialButton
    
    UIImage *image = [UIImage imageNamed:@"question"];
    self.tutorialButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showTutorial)];
    self.tutorialButton.imageInsets = UIEdgeInsetsMake(0, -20, 0, 20);

    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
   
    NSMutableArray* leftBarButtonItems = [NSMutableArray arrayWithArray:self.navigationItem.leftBarButtonItems];
    [leftBarButtonItems addObject:self.tutorialButton];
    
    self.navigationItem.leftBarButtonItems = leftBarButtonItems;
    
    [Utilites_ExecutTVC partialConfigurationUI_ForControllerWithTopView:self.topView
                                                           withDownView:self.downView
                                                           withSelfView:self.view
                                                          withTableView:self.tableView
                                                           withTextView:self.textView
                                               withActionDirectionLabel:self.actionDirectionLabel
                                                         withNextButton:self.nextButton
                                                         withBackButton:self.backButton
                                                   withShowAnswerButton:self.showAnswerButton
                                                withExpectedAnswerField:self.expectedAnswerField
                                                     withDarkShadowView:self.darkShadowView
                                                                withHUD:self.HUD
                                                     withRefreshControl:self.refreshControl
                                                        withTimerButton:self.timerButton];
    
    self.navigationItem.rightBarButtonItems = @[self.timerButton];

    [self.refreshControl addTarget:self action:@selector(getLatestLoans:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.darkShadowView];
    [self.view addSubview:self.HUD];

    // Gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard:)];
    [self.view addGestureRecognizer:tap];
    // Обнулить весь интерфейс
    [self toEmptyTheEntireInterface];
}

#pragma mark - UI methods

- (void) initAndSetupProgressView {
    
    [self deteleProgressViewWithConstraint];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.progressView.tintColor      = [UIColor colorWithHexString:@"2d73ff"]; // статус выполнения
    self.progressView.trackTintColor = [UIColor flatGrayColor];  // background
    [self.progressView setProgress:0.f animated:YES];

    [self.navigationController.navigationBar addSubview:self.progressView];
    [Utilites_ExecutTVC addConstraintForProgressView:self.progressView withNavContr:self.navigationController];
}

- (void) setupStepForProgressView:(FullVariant*) variant {
    self.stepForProgressView = 1.0 / variant.tasks.count;
    [self.progressView setProgress:self.stepForProgressView];
}

- (void) deteleProgressViewWithConstraint {

    [self.progressView removeConstraints:self.progressView.constraints];
    [self.progressView removeFromSuperview];
    self.progressView = nil;
}

- (void) redrawingNavBar:(CGRect) frameForDrawing {
    
    self.navigationController.navigationBar.translucent  = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    self.navigationController.navigationBar.barTintColor =
    [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom
                          withFrame:frameForDrawing
                          andColors:@[[UIColor flatGreenColor],[UIColor flatGreenColorDark]]];
    
    // Устанавливаем противоположенный цвет тектсу в navBar
    NSDictionary* titleTextAttributesDict = @{NSForegroundColorAttributeName : [UIColor colorWithContrastingBlackOrWhiteColorOn: self.navigationController.navigationBar.barTintColor isFlat:NO],
                                              NSFontAttributeName:[UIFont fontWithName:@"SFUIDisplay-Light" size:21]};
    [self.navigationController.navigationBar setTitleTextAttributes: titleTextAttributesDict];
}

- (void) reactionToDisconnectFromNetwork:(BOOL) isConnectToNetwork
{
    if (!isConnectToNetwork) {
        SCLAlertView* alert = [[SCLAlertView alloc] init];
        
        [alert addButton:@"OK" target:nil selector:nil];
        [alert addButton:@"Pobierz kopię lokalną"
                  target:self
                selector:@selector(reactionToDisconnectFromNetworkAction:)];
        [alert showError:self title:@"Błąd" subTitle:@"Połączenia internetowe" closeButtonTitle:nil duration:0.f];
    }
}

-(void) reactionToDisconnectFromNetworkAction:(UIButton*) sender {
    
    [self getFullVariantFromServer];
    BOOL coachMarksShown = [[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShown"];
    if (!coachMarksShown) {
        [self showTutorial];
    }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    [self.tableView reloadData];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    [self.navigationController.view setNeedsLayout];
    
    if ((orientation == UIDeviceOrientationPortrait) || (orientation == UIDeviceOrientationPortraitUpsideDown)) {
        self.tableView.scrollEnabled = NO;
        [self redrawingNavBar:[Utilities getFrameStatusBarWithNavBar:self.navigationController.navigationBar]];
    } else {
         self.tableView.scrollEnabled = YES;
        [self redrawingNavBar:self.navigationController.navigationBar.bounds];
    }
}

- (void) toEmptyTheEntireInterface {
    
    [self.textView.undoManager removeAllActions];
    [Utilities toEmptyTheEntireInterface:@[self.expectedAnswerField,
                                           self.textView,
                                           self.expectedAnswerField,
                                           self.actionDirectionLabel,
                                           self.backButton,
                                           self.nextButton,
                                           self.showAnswerButton,
                                           self.expectedAnswerField]];
}

#pragma mark - Gesture

-(void)dismissKeyboard:(UITapGestureRecognizer*) gesture {
    
    if ([self.expectedAnswerField isFirstResponder]){
        [self.expectedAnswerField resignFirstResponder];
    } else if (!self.darkShadowView.hidden)
    {
        [self hideMyResultsAndDarkShadowView];
        [self showAlertContrWithTitle:@"Zakończ wykonywanie testu ?" withMessage:@"Przejdź do menu głównego"];
    }
}

-(void)tapOnImageView :(UITapGestureRecognizer*) gesture
{
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        
        UIImageView* imgFromGesture = (UIImageView*)gesture.view;
        PhotoModel* photo = [[PhotoModel alloc] initFromUIImage:imgFromGesture.image];
        NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
        [self presentViewController:photoVC animated:YES completion:nil];
    }
}

#pragma mark - Timer For UIBarButtonItem

-(void)onTick:(NSTimer *)timer {
    
    if (self.secondsOfExecutionTimeTest < 3600.0f) {
        self.secondsOfExecutionTimeTest++;
        
        [UIView performWithoutAnimation:^{
            self.timerButton.title = [self formatTimeStamp:self.secondsOfExecutionTimeTest];
        }];
    } else  if ([_timer isValid]) {
                self.timerButton.tintColor = [UIColor redColor];
                [_timer invalidate];
    }
    
}

- (NSString *) formatTimeStamp:(float)seconds {
    int sec = floor(fmodf(seconds, 60.0f));
    return [NSString stringWithFormat:@"%02d:%02d",
            (int)floor(seconds/60),             // minutes
            (int)sec                          // seconds
            ];
}

#pragma mark - Tutorial

-(void) showTutorial{
    NSArray* coachMarks = [Utilites_ExecutTVC getRectForShowTutorialWithTimerButton:self.timerButton
                                                                       withTextView:self.textView
                                                           withActionDirectionLabel:self.actionDirectionLabel
                                                            withExpectedAnswerField:self.expectedAnswerField
                                                                     withNextButton:self.nextButton
                                                                     withBackButton:self.backButton
                                                                       withSelfView:self.view
                                                                         withNavBar:self.navigationController.navigationBar];
    
    WSCoachMarksView *coachMarksView = [[WSCoachMarksView alloc] initWithFrame:[[UIScreen mainScreen] bounds]
                                                                    coachMarks:coachMarks];
    
    [self.navigationController.view addSubview:coachMarksView];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"WSCoachMarksShown"])
        coachMarksView.enableSkipButton = NO;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WSCoachMarksShown"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //coachMarksView.delegate = self;
    
    coachMarksView.enableContinueLabel = YES;
    coachMarksView.cutoutRadius = 7;
    [coachMarksView start];
}

#pragma mark - Action

-(void)  hideMyResultsAndDarkShadowView {
    self.darkShadowView.hidden = YES;
    [self.myViewResult.imageEvaluatingTestResults removeGestureRecognizer:[_myViewResult.imageEvaluatingTestResults.gestureRecognizers firstObject]];
    [self.myViewResult drop:nil];
    [self.myViewResult removeConstraints:self.myViewResult.constraints]; // Подумать над этим !!!
}

- (void)popCurrentViewController {
    
    
    if (self.collectorOfStatVar.currentIndexTask >= self.fullVariant.countTask-1) {
        [self showAlertContrWithTitle:@"Zakończyć wykonywanie testu?" withMessage:@"Wyjdź do menu głównego"];
    } else {

        [self showAlertContrWithTitle:@"Zakończyć wykonywanie testu?" withMessage:@"Wtedy statystyki nie będą brane pod uwagę."];
        
    }
}

- (void) showAlertContrWithTitle:(NSString*) title withMessage:(NSString*) message {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle: title
                                          message: message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Anuluj"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self deteleProgressViewWithConstraint];
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getLatestLoans:(UIRefreshControl *)refreshControl {
    [self reloadData];
}

- (void)reloadData
{
    [self updateTask];
    // End the refreshing
    if (self.refreshControl) {
        [self.refreshControl endRefreshing];
    }
}

- (void) updateTask
{
    // Создать метод который обнуляет весь UI
    [self toEmptyTheEntireInterface];
    [self getFullTaskFromServerWithLink:_fullVariant.tasks[_collectorOfStatVar.currentIndexTask]];
}


-(void) recordYourAnswerInTheMemory {
    
    if (!([self.currentYourAnswerAndModel.yourAnswer isEqualToString:self.expectedAnswerField.text]) && (![self.expectedAnswerField.text isEqualToString:@""]))
    {
        self.currentYourAnswerAndModel.yourAnswer = self.expectedAnswerField.text;
        
        NSString* yAnswer = self.currentYourAnswerAndModel.yourAnswer;
        FullTask* fTask   = self.currentYourAnswerAndModel.modelFullTask;
        
        if ( !(fTask.onlyOneCorrectAnswer) && (fTask.divideTheAnswerForEachCharacter) && (fTask.mandatorySequence))
            _currentYourAnswerAndModel.answerIsCorrect = [self.collectorOfStatVar multipleCorrectAnswersAndSplitBySymbolWithOrder:fTask withYourAnswer:yAnswer];
        else   if (!(fTask.onlyOneCorrectAnswer) && (fTask.divideTheAnswerForEachCharacter))
            _currentYourAnswerAndModel.answerIsCorrect = [self.collectorOfStatVar multipleCorrectAnswersAndDivideBySymbol:fTask withYourAnswer:yAnswer];
        else  if (fTask.onlyOneCorrectAnswer)
            _currentYourAnswerAndModel.answerIsCorrect = [self.collectorOfStatVar oneCorrectAnswerInTask:fTask withYourAnswer:yAnswer];
        else if (!fTask.onlyOneCorrectAnswer)
            _currentYourAnswerAndModel.answerIsCorrect = [self.collectorOfStatVar multipleCorrectAnswers_OrderAndSequenceAreNotImportant:fTask withYourAnswer:yAnswer];
    }
}

- (NSAttributedString*)attributedLinkWithText:(NSString*)text URLString:(NSString*)URLString
{
    NSURL *URL = [NSURL URLWithString:URLString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text
                                                                                         attributes:@{NSLinkAttributeName : URL}];
    return attributedString;
}


- (void) setupDataOnTableViewWithModel:(YourAnswerAndTaskModel*) model {
    
    self.currentYourAnswerAndModel = model;
    _backButton.userInteractionEnabled = (self.collectorOfStatVar.currentIndexTask == 0) ? NO : YES;
    _nextButton.userInteractionEnabled = YES;
    
    if (self.collectorOfStatVar.currentIndexTask == self.fullVariant.tasks.count-1)
        [self.nextButton setTitle:@"Done" forState:UIControlStateNormal];
    else
        [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    
    if (model.modelFullTask.noValidAnswerTotheRecord) {
        self.showAnswerButton.userInteractionEnabled = YES;
        self.showAnswerButton.hidden = NO;
        
        self.expectedAnswerField.userInteractionEnabled = NO;
        self.expectedAnswerField.hidden = YES;
    } else {
        
        self.showAnswerButton.userInteractionEnabled = NO;
        self.showAnswerButton.hidden = YES;
        
        self.expectedAnswerField.userInteractionEnabled = YES;
        self.expectedAnswerField.hidden = NO;
    }
    self.textView.selectable = NO;

    // 2. Создаем общую строку и сетим все в TextView
    NSString* allTextForTextView = [NSString stringWithFormat:@"%@\n\n%@\n\n%@\n\n", model.modelFullTask.taskName,
                                    model.modelFullTask.taskDefinition,
                                    model.modelFullTask.mainText];
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:allTextForTextView];
    
    UIFont* fontLight   = [UIFont fontWithName:@"SFUIDisplay-Light"  size:18.f];
    UIFont* fontRegular = [UIFont fontWithName:@"SFUIDisplay-Regular" size:18.f];
    UIFont* fontMedium  = [UIFont fontWithName:@"SFUIDisplay-Medium"  size:18.f];
    
     // Тут происходит падение
     
    NSRange rangeTaskName = [allTextForTextView rangeOfString:model.modelFullTask.taskName];
    NSRange rangeTaskDefn = [allTextForTextView rangeOfString:model.modelFullTask.taskDefinition];
    NSRange rangeMainText = [allTextForTextView rangeOfString:model.modelFullTask.mainText];
    

    /*
    if (rangeTaskName.location != NSNotFound && rangeTaskDefn.location != NSNotFound) {
        [attString addAttribute:NSFontAttributeName value:fontMedium range:rangeTaskName];    // task name
        [attString addAttribute:NSFontAttributeName value:fontRegular  range:rangeTaskDefn];  //  task defenithon
        [attString addAttribute:NSFontAttributeName value:fontLight  range:rangeMainText];    //  task main text
    }
    */
    
    if (rangeTaskName.location != NSNotFound)
        [attString addAttribute:NSFontAttributeName value:fontMedium range:rangeTaskName];   // task name
    
    if (rangeTaskDefn.location != NSNotFound)
        [attString addAttribute:NSFontAttributeName value:fontRegular  range:rangeTaskDefn]; //  task defenithon
    
    if (rangeMainText.location != NSNotFound)
        [attString addAttribute:NSFontAttributeName value:fontLight  range:rangeMainText];   //  task main text
    
    
    
    [self.textView.undoManager removeAllActions];
    [self.textView setAttributedText:attString];
    //[self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    //ANDispatchBlockToBackgroundQueue(^{

        if (model.modelFullTask.arrURLImageForTask.count > 0) {
            [Utilities insertPhotoFromArray:model.modelFullTask.arrURLImageForTask
                          withSelfPhotosArr:self.photos
                               withTextView:self.textView
                                   addInTop:model.modelFullTask.addPictureInTop
                                andSelfView:self.view];
        }
    //});

    // 3. UILabel & UITextField
    self.actionDirectionLabel.text = model.modelFullTask.actionDirection;
    
    if (!model.yourAnswer) {
        self.expectedAnswerField.placeholder = model.modelFullTask.expectedAnswer;
    } else {
        self.expectedAnswerField.text = model.yourAnswer;
    }
}

@end
