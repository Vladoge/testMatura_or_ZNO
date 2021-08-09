//
//  ResultOfTheAssignmentView.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "ResultOfTheAssignmentView.h"
#import "Chameleon.h"

@implementation ResultOfTheAssignmentView

// Call in awakeFromNib
+ (instancetype)myView:(NSString*) nameXib withFrame:(CGRect) rect
{   // 1.
    UINib *nib   = [UINib nibWithNibName:nameXib bundle:nil];
    ResultOfTheAssignmentView *view = [nib instantiateWithOwner:self options:nil][0];
    view.frame = rect;
    
    return view;
}

- (id)initWithFrame:(CGRect)frame
{   // 2.
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    // 3.
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 5.0f;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{   // 4.
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)awakeFromNib{
    // 5.
    [super awakeFromNib];
    
    self.statusOfTestExecutionLabel.font = [UIFont fontWithName:@"SFUIDisplay-Regular" size:18.0];
    self.numberOfCorrectAnswerLabel.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:18.0];
    self.goToDetailReviewButton.titleLabel.font = [UIFont fontWithName:@"SFUIDisplay-Light" size:17.0];
    self.primaryScoresLabel.font      = [UIFont fontWithName:@"SFUIDisplay-Light" size:18.0];
    
    // - Around Button
    // self.myViewResult.goToDetailReviewButton.layer.cornerRadius  = 20.0f;
    self.goToDetailReviewButton.backgroundColor = [UIColor whiteColor];
    self.goToDetailReviewButton.titleLabel.backgroundColor = [UIColor whiteColor];
    
    [self.goToDetailReviewButton setTitleColor:[UIColor colorWithHexString:@"4286f5"] forState:UIControlStateNormal];
    self.goToDetailReviewButton.layer.borderWidth = 1.0f;
    self.goToDetailReviewButton.layer.borderColor = [UIColor colorWithHexString:@"4286f5"].CGColor;
    
    [self aroundArrayUI_Elements:@[self.statusOfTestExecutionLabel,
                                   self.imageEvaluatingTestResults,
                                   self.numberOfCorrectAnswerLabel,
                                   self.goToDetailReviewButton]];
    
    
}


#pragma mark - Utilits

- (void) aroundArrayUI_Elements:(NSArray*) arrUI {
    
    for (id UIobj in arrUI) {
        if ([UIobj isKindOfClass:[UIView class]]) {
            
            UIView* obj = UIobj;
            obj.layer.masksToBounds = YES;
            obj.layer.cornerRadius  = 5.0f;
        }
    }
}

@end
