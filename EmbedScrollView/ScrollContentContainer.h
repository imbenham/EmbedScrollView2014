//
//  ScrollContentContainer.h
//  EmbedScrollView
//
//  Created by Isaac Benham on 7/7/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ScrollContentContainer : UIView


@property (nonatomic, strong) NSMutableArray *containedViews;
@property (nonatomic, weak) UIScrollView *scrollView;

@end