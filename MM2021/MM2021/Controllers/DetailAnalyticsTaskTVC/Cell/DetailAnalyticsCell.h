//
//  DetailAnalyticsCell.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

@interface DetailAnalyticsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTaskName;
@property (weak, nonatomic) IBOutlet UILabel *labelYourAnswer;
@property (weak, nonatomic) IBOutlet UILabel *labelTrueAnswer;

@property (weak, nonatomic) IBOutlet UIButton *buttonShowTask;
@property (weak, nonatomic) IBOutlet UIImageView *imageOnButton;

@end
