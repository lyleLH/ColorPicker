//
//  ViewController.m
//  PickerDemo
//
//  Created by lyleKP on 2017/7/25.
//  Copyright © 2017年 lyle. All rights reserved.
//

#import "ViewController.h"

#import "MTTColorPicker.h"

@interface ViewController ()<SSColorPickerDelegate>
@property (strong, nonatomic) IBOutlet UIView *colorShowView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    MTTColorPicker * myPicker = [[MTTColorPicker alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    myPicker.center = self.view.center;
    myPicker.delegate = self;
    [self.view addSubview:myPicker];
}


-(void)colorChanged:(UIColor *)color from:(id)sender{
    self.colorShowView.backgroundColor = color;
}

@end
