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
  
  CGFloat padding = 36.0;
  CGRect componentBounds = (CGRect){
    padding, padding,
    CGRectGetWidth(self.view.bounds) - padding * 2, 32.0
  };
  __block NSUInteger positionCounter = 0;
  
  CGRect (^nextFrame)() = ^CGRect() {
    return CGRectOffset(componentBounds, 0.0, padding * ++positionCounter);
  };

  // Smooth

  UILabel *basicLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  basicLabel.text = @"Smooth";
  [self.view addSubview:basicLabel];

  AXRatingView *basicRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [basicRatingView sizeToFit];
  [self.view addSubview:basicRatingView];

  // Step

  UILabel *stepLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  stepLabel.text = @"Step";
  [self.view addSubview:stepLabel];

  AXRatingView *stepRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [stepRatingView sizeToFit];
  [stepRatingView setSmoothEditing:NO];
  [self.view addSubview:stepRatingView];

  // Not editable

  UILabel *notEditableLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  notEditableLabel.text = @"Not editable";
  [self.view addSubview:notEditableLabel];

  AXRatingView *notEditableRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [notEditableRatingView sizeToFit];
  [notEditableRatingView setUserInteractionEnabled:NO];
  [notEditableRatingView setValue:4.0];
  [self.view addSubview:notEditableRatingView];

  // Set and get

  self.label = [[UILabel alloc] initWithFrame:nextFrame()];
  [self.view addSubview:_label];
  
  self.ratingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  _ratingView.markFont = [UIFont systemFontOfSize:32.0];
  _ratingView.smoothEditing = NO;
  _ratingView.value = 2.5;
  _ratingView.userInteractionEnabled = YES; // if NO, just showing. default value is YES.
  [_ratingView addTarget:self action:@selector(ratingChanged:) forControlEvents:UIControlEventValueChanged];
  [_ratingView sizeToFit];
  [self.view addSubview:_ratingView];
  
  self.slider = [[UISlider alloc] initWithFrame:nextFrame()];
  _slider.minimumValue = 0.0;
  _slider.maximumValue = 5.0;
  [_slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
  [self.view addSubview:_slider];
  [self ratingChanged:self.ratingView];
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
  [self.label setText:[NSString stringWithFormat:@"Set and Get Sample: %.2f", sender.value]];
}

@end
