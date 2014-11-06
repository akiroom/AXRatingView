//
//  AXPropertiesViewController.m
//  AXRatingViewDemo
//

#import "AXPropertiesViewController.h"

@implementation AXPropertiesViewController {
  AXRatingView *_setColorRatingView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Properties";
  self.view.backgroundColor = [UIColor whiteColor];
  
  if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }

  CGFloat padding = 24.0;
  CGRect componentBounds = (CGRect){
    padding, 0.0,
    CGRectGetWidth(self.view.bounds) - padding * 2, 32.0
  };
  __block NSUInteger positionCounter = 0;
  
  CGRect (^nextFrame)() = ^CGRect() {
    return CGRectOffset(componentBounds, 0.0, padding * positionCounter++);
  };

  // smooth

  UILabel *basicLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  basicLabel.text = @"smooth";
  [self.view addSubview:basicLabel];

  AXRatingView *basicRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [basicRatingView sizeToFit];
  [self.view addSubview:basicRatingView];
  
  // step
  
  UILabel *stepLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  stepLabel.text = @"step";
  [self.view addSubview:stepLabel];
  
  AXRatingView *stepRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [stepRatingView sizeToFit];
  [stepRatingView setStepInterval:1.0];
  [self.view addSubview:stepRatingView];
  
  // half step
  
  UILabel *halfStepLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  halfStepLabel.text = @"half step";
  [self.view addSubview:halfStepLabel];
  
  AXRatingView *halfStepRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [halfStepRatingView sizeToFit];
  [halfStepRatingView setStepInterval:0.5];
  [self.view addSubview:halfStepRatingView];
  
  // unicode character
  
  UILabel *freeCharacterLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  freeCharacterLabel.text = @"unicode character";
  [self.view addSubview:freeCharacterLabel];
  
  AXRatingView *freeCharacterRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [freeCharacterRatingView setMarkCharacter:@"\u263B"];
  freeCharacterRatingView.markFont = [UIFont systemFontOfSize:18.0];
  [freeCharacterRatingView sizeToFit];
  [self.view addSubview:freeCharacterRatingView];
  
  // image
  
  UILabel *freeImageLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  freeImageLabel.text = @"image";
  [self.view addSubview:freeImageLabel];
  
  AXRatingView *freeImageRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [freeImageRatingView setMarkImage:[UIImage imageNamed:@"face"]];
  [freeImageRatingView sizeToFit];
  [self.view addSubview:freeImageRatingView];
  
  // color
  
  UILabel *setColorLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  setColorLabel.text = @"color";
  [self.view addSubview:setColorLabel];
  
  AXRatingView *setColorRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [setColorRatingView sizeToFit];
  [setColorRatingView setBaseColor:[UIColor orangeColor]];
  [setColorRatingView setHighlightColor:[UIColor greenColor]];
  [self.view addSubview:setColorRatingView];
  _setColorRatingView = setColorRatingView;
  
  UIButton *changeColorButton = [UIButton buttonWithType:UIButtonTypeSystem];
  [changeColorButton setTitle:@"change" forState:UIControlStateNormal];
  [changeColorButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
  [changeColorButton setFrame:(CGRect){
    CGRectGetMaxX(setColorRatingView.frame), CGRectGetMinY(setColorRatingView.frame),
    160.0, CGRectGetHeight(setColorRatingView.frame)
  }];
  [self.view addSubview:changeColorButton];
  
  // not editable
  
  UILabel *notEditableLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  notEditableLabel.text = @"not editable";
  [self.view addSubview:notEditableLabel];
  
  AXRatingView *notEditableRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [notEditableRatingView sizeToFit];
  [notEditableRatingView setUserInteractionEnabled:NO];
  [notEditableRatingView setValue:4.0];
  [self.view addSubview:notEditableRatingView];

  // minimum value

  UILabel *minValueLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  minValueLabel.text = @"minimum value (no less than 2.0)";
  [self.view addSubview:minValueLabel];

  AXRatingView *minValueRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [minValueRatingView sizeToFit];
  [minValueRatingView setValue:4.0f];
  [minValueRatingView setMinimumValue:2.0f];
  [self.view addSubview:minValueRatingView];

  // more stars
  
  UILabel *moreStarsLabel = [[UILabel alloc] initWithFrame:nextFrame()];
  moreStarsLabel.text = @"more stars";
  [self.view addSubview:moreStarsLabel];
  
  AXRatingView *moreStarsRatingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  [moreStarsRatingView setNumberOfStar:12];
  [moreStarsRatingView sizeToFit];
  [self.view addSubview:moreStarsRatingView];

  // set and get

  self.label = [[UILabel alloc] initWithFrame:nextFrame()];
  [self.view addSubview:_label];
  
  self.ratingView = [[AXRatingView alloc] initWithFrame:nextFrame()];
  _ratingView.stepInterval = 0.0;
  _ratingView.value = 2.5;
  _ratingView.userInteractionEnabled = YES;
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

#pragma mark - Action

- (void)sliderChanged:(UISlider *)sender
{
  [self.ratingView setValue:[sender value]];
  [self.label setText:[NSString stringWithFormat:@"set and get: %.2f", sender.value]];
}

- (void)ratingChanged:(AXRatingView *)sender
{
  [self.slider setValue:[sender value]];
  [self.label setText:[NSString stringWithFormat:@"set and get: %.2f", sender.value]];
}

- (void)changeColor:(id)sender
{
  [_setColorRatingView setBaseColor:[UIColor colorWithRed:rand() % 255 / 255.0
                                                    green:rand() % 255 / 255.0
                                                     blue:rand() % 255 / 255.0
                                                    alpha:1.0]];
  [_setColorRatingView setHighlightColor:[UIColor colorWithRed:rand() % 255 / 255.0
                                                         green:rand() % 255 / 255.0
                                                          blue:rand() % 255 / 255.0
                                                         alpha:1.0]];
}

@end
