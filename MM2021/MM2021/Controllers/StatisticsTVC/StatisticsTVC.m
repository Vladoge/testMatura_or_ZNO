//
//  StatisticsTVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "StatisticsTVC.h"

typedef NS_ENUM(NSInteger, ScrollViewButtonTagEnum) {
    vkBtnTag,
    fbBtnTag,
    twBtnTag,
    gPlusBtnTag,
    okBtnTag
};

const CGFloat heightScoresCell = 80.f;

#define colorBackgroundCell  @"ADC6B3"
#define colorTitleImgeCell   @"F9ECC0"
#define colorTitleAvgCell    @"FFD951"
#define colorTitleShareCell  @"E8DDBB"

#define mainShareText        @"I am preparing for the exam using the application on my iPhone"


#define urlShareImage        @"https://pp.userapi.com/c636820/v636820080/6d3ce/YBMcLdUvkbY.jpg"
#define linkShare            @"https://vk.com/vladikkoval"

#define publicID 147691498


@interface StatisticsTVC ()

@property (assign, nonatomic) int xOffset;
@property (strong, nonatomic) UIImage* imgFromEvaluatorResult;
@end

@implementation StatisticsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
    
     self.currentUser = [Utilities readUserWithKey];
    [self getShareDataFromServer];

    //#warning Provide your maxVariant Ball
    [self getResultImgFromPrimaryScores:self.currentUser.primaryAverageScore andMaxBall:47]; // HardCode
}

#pragma mark - Server

- (void) getShareDataFromServer {
    [[ServerManager sharedManager] getShareData:^(ShareData *sData) {
        self.myShareData = sData;
     }
      onFailure:^(NSError *errorBlock, NSInteger statusCode, ShareData *sData) {
          self.myShareData = sData;
      }];
}

- (void) getResultImgFromPrimaryScores:(NSInteger) myPrimraryBall
                            andMaxBall:(NSInteger) maxBall{
    
    QualityExecutionTestEnum qualityJobs = qualityVeryBad;
    NSInteger percentBall = ((myPrimraryBall * 100) / maxBall);
    
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
    
    [self.HUD show:YES];
    self.view.userInteractionEnabled = NO;
    
    [[ServerManager sharedManager] getResultEvaluatorModelWithEnumValue:qualityJobs
                                          onTypeOfTheRequestedEvaluator:forTheStatistics
                                                              onSuccess:^(EvaluatorResultTest *evaResultTest) {
                                                                  [self setupEvalutorResultTestFromModel:evaResultTest];
                                                              }
                                                              onFailure:^(NSError *errorBlock, NSInteger statusCode, EvaluatorResultTest *evaResultTest) {
                                                                  [self setupEvalutorResultTestFromModel:evaResultTest];
                                                              }];
}

- (void) setupEvalutorResultTestFromModel:(EvaluatorResultTest*) model {
    
    self.currentEvalutorTest = model;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.HUD hide:YES];
    
    ANDispatchBlockAfter(0.35f, ^{
        self.view.userInteractionEnabled = YES;
    });
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float freeSpace = CGRectGetHeight([Utilities getFreeSpaceWithOut_NavAndStatusBar:self.navigationController.navigationBar]);
    freeSpace -= (heightScoresCell);
    
    if (indexPath.row == 0)
        return freeSpace;
    if (indexPath.row == 1)
        return heightScoresCell;
    return 100.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.currentEvalutorTest) ? 2 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    id cell;
    if (indexPath.row == 0)
    {
        NSString* identifier = @"ImgCell_StatisticsTVC";
        cell = (ImgCell_StatisticsTVC*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
            cell = (ImgCell_StatisticsTVC*)[[ImgCell_StatisticsTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == 1)
    {
        NSString* identifier = @"AvgScoresCell_StatisticsTVC";
        cell = (AvgScoresCell_StatisticsTVC*)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell)
           cell = (AvgScoresCell_StatisticsTVC*)[[AvgScoresCell_StatisticsTVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableView helper methods

- (void)configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath
{
    UIFont* fontLight  = [UIFont fontWithName:@"SFUIDisplay-Light"  size:18.f];

    if ([cell isKindOfClass:[ImgCell_StatisticsTVC class]])
    {
        ImgCell_StatisticsTVC* myCell = (ImgCell_StatisticsTVC*)cell;
        // Title
        myCell.myTitleLabel.backgroundColor = [UIColor colorWithHexString:colorTitleImgeCell];
        myCell.myTitleLabel.font = fontLight;
        myCell.myTitleLabel.layer.cornerRadius  = 5.0f;
        myCell.myTitleLabel.layer.masksToBounds = YES;
        myCell.myTitleLabel.textColor = [UIColor colorWithHexString:@"474F49"];
        myCell.backgroundColor = [UIColor colorWithHexString:colorBackgroundCell];

        NSString* addressImg;
       if (self.currentUser.numberOfExecutedVariants > 0) {
            addressImg = (IS_IPAD) ? self.currentEvalutorTest.imagesForiPadDevice[kMiddleImg] : self.currentEvalutorTest.imagesForiPhoneDevice[kMiddleImg];
            myCell.myTitleLabel.text = self.currentEvalutorTest.phrase;

        } else {
            addressImg = @"https://gitlab.com/thisismymail03/api.ege.Math.pictures/raw/master/StatisticsEvaluator/ege.Math.notExecutedNoTest.jpg";
            myCell.myTitleLabel.text = @"Дерзай и выполни первый вариант ! :)";
        }
               
        myCell.myImageView.layer.cornerRadius  = 5.0f;
        myCell.myImageView.layer.masksToBounds = YES;

        [myCell.myImageView sd_setImageWithURL:[NSURL URLWithString: addressImg]
                                                        placeholderImage:[UIImage imageNamed:@"placeholder"]
                                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                                                  
                                                                   self.imgFromEvaluatorResult = image;
                                                                   
                                                                   if (!image) {
                                                                       NSData*  data  = [Utilities getFileFromOnLink:addressImg];
                                                                       if (data) {
                                                                           UIImage* localeImage = [UIImage imageWithData:data];
                                                                           self.imgFromEvaluatorResult = localeImage;

                                                                           myCell.myImageView.image = localeImage;
                                                                       }
                                                                   }
                                                                   UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView:)];
                                                                   tapped.numberOfTapsRequired = 1;
                                                                   myCell.myImageView.userInteractionEnabled = YES;
                                                                   [myCell.myImageView addGestureRecognizer:tapped];
                                                                }];
    }
    
    
    if ([cell isKindOfClass:[AvgScoresCell_StatisticsTVC class]]) {
        AvgScoresCell_StatisticsTVC* myCell = (AvgScoresCell_StatisticsTVC*)cell;
        
        // Tilte
        myCell.averageLabel.backgroundColor = [UIColor colorWithHexString:colorTitleAvgCell];
        myCell.averageLabel.layer.cornerRadius  = 5.0f;
        myCell.averageLabel.layer.masksToBounds = YES;
        myCell.averageLabel.font = fontLight;
        myCell.averageLabel.textColor = [UIColor colorWithHexString:@"474F49"];

        // Background
        myCell.backgroundColor = [UIColor colorWithHexString:colorBackgroundCell];

        
        NSString* allTextForLabel = [NSString stringWithFormat:@"Your average score:\n%ld",(long)self.currentUser.primaryAverageScore];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString: allTextForLabel];
        NSRange rangePrimaryBall  = [allTextForLabel rangeOfString:[NSString stringWithFormat:@"%ld", (long)self.currentUser.primaryAverageScore]];
        
        if (rangePrimaryBall.location != NSNotFound)
        {
            [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SFUIDisplay-Medium"  size:30.f] range:rangePrimaryBall];
            [myCell.averageLabel setAttributedText:attString];
        }
    }
    
  
}


#pragma mark - Init UI

-(void) initialSetupController
{
    self.imgFromEvaluatorResult = [UIImage new];
    
    // Navigation Setup
    [Utilities setBackButtonInNavigationBarWithController:self withNavigationItem:self.navigationItem sel:@selector(popCurrentViewController)];
    self.navigationItem.title = @"Statistics";
    // Table Setup
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor flatGrayColor];

    // Initialize the MBProgressHUD
    self.HUD = [[MBProgressHUD alloc] initWithView:self.tableView];
    self.HUD.labelText        = @"Downloading ...";
    self.HUD.mode = MBProgressHUDModeIndeterminate;
    [self.view addSubview:self.HUD];
}

#pragma mark - Action

- (void)popCurrentViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Share

- (void) shareButton:(UIButton*) sender {
}


#pragma mark - Other

-(void)tapOnImageView :(UITapGestureRecognizer*) gesture
{
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        
        UIImageView* imgFromGesture = (UIImageView*)gesture.view;
      
        PhotoModel* photo = [[PhotoModel alloc] initFromUIImageView:imgFromGesture];
        NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:@[photo] initialPhoto:nil delegate:self];
      //  NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithDataSource:self initialPhoto:photo delegate:nil];
        
     /*   - (instancetype)initWithDataSource:(id <NYTPhotoViewerDataSource>)dataSource initialPhotoIndex:(NSInteger)initialPhotoIndex delegate:(nullable id <NYTPhotosViewControllerDelegate>)delegate;

       
        - (instancetype)initWithDataSource:(id <NYTPhotoViewerDataSource>)dataSource initialPhoto:(nullable id <NYTPhoto>)initialPhoto delegate:(nullable id <NYTPhotosViewControllerDelegate>)delegate NS_DESIGNATED_INITIALIZER;*/

        [self presentViewController:photoVC animated:YES completion:nil];
    }
}

#pragma mark - NYTPhotosViewControllerDelegate

// При закрытие фото, оно сжимается и как бы всасывается в то view которое мы указали, в нашем случае это uibutton
// Kiedy zdjęcie jest zamknięte, jest kompresowane i niejako zasysane do określonego przez nas widoku, w naszym przypadku jest to przycisk uibutton
// When the photo is closed, it is compressed and, as it were, sucked into the view that we specified, in our case it is a uibutton
-(UIView*)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id<NYTPhoto>)photo {
    
    NSArray * visibleCells = self.tableView.visibleCells;
    
    if (visibleCells.count > 0){
        if ([visibleCells[0] isKindOfClass:[ImgCell_StatisticsTVC class]]){
            ImgCell_StatisticsTVC* cell = (ImgCell_StatisticsTVC*)visibleCells[0];
            return cell.myImageView;
        }
    }
    return nil;
}


@end
