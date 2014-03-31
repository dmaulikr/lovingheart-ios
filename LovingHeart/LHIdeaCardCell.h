//
//  LHIdeaSmallCell.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/31.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressOverlayView.h"

@interface LHIdeaCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ideaImageView;
@property (weak, nonatomic) IBOutlet UILabel *ideaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaDoneCountLabel;

@property (nonatomic, strong) DAProgressOverlayView *progressOverlayView;

@end
