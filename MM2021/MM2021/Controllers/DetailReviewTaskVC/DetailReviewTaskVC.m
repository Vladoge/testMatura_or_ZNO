//
//  DetailReviewTaskVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "DetailReviewTaskVC.h"

@interface DetailReviewTaskVC ()

@end

@implementation DetailReviewTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
    [self setupDataOnTextViewAndLabel];
}

#pragma mark - UI initials

-(void) initialSetupController
{
    // Navigation Setup
    [Utilities setBackButtonInNavigationBarWithController:self
                                       withNavigationItem:self.navigationItem
                                                      sel:@selector(popCurrentViewController)];
    
    self.navigationItem.title = self.currentYourAnswerAndModel.modelFullTask.taskName;
    self.view.backgroundColor = [UIColor colorWithHexString:@"fef0e5"];

    // UILable
    UIFont* fontLight = [UIFont fontWithName:@"SFUIDisplay-Light"     size:16.f];
    
    self.yourAnswLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
    self.yourAnswLabel.font = fontLight;
    self.yourAnswLabel.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
    [self.yourAnswLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
   
    self.yourAnswLabel.layer.shadowColor = [[UIColor flatGrayColor] CGColor];
    self.yourAnswLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.yourAnswLabel.layer.shadowOpacity = 1.0f;
    self.yourAnswLabel.layer.shadowRadius = 1.0f;
    [self.view addSubview:self.yourAnswLabel];
    // Add Constrains to label
    [Utilites_DetailReviewVC addContraintForYourAnswLabel:self.yourAnswLabel withSelfView:self.view];
    
    // TextView
    CGFloat widthTextView = (CGRectGetWidth(self.view.frame)-(2*10));
    CGFloat heightTextView = (CGRectGetHeight(self.view.frame)-(50-(2*10)));
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, widthTextView, heightTextView)];
    [self.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.textView.editable = NO;
    self.textView.font     = fontLight;
    self.textView.layer.borderWidth = 2.5f;
    self.textView.layer.borderColor = [UIColor colorWithHexString:@"f5e7de"].CGColor;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius  = 5.f;
    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
    [self.view addSubview:self.textView];
    // Add Constrains to textView
    [Utilites_DetailReviewVC addConstraintForTextView:self.textView withSelfView:self.view andYourAnswLabel:self.yourAnswLabel];
    
    // Img TextView
    self.photos = [NSMutableArray array];
    self.textViewTapGestureRecognizer = [[HPTextViewTapGestureRecognizer alloc]init];
    self.textViewTapGestureRecognizer.delegate = self;
    [self.textView addGestureRecognizer:self.textViewTapGestureRecognizer];
}

#pragma mark - Action
- (void)popCurrentViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) setupDataOnTextViewAndLabel {
   
    // Label
    UIFont* fontSemi  = [UIFont fontWithName:@"SFUIDisplay-Semibold"  size:18.f];

    self.yourAnswLabel.text = (self.currentYourAnswerAndModel.yourAnswer) ? [NSString stringWithFormat:@"Twoja odpowiedz: %@",self.currentYourAnswerAndModel.yourAnswer] : @"Twoja odpowiedz: ";
    
    if (self.currentYourAnswerAndModel.yourAnswer)
    {
        NSRange rangeYourAnsw  = [ self.yourAnswLabel.text rangeOfString:self.currentYourAnswerAndModel.yourAnswer];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:self.yourAnswLabel.text];
        
        if (rangeYourAnsw.location != NSNotFound)
        {
            [attString addAttribute:NSFontAttributeName  value:fontSemi range: rangeYourAnsw];
            
            if (self.currentYourAnswerAndModel.answerIsCorrect)
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor flatGreenColor] range: rangeYourAnsw];
            else
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]   range: rangeYourAnsw];
            
            [self.yourAnswLabel setAttributedText:attString];
        }
    }
    
    // TextView
    NSString* allTextForTextView = [NSString stringWithFormat:@"%@\n\n%@\n\n%@", self.currentYourAnswerAndModel.modelFullTask.taskName,
                                    self.currentYourAnswerAndModel.modelFullTask.taskDefinition,
                                    self.currentYourAnswerAndModel.modelFullTask.mainText];
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc] initWithString:allTextForTextView];
    
    UIFont* fontLight   = [UIFont fontWithName:@"SFUIDisplay-Light"  size:18.f];
    UIFont* fontRegular = [UIFont fontWithName:@"SFUIDisplay-Regular" size:18.f];
    UIFont* fontMedium  = [UIFont fontWithName:@"SFUIDisplay-Medium"  size:18.f];
    
    NSRange rangeTaskName = [allTextForTextView rangeOfString:self.currentYourAnswerAndModel.modelFullTask.taskName];
    NSRange rangeTaskDefn = [allTextForTextView rangeOfString:self.currentYourAnswerAndModel.modelFullTask.taskDefinition];
    NSRange rangeMainText = [allTextForTextView rangeOfString:self.currentYourAnswerAndModel.modelFullTask.mainText];
    
    if (rangeTaskName.location != NSNotFound)
        [attString addAttribute:NSFontAttributeName value:fontMedium range:rangeTaskName];    // task name
    if (rangeTaskDefn.location != NSNotFound)
        [attString addAttribute:NSFontAttributeName value:fontRegular  range:rangeTaskDefn]; //  task defenithon
    if (rangeMainText.location != NSNotFound)
        [attString addAttribute:NSFontAttributeName value:fontLight  range:rangeMainText];    //  task main text
    
    
    [self.textView setAttributedText:attString];
    
    ANDispatchBlockToMainQueue(^{
   
   // ANDispatchBlockToBackgroundQueue(^{
        if (self.currentYourAnswerAndModel.modelFullTask.arrURLImageForTask.count > 0) {
            
            [Utilities insertPhotoFromArray:self.currentYourAnswerAndModel.modelFullTask.arrURLImageForTask
                          withSelfPhotosArr:self.photos
                               withTextView:self.textView
                                   addInTop:self.currentYourAnswerAndModel.modelFullTask.addPictureInTop
                                andSelfView:self.view];
        }
  //  });
    });
}


#pragma mark - HPTextViewTapGestureRecognizerDelegate

-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnTextAttachment:(NSTextAttachment*)textAttachment inRange:(NSRange)characterRange
{

    NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:self.photos];
    [self presentViewController:photoVC animated:YES completion:nil];
}

@end
