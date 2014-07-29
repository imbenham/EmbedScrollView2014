//
//  EmbeddedScrollViewControllerDemo.h
//  EmbedScrollView
//
//  Created by Isaac Benham on 6/30/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubviewOne.h"
#import <QuartzCore/QuartzCore.h>
//#import <CALayer.h>

@interface EmbeddedScrollViewControllerDemo : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, SubviewOneDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;


@end
