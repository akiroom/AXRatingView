//
//  AXRatingView.h
//

#import <UIKit/UIKit.h>

@interface AXRatingView : UIControl {
  CALayer *_starMaskLayer;
  CALayer *_highlightLayer;
}
@property (nonatomic) NSUInteger numberOfStar;
@property (copy, nonatomic) NSString *markCharacter;
@property (copy, nonatomic) UIColor *baseColor;
@property (copy, nonatomic) UIColor *highlightColor;
@property (nonatomic) float value;
@property (nonatomic, getter = isSmoothEditing) BOOL smoothEditing;

@end
