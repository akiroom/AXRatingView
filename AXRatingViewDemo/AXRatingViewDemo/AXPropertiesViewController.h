//
//  AXPropertiesViewController.h
//  AXRatingViewDemo
//

#import <UIKit/UIKit.h>
#import "AXRatingView/AXRatingView.h"

@interface AXPropertiesViewController : UIViewController

@property (strong ,nonatomic) UILabel *label;
@property (strong, nonatomic) AXRatingView *ratingView;
@property (strong ,nonatomic) UISlider *slider;

@end
