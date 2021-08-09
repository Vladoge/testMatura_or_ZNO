//
//  DetailAnalyticsTaskTVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "DetailAnalyticsTaskTVC.h"


@interface DetailAnalyticsTaskTVC () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@end

@implementation DetailAnalyticsTaskTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupController];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 160.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.arrYourAnswer count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Количество ячеек в секции всегда будет один, а секций будет много
    // Это нужно для того-чтобы обеспечивать хороший графичиский эффект
    // Liczba komórek w sekcji zawsze będzie wynosić jeden, a sekcji będzie wiele
    // Jest to potrzebne, aby zapewnić dobry efekt graficzny
    // The number of cells in a section will always be one, and there will be many sections
    // This is needed in order to provide a good graphical effect
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
     static NSString* identifier = @"DetailAnalyticsCell";
     DetailAnalyticsCell *cell = (DetailAnalyticsCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
     
     if (!cell) {
          cell = (DetailAnalyticsCell*)[[DetailAnalyticsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
     }
    [self setHiddienStatusAllPropertyCell:YES withCell:cell];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 5.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView) {    
            CGFloat cornerRadius = 5.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 45, 0);
            BOOL addLine = NO;
 
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
      
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+15, bounds.size.height-lineHeight, bounds.size.width-45, lineHeight);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}


#pragma mark - UITableView helper methods

- (void)configureCell:(DetailAnalyticsCell*)cell atIndexPath:(NSIndexPath *)indexPath
{

    [cell.buttonShowTask addTarget:self action:@selector(goToDetailReviewTaskVC:) forControlEvents:UIControlEventTouchUpInside];

    ANDispatchBlockToBackgroundQueue(^{
        YourAnswerAndTaskModel* obj = self.arrYourAnswer[indexPath.section];

        UIFont* fontLight   = [UIFont fontWithName:@"SFUIDisplay-Light"  size:16.f];
        UIFont* fontMedium  = [UIFont fontWithName:@"SFUIDisplay-Medium"  size:18.f];
        UIFont* fontSemi    = [UIFont fontWithName:@"SFUIDisplay-Semibold"  size:18.f];
        
        NSString* tName  = [NSString stringWithFormat:@"%@",obj.modelFullTask.taskName];
        NSString* tYourAnsw = @" Twoja odpowiedz:";
        NSMutableString* tTrueAnsw = [[NSMutableString alloc] init];

        if (obj.yourAnswer)
            tYourAnsw = [NSString stringWithFormat:@"%@ %@", tYourAnsw, obj.yourAnswer];
      
        if (obj.modelFullTask.divideTheAnswerForEachCharacter) {
            for (NSString* answ in obj.modelFullTask.answers)
                [tTrueAnsw appendString:[NSString stringWithFormat:@"%@ ", answ]];
            
        } else if (obj.modelFullTask.onlyOneCorrectAnswer)
            [tTrueAnsw appendString: obj.modelFullTask.answers[0]];
        else if (!(obj.modelFullTask.onlyOneCorrectAnswer && obj.modelFullTask.divideTheAnswerForEachCharacter && obj.modelFullTask.mandatorySequence)){
            
            NSMutableString* strThatConnectTotTrueAnsw = [NSMutableString string];
            for (int i=0; i<=obj.modelFullTask.answers.count-1; i++) {
                [strThatConnectTotTrueAnsw appendString:obj.modelFullTask.answers[i]];
               
                if (i != obj.modelFullTask.answers.count-1)
                    [strThatConnectTotTrueAnsw appendString:@" или "];
            }
            [tTrueAnsw appendString: strThatConnectTotTrueAnsw];
        }
        
        
        ANDispatchBlockToMainQueue(^{
          
            CGFloat WIDTH_SCREEN = CGRectGetWidth(self.view.bounds);
            CGFloat kWidthCloseCouponsFromSizeScreenPercent = 95.f;
            
            cell.frame = CGRectMake(cell.frame.origin.x,
                                    cell.frame.origin.y,
                                    WIDTH_SCREEN/100.0f * kWidthCloseCouponsFromSizeScreenPercent,
                                    cell.frame.size.height);
            cell.center = CGPointMake(CGRectGetWidth(self.view.bounds)/2, cell.center.y);
            
            // Var
            cell.labelTaskName.text   = tName;
            cell.labelYourAnswer.text = tYourAnsw;
            cell.labelTrueAnswer.text =  [NSString stringWithFormat:@"Poprawna odpowiedz: %@", tTrueAnsw]; //tTrueAnsw;
            
            // Fonts
            cell.labelTaskName.font   = fontMedium;
            cell.labelYourAnswer.font = fontLight;
            cell.labelTrueAnswer.font = fontLight;
            
            // Fonts Color
            cell.labelTaskName.textColor   = [UIColor colorWithHexString:@"586059"];
            cell.labelYourAnswer.textColor = [UIColor colorWithHexString:@"474F49"];
            cell.labelTrueAnswer.textColor = [UIColor colorWithHexString:@"474F49"];
           
            cell.labelTaskName.backgroundColor = [UIColor colorWithHexString:@"F9ECC0"]; // !!!!
            cell.labelYourAnswer.backgroundColor = [UIColor colorWithHexString:@"F9ECC0"]; // !!!!
            cell.labelTrueAnswer.backgroundColor = [UIColor colorWithHexString:@"F9ECC0"]; // !!!!


            if (obj.yourAnswer) {
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:cell.labelYourAnswer.text];
                NSRange rangeYourAnsw  = [cell.labelYourAnswer.text rangeOfString: obj.yourAnswer];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range: rangeYourAnsw];
                [attString addAttribute:NSFontAttributeName            value:fontSemi             range: rangeYourAnsw];
                
                if (rangeYourAnsw.location != NSNotFound)
                {
                    if (obj.answerIsCorrect)
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor flatGreenColor] range: rangeYourAnsw];
                    else
                        [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]   range: rangeYourAnsw];
                }
                [cell.labelYourAnswer setAttributedText:attString];
            }
            
            // Buttons
            cell.buttonShowTask.backgroundColor = [UIColor colorWithHexString:@"FFD951"]; // Green from screen
            cell.buttonShowTask.titleLabel.font = fontLight;
            [cell.buttonShowTask setTitleColor:[UIColor colorWithHexString:@"586059"] forState:UIControlStateNormal];
            cell.buttonShowTask.layer.masksToBounds = YES;
            cell.buttonShowTask.layer.cornerRadius  = 7.f;
            cell.buttonShowTask.titleLabel.backgroundColor = [UIColor colorWithHexString:@"FFD951"]; // !!!!
            cell.imageOnButton.backgroundColor = [UIColor colorWithHexString:@"FFD951"]; // !!!!!
            
            // ContentView
            cell.contentView.layer.masksToBounds = YES;
            cell.contentView.layer.cornerRadius  = 7.f;
            
            // Layer
            [cell.layer setCornerRadius:7.0f];
            [cell.layer setMasksToBounds:NO];
    
            cell.layer.shadowColor   = [UIColor blackColor].CGColor;
            cell.layer.shadowOffset  = CGSizeMake(0.0f, 2.0f);
            cell.layer.shadowOpacity = 0.2f;
            cell.layer.shadowRadius  = 2.0f;
            [cell.layer setShadowPath:[UIBezierPath bezierPathWithRect:cell.bounds].CGPath];
            
            cell.contentView.backgroundColor = [UIColor colorWithHexString:@"F9ECC0"];

            [self setHiddienStatusAllPropertyCell:NO withCell:cell];
        });
    });
}

#pragma mark - UI initialization

-(void) initialSetupController
{
    // Table Setup
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"ADC6B3"];
    
    // Navigation Setup
    [Utilities setBackButtonInNavigationBarWithController:self
                                       withNavigationItem:self.navigationItem
                                                      sel:@selector(popCurrentViewController)];
    self.navigationItem.title = @"Szegoly testu";
    
}


-(void) setHiddienStatusAllPropertyCell:(BOOL) isHidden withCell:(DetailAnalyticsCell*) cell
{
    if([cell isKindOfClass:[DetailAnalyticsCell class]]){
        cell.labelTaskName.hidden   = isHidden;
        cell.labelYourAnswer.hidden = isHidden;
        cell.labelTrueAnswer.hidden = isHidden;
        cell.buttonShowTask.hidden  = isHidden;
        cell.imageOnButton.hidden   = isHidden;
    }
}

#pragma mark - Action

-(void)  goToDetailReviewTaskVC:(UIButton*) sender {
    
    DetailAnalyticsCell* cell = (DetailAnalyticsCell*)[sender superTableViewCell];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];

    
    DetailReviewTaskVC* detailReviewTask = [[DetailReviewTaskVC alloc] init];
    detailReviewTask.currentYourAnswerAndModel = [[YourAnswerAndTaskModel alloc] init];
    detailReviewTask.currentYourAnswerAndModel = self.arrYourAnswer[indexPath.section];
    
    [self.navigationController pushViewController:detailReviewTask animated:YES];

}

- (void)popCurrentViewController {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
