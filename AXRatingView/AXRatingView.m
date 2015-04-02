//
//  AXRatingView.m
//

#import "AXRatingView.h"
#import <QuartzCore/QuartzCore.h>

@interface AXRatingView()
@property BOOL pendingNotification;
@end

@implementation AXRatingView

- (void)axRatingViewInit {
  _markCharacter = @"\u2605";
  _markFont = [UIFont systemFontOfSize:22.0];
  _baseColor = [UIColor darkGrayColor];
  self.backgroundColor = _baseColor;
  _highlightColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
  _numberOfStar = 5;
  _stepInterval = 0.0;
  _minimumValue = 0.0;
}

- (id)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    [self axRatingViewInit];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
  if (self = [super initWithCoder:decoder]) {
    [self axRatingViewInit];
  }
  return self;
}

- (void)sizeToFit
{
  [super sizeToFit];
  self.frame = (CGRect) {
    self.frame.origin, self.intrinsicContentSize
  };
}

- (CGSize)intrinsicContentSize
{
  return CGSizeMake(self.markImage.size.width * _numberOfStar + _padding * (_numberOfStar-1),
                    self.markImage.size.height);
}

- (void)drawRect:(CGRect)rect
{
  if (!_starMaskLayer) {
    _starMaskLayer = [self generateMaskLayer];
    self.layer.mask = _starMaskLayer;
    _highlightLayer = [self highlightLayer];
    [self.layer addSublayer:_highlightLayer];
  }
  
  CGFloat selfWidth = self.intrinsicContentSize.width;
  CGFloat selfHalfWidth = selfWidth / 2;
  CGFloat selfHalfHeight = self.markImage.size.height / 2;
  CGFloat offsetX = selfWidth / _numberOfStar * (_numberOfStar - _value);
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue
                   forKey:kCATransactionDisableActions];
  _highlightLayer.position = (CGPoint){selfHalfWidth - offsetX, selfHalfHeight};
  [CATransaction commit];
}

#pragma mark - Property

- (void)setMarkImageNamed:(NSString*)markImageNamed
{
  [self setMarkImage:[UIImage imageNamed:markImageNamed]];
}

- (UIImage *)markImage
{
  if (_markImage) {
    return _markImage;
  } else {
    CGSize size;
    if ([_markCharacter respondsToSelector:@selector(sizeWithAttributes:)]) {
      size = [_markCharacter sizeWithAttributes:@{NSFontAttributeName:_markFont}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
      size = [_markCharacter sizeWithFont:_markFont];
#pragma clang diagnostic pop
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [[UIColor blackColor] set];
    if ([_markCharacter respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
      [_markCharacter drawAtPoint:CGPointZero
                   withAttributes:@{NSFontAttributeName: _markFont,
                                    NSForegroundColorAttributeName: [UIColor blackColor]}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
      [_markCharacter drawAtPoint:CGPointZero withFont:_markFont];
#pragma clang diagnostic pop
    }
    UIImage *markImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return _markImage = markImage;
  }
}

- (void)setStepInterval:(float)stepInterval
{
  _stepInterval = MAX(stepInterval, 0.0);
}

- (void)notify
{
  /* We only want to trigger events when it's the right time */
  if (self.pendingNotification) {
    [self sendActionsForControlEvents:UIControlEventValueChanged];
  }
  self.pendingNotification = NO;
}

- (void)setValue:(float)value
{
  value = MIN(MAX(value, _minimumValue), _numberOfStar);

  if (value == _value) {
    return;
  }
  _value = value;
  [self setNeedsDisplay];

  /* There is new values */
  self.pendingNotification = YES;
  if (self.notifyContinuously) {
    [self notify];
  }
}

- (void)setBaseColor:(UIColor *)baseColor
{
  if (_baseColor != baseColor) {
    _baseColor = baseColor;
    self.backgroundColor = _baseColor;
    [self setNeedsDisplay];
  }
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
  if (_highlightColor != highlightColor) {
    _highlightColor = highlightColor;
    [_highlightLayer removeFromSuperlayer];
    [_starMaskLayer removeFromSuperlayer];
    _highlightLayer = nil;
    _starMaskLayer = nil;
    [self setNeedsDisplay];
  }
}

- (void)setMarkFontName:(NSString *)markFontName
{
  UIFont * font = [UIFont fontWithName:markFontName size:_markFont.pointSize];
  if (font) {
    self.markFont = font;
  }
}

- (void)setMarkFontSize:(CGFloat)markFontSize
{
  self.markFont = [self.markFont fontWithSize:markFontSize];
}

- (void)setMarkFont:(UIFont *)markFont
{
  if (_markFont != markFont) {
    _markFont = markFont;
    _markImage = nil;
    [self setNeedsDisplay];
  }
}

- (void)setMarkCharacter:(NSString *)markCharacter
{
  if (_markCharacter != markCharacter) {
    _markCharacter = markCharacter;
    _markImage = nil;
    [self setNeedsDisplay];
  }
}

- (void)setNumberOfStar:(NSUInteger)numberOfStar
{
  if (_numberOfStar != numberOfStar) {
    _numberOfStar = numberOfStar;
    [self setNeedsDisplay];
  }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
  if (self.backgroundColor != backgroundColor) {
    if (_baseColor != self.backgroundColor) {
      [super setBackgroundColor:backgroundColor];
    }
  }
}

#pragma mark - Operation

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
    starLayer.position = (CGPoint){markHalfWidth + (markWidth + _padding) * i, markHalfHeight};
    [starMaskLayer addSublayer:starLayer];
  }
  [starMaskLayer setFrame:(CGRect){CGPointZero, self.intrinsicContentSize}];
  return starMaskLayer;
}

- (CALayer *)highlightLayer
{
  CALayer *highlightLayer = [CALayer layer];
  highlightLayer.backgroundColor = _highlightColor.CGColor;
  highlightLayer.bounds = (CGRect){CGPointZero, self.intrinsicContentSize};
  highlightLayer.position = (CGPoint){CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)};
  return highlightLayer;
}

#pragma mark - Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint location = [[touches anyObject] locationInView:self];
  float value = location.x / (self.intrinsicContentSize.width) * _numberOfStar;
  if (_stepInterval != 0.0) {
    if (_stepInterval == 1) {
      value = ceilf(value / _stepInterval) * _stepInterval;
    } else {
      value = roundf(value / _stepInterval) * _stepInterval;
    }
  }
    /* setValue will handle min/max edge cases */
  [self setValue:value];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self notify];
}
@end
