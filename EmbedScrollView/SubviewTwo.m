//
//  SubviewTwo.m
//  EmbedScrollView
//
//  Created by Isaac Benham on 6/30/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import "SubviewTwo.h"

@implementation SubviewTwo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
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

    CGPoint middle = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGRect tfRect = CGRectMake(middle.x-100, middle.y-15, 200, 30);
    
    self.textField = [[UITextField alloc] initWithFrame:tfRect];
    
    [self addSubview:self.textField];
    
}



@end
