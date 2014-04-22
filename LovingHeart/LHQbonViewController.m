//
//  LHQbonViewController.m
//  LovingHeart
//
//  Created by Edward Chiang on 2014/4/22.
//  Copyright (c) 2014年 LovineHeart. All rights reserved.
//

#import "LHQbonViewController.h"

@interface LHQbonViewController ()

@end

@implementation LHQbonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
  self.qbon = [[Qbon alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.qbon.frame = self.view.frame;
  [self.view addSubview:self.qbon];
  
  [self.qbon openOfferWall];
  
  
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
