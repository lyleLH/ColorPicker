//
//  MTTColorPicker.m
//  ColorPicker
//
//  Created by lyleKP on 2017/7/25.
//  Copyright © 2017年 Software Smoothie. All rights reserved.
//

#import "MTTColorPicker.h"


@interface MTTColorPicker ()<SSTouchViewDelegate>


@property (strong, nonatomic)  UIImageView *colorSelector;
@property (strong, nonatomic)  SSTouchViewNoTransparent *huebkgd;
@property (strong, nonatomic)  SSTouchView *overlay;

@property (assign,nonatomic) CGFloat saturation;
@property (assign,nonatomic) CGFloat brightness;
@property (assign,nonatomic) CGFloat percentage;
@property (assign,nonatomic) int boxPos;
@property (assign,nonatomic) int boxSize;
@property (strong,nonatomic) ColourUtils *colorUtils;


@end

@implementation MTTColorPicker


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setBoxPos:35];	// starting position of the virtual box area for picking a colour
        [self setBoxSize:165];	// the size (width and height) of the virtual box for picking a colour from
        [self setColorUtils:[ColourUtils sharedInstance]];
        [self setBrightness:1.0];
        [self setSaturation:1.0];
        [self setPercentage:0.0];
        
        self.huebkgd = [[SSTouchViewNoTransparent alloc] initWithFrame:frame];
        self.huebkgd.image = [UIImage imageNamed:@"paletteColor.png"];
        self.huebkgd.userInteractionEnabled = YES;
        self.huebkgd.delegate =self;
        [self addSubview:self.huebkgd];
        self.huebkgd.tag = 7;
        
        self.overlay = [[SSTouchView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width *0.50, frame.size.height *0.50)];
        self.overlay.center = self.center;
        self.overlay.image = [UIImage imageNamed:@"colorPickerOverlay.png"];
        self.overlay.userInteractionEnabled = YES;
        self.overlay.delegate =self;
        [self addSubview:self.overlay];
        self.overlay.tag = 10;
        
        self.colorSelector = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width , self.center.y, frame.size.width *0.50*0.50, frame.size.width *0.50*0.50)];
        self.colorSelector.image = [UIImage imageNamed:@"colorPicker.png"];
        self.colorSelector.userInteractionEnabled = NO;
        
        [self addSubview:self.colorSelector];
        
        [self setColor:[UIColor redColor]];
    }
    return self;
    
}


- (void)setColor:(UIColor *)color
{
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;
    
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    
    [self setPercentage:h];
    [self setSaturation:s];
    [self setBrightness:b];
    
    [self updateWithPercentage:[self percentage]];
    
    [self colorChanged];
}


-(void) updateWithPercentage:(CGFloat)newPercentage
{
    // clamp the position of the icon within the circle
    
    // get the center point of the bkgd image
    float centerX		= self.huebkgd.bounds.size.width*.5;
    float centerY		= self.huebkgd.bounds.size.height*.5;
    
    // work out the limit to the distance of the picker when moving around the hue bar
//    float limit			= self.huebkgd.bounds.size.width*.5 - 11;
    float limit			= self.huebkgd.bounds.size.width*.5 - 35;
    
    // update angle
    float angleDeg		= (newPercentage * 360.0f) - 180.0f;
    float angle			= CC_DEGREES_TO_RADIANS(angleDeg);
    
    // set new position of the slider
    float x				= centerX + limit * cosf(angle);
    float y				= centerY + limit * sinf(angle);
    
    [self.colorSelector setCenter:[[self huebkgd] convertPoint:CGPointMake(x, y) toView:self]];
//    NSLog(@"移动取色器在圆环上的位置");
    // update percentage reference
    [self setPercentage:newPercentage];
}

- (void)colorChanged
{
     [[self delegate] colorChanged:[UIColor colorWithHue:[self percentage] saturation:[self saturation] brightness:[self brightness] alpha:1.0f] from:self];
    
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event from:(id)sender
{
    UITouch *touch = [touches anyObject];
    CGPoint location;
    if ([(SSTouchView *)sender tag] == 7) {
        location = [touch locationInView:[self huebkgd]];	// get the touch position
        [self checkHuePosition:location];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event from:(id)sender
{
    UITouch *touch = [touches anyObject];
    CGPoint location;
    if ([(SSTouchView *)sender tag] == 10) {
        location = [touch locationInView:[self huebkgd]];	// get the touch position
        [self checkHuePosition:location];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event from:(id)sender
{
    //
}

-(void)checkHuePosition:(CGPoint)location
{
    if (CGRectContainsPoint(self.huebkgd.bounds, location))
    {
        [self updateHuePosition:location];
        [self colorChanged];
    }
}


-(void)updateHuePosition:(CGPoint)sliderPosition
{
    // clamp the position of the icon within the circle
    
    // get the center point of the bkgd image
    float centerX		= self.huebkgd.bounds.size.width*.5;
    float centerY		= self.huebkgd.bounds.size.height*.5;
    
    // work out the distance difference between the location and center
    float dx			= sliderPosition.x - centerX;
    float dy			= sliderPosition.y - centerY;
    
    // update angle by using the direction of the location
    float angle			= atan2f(dy, dx);
    float angleDeg		= CC_RADIANS_TO_DEGREES(angle)+180;
    
    // use the position / slider width to determin the percentage the dragger is at
    self.percentage		= angleDeg/360.0f;
    
    [self updateWithPercentage:[self percentage]];
}


@end
