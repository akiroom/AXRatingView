//
//  AXRatingView.m
//

#import "AXRatingView.h"
#import <QuartzCore/QuartzCore.h>

@interface AXRatingView()
- (void)setupComponents;
@end

@implementation AXRatingView

- (id)init
{
  if (self = [super init]) {
    [self setupComponents];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  if (self = [super initWithCoder:aDecoder]) {
    [self setupComponents];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self setupComponents];
  }
  return self;
}

- (void)setupComponents
{
  _markCharacter = @"★";
  _baseColor = [UIColor darkGrayColor];
  self.backgroundColor = _baseColor;
  _highlightColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
  _numberOfStar = 5;
  _smoothEditing = YES;
  
  UITapGestureRecognizer *tapGestureRec =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestured:)];
  UIPanGestureRecognizer *swipeGestureRec =
    [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestured:)];
  [self addGestureRecognizer:tapGestureRec];
  [self addGestureRecognizer:swipeGestureRec];
}

- (void)setNeedsDisplay
{
  [super setNeedsDisplay];
  
}

- (void)drawRect:(CGRect)rect
{
  if (!_starMaskLayer) {
    _starMaskLayer = [self generateMaskLayer];
    self.layer.mask = _starMaskLayer;
    _highlightLayer = [self highlightLayer];
    [self.layer addSublayer:_highlightLayer];
  }
  
  CGFloat selfWidth = CGRectGetWidth(self.bounds);
  CGFloat selfHalfWidth = selfWidth / 2;
  CGFloat offsetX = selfWidth / _numberOfStar * (_numberOfStar - _value);
  _highlightLayer.position = (CGPoint){selfHalfWidth - offsetX, CGRectGetMidY(self.bounds)};
}

- (void)setValue:(float)value
{
  _value = MIN(MAX(value, 0.0), _numberOfStar);
  [self setNeedsDisplay];
}

- (void)setBaseColor:(UIColor *)baseColor
{
  _baseColor = baseColor;
  self.backgroundColor = _baseColor;
  [self setNeedsDisplay];
}

#pragma mark - Operations

- (UIImage *)markImage
{
  UIFont *font = [UIFont systemFontOfSize:32.0];
  CGSize size =[_markCharacter sizeWithAttributes:@{NSFontAttributeName:font}];
  
  UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
  [[UIColor blackColor] set];
  [_markCharacter drawAtPoint:CGPointZero
               withAttributes:@{NSFontAttributeName: font,
                                NSForegroundColorAttributeName: [UIColor blackColor]}];
  UIImage *markImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return markImage;
}

- (CALayer *)generateMaskLayer
{
  // Generate Mask Layer
  UIImage *markImage = [self markImage];
  CGFloat markWidth = markImage.size.width;
  CGFloat markHalfWidth = markWidth / 2;
  CGFloat markHeight = markImage.size.height;
  CGFloat markHalfHeight = markHeight / 2;
  
  CALayer *starMaskLayer = [CALayer layer];
  starMaskLayer.opaque = NO;
  for (int i = 0; i < _numberOfStar; i++) {
    CALayer *starLayer = [CALayer layer];
    starLayer.contents = (id)markImage.CGImage;
    starLayer.bounds = (CGRect){CGPointZero, markImage.size};
    starLayer.position = (CGPoint){markHalfWidth + markWidth * i, markHalfHeight};
    [starMaskLayer addSublayer:starLayer];
  }
  [starMaskLayer setFrame:(CGRect){CGPointZero, markImage.size.width * _numberOfStar, markImage.size.height}];
  return starMaskLayer;
}

- (CALayer *)highlightLayer
{
  CALayer *highlightLayer = [CALayer layer];
  highlightLayer.backgroundColor = _highlightColor.CGColor;
  highlightLayer.bounds = self.bounds;
  highlightLayer.position = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
  return highlightLayer;
}

#pragma mark - Action

- (void)gestured:(UIPanGestureRecognizer *)sender
{
  CGPoint location = [sender locationInView:self];
  float value = location.x / CGRectGetWidth(self.bounds) * _numberOfStar;
  if (_smoothEditing == NO) {
    value = roundf(value);
  }
  [self setValue:value];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
