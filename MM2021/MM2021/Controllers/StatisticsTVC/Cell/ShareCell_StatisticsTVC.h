//
//  ShareCell_StatisticsTVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

@interface ShareCell_StatisticsTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *vkShareButton;
@property (weak, nonatomic) IBOutlet UIButton *fbShareButton;
@property (weak, nonatomic) IBOutlet UIButton *twShareButton;
@property (weak, nonatomic) IBOutlet UIButton *gPlusShareButton;
@property (weak, nonatomic) IBOutlet UIButton *okShareButton;

@property (weak, nonatomic) IBOutlet UIScrollView *customScroll;
@end
