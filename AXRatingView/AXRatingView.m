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
  _markFont = [UIFont systemFontOfSize:16.0];
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

- (void)sizeToFit
{
//  [super sizeToFit];
  [self setNeedsDisplay];
  self.frame = (CGRect){self.frame.origin, self.markImage.size.width * _numberOfStar, self.markImage.size.height};
}

- (void)drawRect:(CGRect)rect
{
  if (!_starMaskLayer) {
    _starMaskLayer = [self generateMaskLayer];
    self.layer.mask = _starMaskLayer;
    _highlightLayer = [self highlightLayer];
    [self.layer addSublayer:_highlightLayer];
  }
  
  CGFloat selfWidth = (self.markImage.size.width * _numberOfStar);
  CGFloat selfHalfWidth = selfWidth / 2;
  CGFloat selfHalfHeight = self.markImage.size.height / 2;
  CGFloat offsetX = selfWidth / _numberOfStar * (_numberOfStar - _value);
  _highlightLayer.position = (CGPoint){selfHalfWidth - offsetX, selfHalfHeight};
}

#pragma mark - Property

- (UIImage *)markImage
{
  if (_markImage) {
    return _markImage;
  } else {
    CGSize size =[_markCharacter sizeWithAttributes:@{NSFontAttributeName:_markFont}];
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [[UIColor blackColor] set];
    [_markCharacter drawAtPoint:CGPointZero
                 withAttributes:@{NSFontAttributeName: _markFont,
                                  NSForegroundColorAttributeName: [UIColor blackColor]}];
    UIImage *markImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _markImage = markImage;
  }
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

- (void)setMarkFont:(UIFont *)markFont
{
  _markFont = markFont;
  _markImage = nil;
  [self setNeedsDisplay];
}

- (void)setMarkCharacter:(NSString *)markCharacter
{
  _markCharacter = markCharacter;
  _markImage = nil;
  [self setNeedsDisplay];
}


#pragma mark - Operations

- (CALayer *)generateMaskLayer
{
  // Generate Mask Layer
  _markImage = [self markImage];
  CGFloat markWidth = _markImage.size.width;
  CGFloat markHalfWidth = markWidth / 2;
  CGFloat markHeight = _markImage.size.height;
  CGFloat markHalfHeight = markHeight / 2;
  
  CALayer *starMaskLayer = [CALayer layer];
  starMaskLayer.opaque = NO;
  for (int i = 0; i < _numberOfStar; i++) {
    CALayer *starLayer = [CALayer layer];
    starLayer.contents = (id)_markImage.CGImage;
    starLayer.bounds = (CGRect){CGPointZero, _markImage.size};
    starLayer.position = (CGPoint){markHalfWidth + markWidth * i, markHalfHeight};
    [starMaskLayer addSublayer:starLayer];
  }
  [starMaskLayer setFrame:(CGRect){CGPointZero, _markImage.size.width * _numberOfStar, _markImage.size.height}];
  return starMaskLayer;
}

- (CALayer *)highlightLayer
{
  CALayer *highlightLayer = [CALayer layer];
  highlightLayer.backgroundColor = _highlightColor.CGColor;
  highlightLayer.bounds = (CGRect){CGPointZero, _markImage.size.width * _numberOfStar, _markImage.size.height};
  highlightLayer.position = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
  return highlightLayer;
}

#pragma mark - Action

- (void)gestured:(UIPanGestureRecognizer *)sender
{
  CGPoint location = [sender locationInView:self];
  float value = location.x / (_markImage.size.width * _numberOfStar) * _numberOfStar;
  if (_smoothEditing == NO) {
    value = roundf(value);
  }
  [self setValue:value];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
