//
//  ImgAndTitleCellInfoTVC.h
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import <UIKit/UIKit.h>

@interface ImgAndTitleCellInfoTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;

- (void)adjust:(CGFloat)offset;

@end
