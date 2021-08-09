//
//  ImgAndTitleCellInfoTVC.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "ImgAndTitleCellInfoTVC.h"

@implementation ImgAndTitleCellInfoTVC

- (void)adjust:(CGFloat)offset {
    CGRect frame = self.myImageView.frame;
    frame.origin.y = (offset / 10.0);
    self.myImageView.frame = frame;

}


@end
