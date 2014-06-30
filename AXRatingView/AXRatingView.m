//
//  AXRatingView.m
//

#import "AXRatingView.h"
#import <QuartzCore/QuartzCore.h>

@interface AXRatingView()
@property BOOL pendingNotification;
@end

@implementation AXRatingView

#define TOTAL_WIDTH (self.markImage.size.width * _numberOfStar + _padding * (_numberOfStar-1))

- (void)axRatingViewInit {
  _markCharacter = @"\u2605";
  _markFont = [UIFont systemFontOfSize:22.0];
  _baseColor = [UIColor darkGrayColor];
  self.backgroundColor = _baseColor;
  _highlightColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
  _numberOfStar = 5;
  _stepInterval = 0.0;
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
    self.frame = (CGRect){self.frame.origin, TOTAL_WIDTH, self.markImage.size.height};
}

- (void)drawRect:(CGRect)rect
{
    if (!_starMaskLayer) {
        _starMaskLayer = [self generateMaskLayer];
        self.layer.mask = _starMaskLayer;
        _highlightLayer = [self highlightLayer];
        [self.layer addSublayer:_highlightLayer];
    }
    
    CGFloat selfWidth = TOTAL_WIDTH;
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
      size = [_markCharacter sizeWithFont:_markFont];
    }
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
        [[UIColor blackColor] set];
    if ([_markCharacter respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        [_markCharacter drawAtPoint:CGPointZero
                     withAttributes:@{NSFontAttributeName: _markFont,
                                      NSForegroundColorAttributeName: [UIColor blackColor]}];
    } else {
      [_markCharacter drawAtPoint:CGPointZero withFont:_markFont];
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
    if (self.pendingNotification) {
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    self.pendingNotification = NO;
}

- (void)setValue:(float)value
{
    value = MIN(MAX(value, 0.0), _numberOfStar);
    
    if (value == _value) {
        return;
    }
    _value = value;
    [self setNeedsDisplay];
    
    self.pendingNotification = YES;
    if (self.notifyContinuously) {
        [self notify];
    }
}

- (void)setBaseColor:(UIColor *)baseColor
{
    _baseColor = baseColor;
    self.backgroundColor = _baseColor;
    [self setNeedsDisplay];
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

- (void)setNumberOfStar:(NSUInteger)numberOfStar
{
    _numberOfStar = numberOfStar;
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
        starLayer.position = (CGPoint){markHalfWidth + (markWidth + _padding) * i, markHalfHeight};
        [starMaskLayer addSublayer:starLayer];
    }
    [starMaskLayer setFrame:(CGRect){CGPointZero, TOTAL_WIDTH, _markImage.size.height}];
    return starMaskLayer;
}

- (CALayer *)highlightLayer
{
    CALayer *highlightLayer = [CALayer layer];
    highlightLayer.backgroundColor = _highlightColor.CGColor;
    highlightLayer.bounds = (CGRect){CGPointZero, TOTAL_WIDTH, _markImage.size.height};
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
    float value = location.x / (TOTAL_WIDTH) * _numberOfStar;
    if (_stepInterval != 0.0) {
        if (_stepInterval == 1) {
            value = ceilf(value / _stepInterval) * _stepInterval;
        } else {
            value = roundf(value / _stepInterval) * _stepInterval;
        }
    }
    [self setValue:value];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self notify];
}
@end
