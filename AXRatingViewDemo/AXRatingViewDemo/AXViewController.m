//
//  AXViewController.m
//  AXRatingViewDemo
//

#import "AXViewController.h"

@interface AXViewController ()

@end

@implementation AXViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];
  
  CGFloat padding = 70.0;
  CGRect componentBounds = (CGRect){CGPointZero, 160.0, 32.0};
  
  float initialValue = 2.5;
  
  self.label = [[UILabel alloc] initWithFrame:componentBounds];
  _label.center = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) - padding};
  _label.text = [NSString stringWithFormat:@"%f", initialValue];
  
  self.ratingView = [[AXRatingView alloc] initWithFrame:componentBounds];
  _ratingView.markFont = [UIFont systemFontOfSize:32.0];
  [_ratingView sizeToFit];
  _ratingView.center = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds)};
  _ratingView.smoothEditing = NO;
  _ratingView.value = initialValue;
  _ratingView.userInteractionEnabled = YES; // if NO, just showing. default value is YES.
  [_ratingView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
  
  self.slider = [[UISlider alloc] initWithFrame:componentBounds];
  _slider.minimumValue = 0.0;
  _slider.maximumValue = 5.0;
  _slider.value = initialValue;
  _slider.center = (CGPoint){CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) + padding};
  [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
  
  [self.view addSubview:_label];
  [self.view addSubview:_ratingView];
  [self.view addSubview:_slider];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)sliderChanged:(UISlider *)sender
{
  [self.ratingView setValue:[sender value]];
}

- (void)ratingChanged:(AXRatingView *)sender
{
  [self.slider setValue:[sender value]];
  [self.label setText:[NSString stringWithFormat:@"%f", sender.value]];
}

@end
