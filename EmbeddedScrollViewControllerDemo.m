//
//  EmbeddedScrollViewControllerDemo.m
//  EmbedScrollView
//
//  Created by Isaac Benham on 6/30/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import "EmbeddedScrollViewControllerDemo.h"

#import "EmbeddedScrollViewControllerDemo.h"
#import "ScrollContentContainer.h"
#import "SubviewOne.h"
#import "SubviewTwo.h"
#import "SubviewThree.h"


@interface EmbeddedScrollViewControllerDemo ()
{
    CGFloat widthOffset;
    int currentContainerPosition;
}
@property (nonatomic, strong) ScrollContentContainer *contentView;
@property (nonatomic, strong) UIButton *pageDownButton;
@property (nonatomic, strong)  UIButton *topButton;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic) CGFloat buttonHeight;

-(NSUInteger)numContainedViews;
-(void)layoutLabelsAndButtons;
-(void)refreshLabelsAndButtons;
-(void)pageDown:(id)sender;
-(void)pageUp:(id)sender;
-(void)finish:(id)sender;
@end

@implementation EmbeddedScrollViewControllerDemo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor blackColor]];
        
        // set the container position ot 0
        currentContainerPosition = 0;
        
        // we will set the frames for all these subviews later
        self.pageDownButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.searchButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.topLabel= [[UILabel alloc] init];
        self.topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        // set the height of the buttons to be used in layout
        self.buttonHeight =40;
    }
    return self;
}

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame: [UIScreen mainScreen].bounds];
    
    CGRect scrollRect;
    CGSize containerSize;
   
    containerSize.height = self.view.bounds.size.height * .6;
    containerSize.width = self.view.bounds.size.width*.9;
    
    widthOffset = (self.view.bounds.size.width - containerSize.width) / 2;
    const CGFloat heightOffset = widthOffset+self.buttonHeight;
    
    // initialize the sv
    scrollRect = CGRectMake(self.view.bounds.origin.x+widthOffset, self.view.bounds.origin.y+heightOffset, containerSize.width, containerSize.height);
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollRect];
    
    // we would normally create and assign the subview array from outside this class
    NSMutableArray *cVs;
    
    SubviewOne *sv1 = [[SubviewOne alloc] init];
    [sv1 setDelegate:self];
    SubviewTwo *sv2 = [[SubviewTwo alloc] init];
    [sv2.textField setDelegate:self];
    SubviewThree *sv3 = [[SubviewThree alloc] init];
    
    cVs = [@[sv1, sv2, sv3] mutableCopy];
    
    // now initialize the content view and set cVs as its containedViews property:
    // the height of the content view is a function of the number of subviews
    CGFloat contentHeight = (self.scrollView.bounds.size.height+heightOffset)*[cVs count];
    CGRect contentFrame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, containerSize.width, contentHeight);
    self.contentView = [[ScrollContentContainer alloc] initWithFrame:contentFrame];
    self.contentView.scrollView = self.scrollView;
    
    self.contentView.containedViews = cVs;
    
    [self.scrollView addSubview:self.contentView];
    [self.scrollView setContentSize:self.contentView.bounds.size];
    [self.view addSubview:self.scrollView];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    // set the view below the nav bar
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    

    [self.scrollView setDelegate:self];
    // scroll animations will be triggered by buttons, so don't need scroll enabled
    [self.scrollView setScrollEnabled:NO];
    [self.scrollView setAutoresizesSubviews:NO];
    
    // this is just so we can see if our subviews are not filling up the visible content
    [self.scrollView setBackgroundColor:[UIColor yellowColor]];
    [self.scrollView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.scrollView.layer setBorderWidth:7.5];
}

-(NSUInteger)numContainedViews{
    return [self.contentView.containedViews count];
}

-(void)viewWillLayoutSubviews{
    
    // set up the geometry of the scroll view and its position within the view
    CGRect scrollRect;
    CGSize containerSize;
    CGFloat heightOffset;
    if ([[UIApplication sharedApplication] statusBarOrientation] ==UIDeviceOrientationPortrait){
        
        containerSize.height = self.view.bounds.size.height * .6;
        containerSize.width = self.view.bounds.size.width*.9;
        
        widthOffset = (self.view.bounds.size.width - containerSize.width) / 2;
        heightOffset = widthOffset+self.buttonHeight;
        
        scrollRect = CGRectMake(self.view.bounds.origin.x+widthOffset, self.view.bounds.origin.y+heightOffset, containerSize.width, containerSize.height);
        
    } else {
        containerSize.height = self.view.bounds.size.height * .7;
        containerSize.width = self.view.bounds.size.height*.9;
       
        
        widthOffset = self.view.bounds.size.height - (containerSize.width / 2);
        heightOffset = self.view.bounds.origin.y+self.buttonHeight+5;
        //CGFloat maxX = CGRectGetMaxX(self.view.bounds);
        //CGFloat newX = maxX - (containerSize.width + widthOffset);
        
        scrollRect = CGRectMake(self.view.bounds.origin.x+widthOffset, self.view.bounds.origin.y+heightOffset, containerSize.width, containerSize.height);
    }
  
    [self.scrollView setFrame:scrollRect];
    
    
    // the height of the content view is a function of the number of subviews
    CGFloat contentHeight = (self.scrollView.bounds.size.height)*[self numContainedViews];
    CGRect contentFrame = CGRectMake(0, 0, self.scrollView.bounds.size.width, contentHeight);
    [self.scrollView setContentSize:contentFrame.size];
    
    // if view layout has been triggered by device rotation, we need to correct the content offset. if layout triggered by scroll view animation, the content offset will be set already
    CGFloat yOff = self.scrollView.frame.size.height * currentContainerPosition;
    CGPoint offset = CGPointMake(self.scrollView.bounds.origin.x, yOff);
    
    if (!(self.scrollView.contentOffset.y == offset.y)){
        [self.scrollView setContentOffset:offset];
    }
    [self.topLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.topLabel setNumberOfLines:0];
    [self layoutLabelsAndButtons];
    [self refreshLabelsAndButtons];
    [self.contentView layoutSubviews];

}


-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
}

- (void)orientationChanged:(NSNotification *)notification{
    
    [self layoutLabelsAndButtons];
    
}

#pragma mark - subview layout methods

-(void)viewDidLayoutSubviews{
    NSLog(@"Did layout subviews");
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:15];
    
    // configure the bottom button
    if (currentContainerPosition < [self numContainedViews]-1){
        [self.pageDownButton setTitle:@"Next" forState:UIControlStateNormal];
        [self.pageDownButton addTarget:self action:@selector(pageDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.pageDownButton setBackgroundColor:[UIColor whiteColor]];
        [[self.pageDownButton titleLabel] setFont:font];
        [[self.pageDownButton titleLabel] setTextColor:[UIColor blackColor]];
        
    } else {
        [self.searchButton addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
        [self.searchButton setBackgroundColor:[UIColor whiteColor]];
        [[self.searchButton titleLabel] setFont:font];
        [[self.searchButton titleLabel] setTextColor:[UIColor blackColor]];
    }
    
    // configure the top button/label
    if (currentContainerPosition==0){
        [self.topLabel setText:@"Select Event Types"];
        [self.topLabel setTextAlignment:NSTextAlignmentCenter];
        [self.topLabel setTextColor:[UIColor whiteColor]];
    }else {
        
        [self.topButton addTarget:self action:@selector(pageUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.topButton.titleLabel setFont:font];
        [[self.topButton titleLabel] setTextColor:[UIColor blackColor]];
        [self.topButton setBackgroundColor:[UIColor whiteColor]];
        [self.topButton setTitle: @"Back" forState: UIControlStateNormal];
    }
}

-(void)layoutLabelsAndButtons{
    //start by creating a frame with 0,0 origin.  All buttons will be the same size.
    CGRect aBox = CGRectMake(0, 0, 50, 40);
    // also create a variable that refers to a CGPoint; will use this to set the center of each button/label frame
    CGPoint boxCenter;
    
    // layout for portrait view
    if ([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait){
        CGRect scrollFrame = self.scrollView.frame;
        
        // layout bottom button
        // set our CGPoint variable to the button's center
        CGPoint boxCenter;
        boxCenter = CGPointMake((CGRectGetMidX(scrollFrame)), (CGRectGetMaxY(scrollFrame)+10+(aBox.size.height*.5)));
        
        if (currentContainerPosition < [self numContainedViews]-1){
            self.pageDownButton.frame = aBox;
            self.pageDownButton.center = boxCenter;
        } else {
            self.searchButton.frame = aBox;
            self.searchButton.center = boxCenter;
        }
        

        //set the top view's frame
        // we'll need a separate frame for the label because it is a different size, but we can re-use our CGPoint variable
        if (currentContainerPosition==0){
            CGPoint middleTop = CGPointMake((CGRectGetMidX(scrollFrame)), (CGRectGetMinY(self.scrollView.frame)));
            CGRect labelFrame = CGRectMake(middleTop.x-150, (middleTop.y-10)-self.buttonHeight, 300, self.buttonHeight);
            [self.topLabel setFrame:labelFrame];
        } else {
            boxCenter = CGPointMake((CGRectGetMidX(scrollFrame)), (CGRectGetMinY(scrollFrame)-10-(aBox.size.height/2)));
            self.topButton.frame = aBox;
            self.topButton.center = boxCenter;
        }
    } else {
        // layout for landscape
        CGFloat xCenter = CGRectGetMaxX(self.scrollView.frame)+((aBox.size.width*.5)+10);
        CGFloat yCenter = CGRectGetMidY(self.view.bounds);
        boxCenter = CGPointMake(xCenter, yCenter);
        
        // set the bottom button's frame
        if (currentContainerPosition < [self numContainedViews]-1){
            self.pageDownButton.frame = aBox;
            self.pageDownButton.center = boxCenter;
        } else {
            self.searchButton.frame = aBox;
            self.searchButton.center = boxCenter;
        }
        
        
        //set the top view's frame
        if (currentContainerPosition==0){
            aBox.size = CGSizeMake(aBox.size.width*1.5, aBox.size.height*3);
            self.topLabel.frame = aBox;
            xCenter = (CGRectGetMinX(self.scrollView.frame)) - (aBox.size.width*.5);
            boxCenter = CGPointMake(xCenter, yCenter);
            self.topLabel.center = boxCenter;
        } else {
            xCenter = CGRectGetMinX(self.scrollView.frame)-((aBox.size.width*.5)+10);
            boxCenter = CGPointMake(xCenter, yCenter);
            self.topButton.frame = aBox;
            self.topButton.center = boxCenter;
        }
    }
    
}

-(void)refreshLabelsAndButtons{
    // makes sure we are displaying the right subviews for the current container position
    if (currentContainerPosition < [self numContainedViews]-1){
        if (! [self.pageDownButton isDescendantOfView:self.view]){
            [self.searchButton removeFromSuperview];
            [self.view addSubview:self.pageDownButton];
        }
        
    } else {
        if (! [self.searchButton isDescendantOfView:self.view]) {
            [self.pageDownButton removeFromSuperview];
            [self.view addSubview:self.searchButton];
        }
        
        
    }
    
    if (currentContainerPosition==0) {
        if (! [self.topLabel isDescendantOfView:self.view]){
            [self.topButton removeFromSuperview];
            [self.view addSubview:self.topLabel];
        }
    } else {
        if (! [self.topButton isDescendantOfView:self.view]){
            [self.topLabel removeFromSuperview];
            [self.view addSubview:self.topButton];
            NSLog(@"Added top button.");
        }
    }
}



#pragma mark - button methods

-(void)pageDown:(id)sender{
    // increment the container position, then reset the sv offset so that the scroll origin matches up with the origin of the content view's next subview
    currentContainerPosition++;
    CGPoint scrollOrigin= self.scrollView.bounds.origin;
    CGSize scrollSize = self.scrollView.bounds.size;
    CGPoint newOffset = CGPointMake(scrollOrigin.x, scrollOrigin.y+scrollSize.height);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

-(void)pageUp:(id)sender{
    currentContainerPosition--;
    CGPoint scrollOrigin= self.scrollView.bounds.origin;
    CGSize scrollSize = self.scrollView.bounds.size;
    CGPoint newOffset = CGPointMake(scrollOrigin.x, scrollOrigin.y-scrollSize.height);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

-(void)finish:(id)sender{
    // put you fetch request logic or what have you here
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -  UIScrollScrollViewDelegate Methods


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.contentView layoutSubviews];
    [self layoutLabelsAndButtons];
    [self refreshLabelsAndButtons];
}

#pragma mark - EventsPickerDelegate methods and helper methods

-(void)touchFromButton:(id)sender{
    // handle touch events from subview buttons
}





@end
