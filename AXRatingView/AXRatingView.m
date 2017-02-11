//
//  AXRatingView.m
//

#import "AXRatingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AXRatingView {
  CGSize _cachedMarkCharacterSize;
}

- (void)axRatingViewInit {
  _cachedMarkCharacterSize = CGSizeZero;
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

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
  return self.intrinsicContentSize;
}

- (CGSize)intrinsicContentSize
{
  CGSize size;
  if (_markImage) {
    size = _markImage.size;
  } else {
    size = self.markCharacterSize;
  }

  return (CGSize){
    size.width * _numberOfStar,
    size.height
  };
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
  CGFloat selfHalfHeight = self.frame.size.height / 2;
  CGFloat frameOffsetX = (self.frame.size.width - selfWidth) / 2;
  CGFloat offsetX = selfWidth / _numberOfStar * (_numberOfStar - _value);
  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue
                   forKey:kCATransactionDisableActions];
  _highlightLayer.position = (CGPoint){selfHalfWidth - (offsetX - frameOffsetX), selfHalfHeight};
  [CATransaction commit];
}

#pragma mark - Property

- (UIImage *)markImage
{
  if (_markImage) {
    return _markImage;
  } else {
    CGSize size = self.markCharacterSize;

    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
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

- (CGSize)markCharacterSize {
  if (CGSizeEqualToSize(_cachedMarkCharacterSize, CGSizeZero)) {
    CGSize size;
    if ([_markCharacter respondsToSelector:@selector(sizeWithAttributes:)]) {
      size = [_markCharacter sizeWithAttributes:@{NSFontAttributeName:_markFont}];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
      size = [_markCharacter sizeWithFont:_markFont];
#pragma clang diagnostic pop
    }
    _cachedMarkCharacterSize = size;
  }
  return _cachedMarkCharacterSize;
}

- (void)setStepInterval:(float)stepInterval
{
  _stepInterval = MAX(stepInterval, 0.0);
}

- (void)setValue:(float)value
{
  if (_value != value) {
    _value = MIN(MAX(value, 0.0), _numberOfStar);
    [self setNeedsDisplay];
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
    _cachedMarkCharacterSize = CGSizeZero;
    [self invalidateIntrinsicContentSize];
    [self setNeedsDisplay];
  }
}

- (void)setNumberOfStar:(NSUInteger)numberOfStar
{
  if (_numberOfStar != numberOfStar) {
    _numberOfStar = numberOfStar;
    [self invalidateIntrinsicContentSize];
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
    starLayer.position = (CGPoint){markHalfWidth + markWidth * i, markHalfHeight};
    [starMaskLayer addSublayer:starLayer];
  }
  // Calculate start mask layer origins based on the view frame.
  // With this calculation starts would be aligned center in the view's frame
  CGFloat totalStartsWidth = (markWidth * _numberOfStar);
  CGFloat frameOffsetX = (self.frame.size.width - totalStartsWidth) / 2;
  CGFloat frameOffsetY = (self.frame.size.height - _markImage.size.height) / 2;
  [starMaskLayer setFrame:(CGRect){frameOffsetX, frameOffsetY, _markImage.size.width * _numberOfStar, _markImage.size.height}];
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

#pragma mark - Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self touchesMoved:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Because we aligned center we should only accept touches that
    // is in stars region not entire frame rect and then calculate
    // the value based on the frame alignment (frameOffsetX).
    CGPoint location = [[touches anyObject] locationInView:self];
    CGFloat totalStartsWidth = (_markImage.size.width * _numberOfStar);
    CGFloat frameOffsetX = (self.frame.size.width - totalStartsWidth) / 2;
    CGFloat frameOffsetY = (self.frame.size.height - _markImage.size.height) / 2;

    if (CGRectContainsPoint(CGRectMake(frameOffsetX - _markImage.size.width, frameOffsetY, totalStartsWidth + _markImage.size.width, _markImage.size.height), location)) {

        float value = ((location.x - frameOffsetX)/ (_markImage.size.width * _numberOfStar)) * _numberOfStar;
        if (_stepInterval != 0.0) {
            value = MAX(_minimumValue, ceilf(value / _stepInterval) * _stepInterval);
        } else {
            value = MAX(_minimumValue, value);
        }
        [self setValue:value];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
