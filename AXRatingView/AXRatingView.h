//
//  AXRatingView.h
//

#import <UIKit/UIKit.h>

@protocol AXRatingViewDelegateProtocol;

@interface AXRatingView : UIControl {
  CALayer *_starMaskLayer;
  CALayer *_highlightLayer;
  UIImage *_markImage;
}
@property (weak, nonatomic) id<AXRatingViewDelegateProtocol> delegate;
@property (nonatomic) NSUInteger numberOfStar;
@property (copy, nonatomic) NSString *markCharacter;
@property (strong, nonatomic) UIFont *markFont;
@property (strong, nonatomic) UIImage *markImage;
@property (strong, nonatomic) UIColor *baseColor;
@property (strong, nonatomic) UIColor *highlightColor;
@property (nonatomic) float value;
@property (nonatomic) float stepInterval;
@property (nonatomic) float minimumValue;

@end


@protocol AXRatingViewDelegateProtocol

-(void)didUpdateRatingWithValue:(CGFloat)value;

@end
