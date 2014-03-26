//
//  LHIdeaCardViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/3/26.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHIdeaCardViewController.h"

@interface LHIdeaCardViewController ()

@end

@implementation LHIdeaCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  self.ideaCardImageView.clipsToBounds = YES;
  if (self.idea.graphicPointer) {
    PFFile* file = (PFFile*)self.idea.graphicPointer.imageFile;
    __block UIImageView *__cardImageView = self.ideaCardImageView;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
      if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        __cardImageView.image = image;
        [__cardImageView setNeedsDisplay];
      }
    }];
  }
  
  [_categoryTitleLabel setText:self.idea.categoryPointer.Name];
  [_ideaTitleLabel setText:self.idea.Name];
  [_ideaContentLabel setText:self.idea.Description];
  
  [self.ideaContentLabel setNumberOfLines:0];
  [self.ideaContentLabel sizeToFit];
  
  
}

- (void)viewDidLayoutSubviews {
  [_contentScrollView setContentSize:CGSizeMake(320, 540)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
