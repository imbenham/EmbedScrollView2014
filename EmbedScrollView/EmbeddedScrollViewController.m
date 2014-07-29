//
//  EmbeddedScrollViewController.m
//  VetSports
//
//  Created by Isaac Benham on 6/26/14.
//  Copyright (c) 2014 Isaac Benham. All rights reserved.
//

#import "EmbeddedScrollViewController.h"
#import "EventsPickerView.h"
#import "LocationPickerView.h"

@interface EmbeddedScrollViewController ()
{
    CGFloat widthOffset;
    CGFloat heightOffset;
    UIButton *pageDownButton;
    UIView *topSubview;
    UIView *contentView;
    int currentContainerPosition;
    float topSubviewHeight;
}
@property (nonatomic, strong) NSArray *containedViews;

-(NSUInteger)numContainedViews;

-(void)setButtonFrames;
-(void)refreshSubviewsForOffset:(CGPoint)offset;
-(void)refreshButtons;

-(void)pageDown:(id)sender;
-(void)pageUp:(id)sender;
@end

@implementation EmbeddedScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    currentContainerPosition = 0;
    topSubviewHeight = 40;
    
    CGRect scrollFrame;
    CGSize containerSize;
    
    containerSize.height = self.view.bounds.size.height * .6;
    containerSize.width = self.view.bounds.size.width*.9;
    
    widthOffset = (self.view.bounds.size.width - containerSize.width) / 2;
    heightOffset = widthOffset+topSubviewHeight;
    
    
    scrollFrame = CGRectMake(self.view.bounds.origin.x+widthOffset, self.view.bounds.origin.y+heightOffset, containerSize.width, containerSize.height);
    
    // if needed, initialize the scroll view with frame equal to the view, set delegate and scrollEnabled properties
    if (!self.scrollView){
        self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
        [self.scrollView setDelegate:self];
        //[self.scrollView setScrollEnabled:NO];
        UIImage *patternImage = [UIImage imageNamed:@"VSCrestCleanSmall.png"];
        [self.scrollView setBackgroundColor:[UIColor colorWithPatternImage:patternImage]];
        
        if (!contentView){
            CGFloat contentHeight = (self.view.bounds.size.height+heightOffset)*([self numContainedViews]);
            CGRect contentFrame = CGRectMake(self.scrollView.bounds.origin.x, self.scrollView.bounds.origin.y, containerSize.width, contentHeight);
            contentView = [[UIView alloc] initWithFrame:contentFrame];
        }
        
        [self.scrollView addSubview:contentView];
        [self.scrollView setContentSize:contentView.bounds.size];
        
        [self.view addSubview:self.scrollView];
        
    }
    
    // set contained views array if not already set
    if (!self.containedViews){
        EventsPickerView *ePV = [[EventsPickerView alloc] init];
        LocationPickerView *lPV = [[LocationPickerView alloc] init];
        
        self.containedViews = @[ePV, lPV];
    }
    
    // add each of the contained views as subviews to the content view; their frames will be set when needed
    for (UIView *view in self.containedViews) {
        [contentView addSubview:view];
    }
    
    [self refreshSubviewsForOffset:self.scrollView.contentOffset];
    
   // NSLog(@"content offset = %@", CGPointCreateDictionaryRepresentation(self.scrollView.contentOffset));
}

-(NSUInteger)numContainedViews{
    return [self.containedViews count];
}

#pragma mark - view layout methods

-(void)refreshSubviewsForOffset:(CGPoint)offset{
    
    CGRect newFrame = CGRectMake(offset.x, offset.y, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height+1);
    
    [[self.containedViews objectAtIndex:currentContainerPosition] setFrame:newFrame];
    
    [self refreshButtons];
}

-(void)refreshButtons{
    
    if (currentContainerPosition < [self numContainedViews]-1){
        if (!pageDownButton){
            pageDownButton = [[UIButton alloc] init];
            pageDownButton.backgroundColor = [UIColor whiteColor];
            [pageDownButton setTitle:@"Next" forState:UIControlStateNormal];
            [pageDownButton addTarget:self action:@selector(pageDown:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:pageDownButton];
        }
    } else {
        NSLog(@"Change the page down button");
    }
    
    if (currentContainerPosition==0){
        topSubview = [[UILabel alloc] init];
        [((UILabel *)topSubview) setText:@"Select Event Types"];
        [((UILabel *)topSubview) setTextAlignment:NSTextAlignmentCenter];
        [((UILabel *)topSubview) setTextColor:[UIColor whiteColor]];
        [self.view addSubview:topSubview];

    }else {
        topSubview = [[UIButton alloc] init];
        [((UIButton *)topSubview) setBackgroundColor:[UIColor whiteColor]];
        [((UIButton *)topSubview) setTitle:@"Back" forState:UIControlStateNormal];
        [(UIButton *)topSubview addTarget:self action:@selector(pageUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:topSubview];
    }
    
    [self setButtonFrames];
}

-(void)setButtonFrames{
    // set the pageDownButtonFrame
    CGRect scrollFrame = self.scrollView.frame;
    CGPoint middleBottom = CGPointMake((CGRectGetMidX(scrollFrame)), (CGRectGetMaxY(scrollFrame)));
    CGRect buttonFrame = CGRectMake(middleBottom.x - 25, middleBottom.y+10, 50, 40);
    [pageDownButton setFrame:buttonFrame];
    
    //set the top view's frame
    if (currentContainerPosition==0){
        CGPoint middleTop = CGPointMake((CGRectGetMidX(scrollFrame)), (CGRectGetMinY(self.scrollView.frame)));
        CGRect viewFrame = CGRectMake(middleTop.x-150, (middleTop.y-10)-topSubviewHeight, 300, topSubviewHeight);
        [topSubview setFrame:viewFrame];
    } else {
        CGPoint middleTop = CGPointMake((CGRectGetMidX(scrollFrame)), (CGRectGetMinY(self.scrollView.frame)));
        CGRect viewFrame = CGRectMake(middleTop.x-25, (middleTop.y-10)-topSubviewHeight, 50, topSubviewHeight);
        [topSubview setFrame:viewFrame];

    }
}

#pragma mark - button methods

-(void)pageDown:(id)sender{
    currentContainerPosition++;
    
    CGPoint scrollOrigin= self.scrollView.bounds.origin;
    CGSize scrollSize = self.scrollView.bounds.size;
    
    CGPoint newOffset = CGPointMake(scrollOrigin.x, scrollOrigin.y+scrollSize.height);
    [topSubview removeFromSuperview];
    [self refreshSubviewsForOffset:newOffset];
    [self.scrollView setContentOffset:newOffset animated:YES];
}

-(void)pageUp:(id)sender{
    currentContainerPosition--;
    
    CGPoint scrollOrigin= self.scrollView.bounds.origin;
    CGSize scrollSize = self.scrollView.bounds.size;
    
    CGPoint newOffset = CGPointMake(scrollOrigin.x, scrollOrigin.y-scrollSize.height);
    [topSubview removeFromSuperview];
    [self refreshSubviewsForOffset:newOffset];
    [self.scrollView setContentOffset:newOffset animated:YES];

    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -  UIScrollScrollViewDelegate Methods


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}

#pragma mark - EventsPickerDelegate methods and helper methods

-(void)touchFromButton:(id)sender{
    // handle touch events from subview
}


@end
