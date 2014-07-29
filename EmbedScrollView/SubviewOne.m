//
//  SubviewOne.m
//  EmbedScrollView
//
//  Created by Isaac Benham on 6/30/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import "SubviewOne.h"
@interface SubviewOne ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation SubviewOne

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.button addTarget:self.delegate action:@selector(handleButtonPush:) forControlEvents:UIControlEventTouchUpInside];
        [self.button setTitle:@"PushMe" forState:UIControlStateNormal];
        [self.button setBackgroundColor: [UIColor whiteColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews{
    
    if (![self.subviews count]){
        CGPoint middle = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGRect buttonRect = CGRectMake(middle.x-35, middle.y-25, 70, 50);
        [self.button setFrame:buttonRect];
        [self addSubview:self.button];
    } else {
        self.button.center = self.center;
    }
}

@end
