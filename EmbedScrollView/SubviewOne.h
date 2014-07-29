//
//  SubviewOne.h
//  EmbedScrollView
//
//  Created by Isaac Benham on 6/30/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubviewOneDelegate <NSObject>

@required

@optional

-(void)handleButtonPush:(id)sender;

@end

@interface SubviewOne : UIView

@property (nonatomic, weak) id <SubviewOneDelegate> delegate;



@end
