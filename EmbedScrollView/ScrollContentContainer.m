//
//  ScrollContentContainer.m
//  EmbedScrollView
//
//  Created by Isaac Benham on 7/7/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScrollContentContainer.h"

@interface ScrollContentContainer ()

@end

@implementation ScrollContentContainer



-(void)layoutSubviews{
    // each time this container view is laid out, it goes through its list of subviews and sets their frames in relation to the scroll view it's a subview of
    if (![self.subviews count]>0){
        for (UIView *view in self.containedViews) {
            [self addSubview:view];
        }
    }
    
    for (UIView *view in self.containedViews) {
        CGFloat yOffset = self.scrollView.bounds.size.height * [self.containedViews indexOfObject:view];
        CGRect viewRect = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+yOffset, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        
        [view setFrame:viewRect];
    }
}






@end