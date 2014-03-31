//
//  LHIdeaViewCell.h
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressOverlayView.h"

@interface LHIdeaFeatureViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ideaCardTitleImageView;
@property (weak, nonatomic) IBOutlet UILabel *ideaCardTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ideaImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ideaContentLabel;

@property (nonatomic, strong) DAProgressOverlayView *progressOverlayView;

@end
