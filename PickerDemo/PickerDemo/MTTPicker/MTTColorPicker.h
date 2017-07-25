//
//  MTTColorPicker.h
//  ColorPicker
//
//  Created by lyleKP on 2017/7/25.
//  Copyright © 2017年 Software Smoothie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTouchView.h"
#import "SSTouchViewNoTransparent.h"

#import "ColourUtils.h"

/** @def CC_RADIANS_TO_DEGREES
 converts radians to degrees
 */
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 57.29577951f) // PI * 180

/** @def CC_DEGREES_TO_RADIANS
 converts degrees to radians
 */
#define CC_DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180


@protocol SSColorPickerDelegate <NSObject>

- (void)colorChanged:(UIColor *)color from:(id)sender;
@end


typedef void(^MTTcolorBlcok)(UIColor *color);

@interface MTTColorPicker : UIView

@property (nonatomic,assign)MTTcolorBlcok newColorResult;

@property (weak,nonatomic) id<SSColorPickerDelegate> delegate;

-(void) setColor:(UIColor *)color;

@end
