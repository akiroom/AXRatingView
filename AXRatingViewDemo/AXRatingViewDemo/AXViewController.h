//
//  AXViewController.h
//  AXRatingViewDemo
//
//  Created by Hiroki Akiyama (office) on 2013/10/10.
//  Copyright (c) 2013年 akiroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXRatingView.h"

@interface AXViewController : UIViewController
@property (strong ,nonatomic) UILabel *label;
@property (strong, nonatomic) AXRatingView *ratingView;
@property (strong ,nonatomic) UISlider *slider;
@end
