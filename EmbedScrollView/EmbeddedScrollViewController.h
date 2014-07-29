//
//  EmbeddedScrollViewController.h
//  VetSports
//
//  Created by Isaac Benham on 6/26/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmbeddedScrollView.h"
#import "EventsPickerView.h"

@interface EmbeddedScrollViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, EventsPickerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;


@end
