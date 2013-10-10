//
//  AXRatingView.h
//  AXRatingViewDemo
//
//  Created by Hiroki Akiyama (office) on 2013/10/10.
//  Copyright (c) 2013年 akiroom. All rights reserved.
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
@property (nonatomic, getter = isEditable) BOOL editable;

@end
