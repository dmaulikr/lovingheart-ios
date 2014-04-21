//
//  LHStoyImageTableViewCell.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/21.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressOverlayView.h"

@interface LHStoryImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (nonatomic, strong) DAProgressOverlayView *progressOverlayView;

@end
