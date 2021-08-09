//
//  PhotoModel.m
//  EGE_2016_History
//
//  Created by Uber on 03/05/2017.
//  Copyright © 2017 MD. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

- (instancetype)initFromUIImageView:(UIImageView*) imgView
{
    self = [super init];
    if (self) {
        if (imgView.image)
            self.image = imgView.image;
    }
    return self;
}

- (instancetype)initFromUIImage:(UIImage*) img
{
    self = [super init];
    if (self) {
        if (img)
            self.image = img;
    }
    return self;
}
@end
