//
//  AXViewController.h
//  AXRatingViewDemo
//

#import <UIKit/UIKit.h>
#import "AXRatingView.h"

@interface AXViewController : UIViewController
@property (strong ,nonatomic) UILabel *label;
@property (strong, nonatomic) AXRatingView *ratingView;
@property (strong ,nonatomic) UISlider *slider;
@end
