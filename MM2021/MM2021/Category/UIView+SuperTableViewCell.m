//
//  UIView+SuperTableViewCell.m
//  MM
//
//  Created by Vlad Koval on 23.03.2021.
//

#import "UIView+SuperTableViewCell.h"

@implementation UIView (SuperTableViewCell)

-(UITableViewCell*) superTableViewCell {
    
    if ([self isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell*)self;
    }
    
    if (!self.superview) {
        return nil;
    }
    
    return [self.superview superTableViewCell];
}


@end
