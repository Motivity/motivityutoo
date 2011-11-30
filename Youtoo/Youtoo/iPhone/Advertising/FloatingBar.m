//
//  FloatingBar.m
//  iGivings
//
//  Created by Ihor Xom on 5/3/10.
//  Copyright 2010 Everlasting Technologies. All rights reserved.
//

#import "FloatingBar.h"
#import "YoutooAppDelegate.h"

#import "Constants.h"

@interface FloatingBar (PrivateMethods)
- (void)setupBarButtons;
- (UIButton *)createScrollButtonWithImage:(NSString *)anImageName;
- (UIButton *)createTabButtonWithImage:(NSString *)anImageName;
- (void)disableButtonWithTag:(NSInteger)aButtonTag;
- (void)showButtonController:(id)sender;
- (void)moveLeft:(id)sender;
- (void)moveRight:(id)sender;
- (void)updateController;
@end

static const CGFloat kButtonWidth = 80.0;

@implementation FloatingBar

@synthesize selectedBarItem = _selectedBarItem;

#pragma mark -
#pragma mark Load Views
#pragma mark -

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		_selectedBarItem = -1;
		_itemImages = [[NSArray arrayWithObjects:@"tab_featured", @"tab_blogs", @"tab_ticker", 
			@"tab_video", @"tab_shows", @"tab_schedule", @"tab_favorites",@"tab_screwdriver", @"tab_radio", nil] retain];
		_buttonsArray = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)loadView
{
	// setup our parent content view and embed it to your view controller
	CGRect rect = [[UIScreen mainScreen] applicationFrame];
	CGRect cFrame = CGRectMake(0.0, 0.0, rect.size.width, kFloatingPanelHeight);
	UIView *contentView = [[UIView alloc] initWithFrame:cFrame];
	contentView.backgroundColor = [UIColor clearColor];
	contentView.autoresizesSubviews = YES;
	self.view = contentView;
	[contentView release];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	UIImageView *aBar = [[UIImageView alloc] initWithFrame:self.view.frame];
	aBar.image = [UIImage imageNamed:@"barBack.png"];
	aBar.contentMode = UIViewContentModeScaleToFill;
	[self.view addSubview:aBar];
	[aBar release];
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
	_scrollView.showsHorizontalScrollIndicator = NO;
	[self.view addSubview:_scrollView];
	[self setupBarButtons];
	_leftArrow = [self createScrollButtonWithImage:@"icons_tab_arrow_left.png"];
	[_leftArrow addTarget:self action:@selector(moveLeft:)
		  forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_leftArrow];
	_rightArrow = [self createScrollButtonWithImage:@"icons_tab_arrow_right.png"];
	[_rightArrow addTarget:self action:@selector(moveRight:)
		 forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_rightArrow];
	if (self.selectedBarItem >= 0)
	{
		[self disableButtonWithTag:self.selectedBarItem];
		[_scrollView scrollRectToVisible:CGRectMake(kButtonWidth * _selectedBarItem, 
			0.0, kButtonWidth, kFloatingPanelHeight) animated:YES];
	}

	[self updateController];
}



#pragma mark -
#pragma mark Setup subviews
#pragma mark -

- (void)setupBarButtons
{	
	[_buttonsArray removeAllObjects];
	NSInteger i = 0;
	for (i = 0; i < kTabBarCount; i++)
	{
		UIButton *aButton = [self createTabButtonWithImage:[_itemImages objectAtIndex:i]];
		aButton.tag = i;
		[aButton addTarget:self action:@selector(showButtonController:)
		  forControlEvents:UIControlEventTouchUpInside];
		[_scrollView addSubview:aButton];
		[_buttonsArray addObject:aButton];
	}
	_scrollView.contentSize = CGSizeMake(kButtonWidth * [_buttonsArray count] + 10.0, kFloatingPanelHeight);
}

- (UIButton *)createTabButtonWithImage:(NSString *)anImageName
{	
	// create the UIButtons with various background images
	NSString *buttonName = [NSString stringWithFormat:@"%@.png", anImageName];
	UIImage *buttonBackground = [UIImage imageNamed:buttonName];
	NSString *buttonPressedName = [NSString stringWithFormat:@"%@_tap.png", anImageName];
	UIImage *buttonBackgroundPressed = [UIImage imageNamed:buttonPressedName];
	CGRect frame = CGRectMake(0.0, 0.0, buttonBackground.size.width, buttonBackground.size.height);
	UIButton *aButton = [[[UIButton alloc] initWithFrame:frame] autorelease];
	aButton.backgroundColor = [UIColor clearColor];
	[aButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
	[aButton setBackgroundImage:buttonBackgroundPressed forState:UIControlStateHighlighted];
	[aButton setBackgroundImage:buttonBackgroundPressed forState:UIControlStateDisabled];
	return aButton;
}

- (UIButton *)createScrollButtonWithImage:(NSString *)anImageName
{	
	// create the UIButtons with various background images
	UIImage *buttonBackground = [UIImage imageNamed:anImageName];
	CGRect frame = CGRectMake(0.0, 0.0, buttonBackground.size.width, buttonBackground.size.height);
	UIButton *aButton = [[[UIButton alloc] initWithFrame:frame] autorelease];
	aButton.backgroundColor = [UIColor clearColor];
	[aButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
	return aButton;
}

#pragma mark -
#pragma mark Update 
#pragma mark -

- (void)updateController
{
	CGFloat buttonY = 24.5;
	_leftArrow.center = CGPointMake(7.0, buttonY);
	_rightArrow.center = CGPointMake(313.0, buttonY);
	NSInteger i = 0;
	CGFloat offsetX = 0.0;
	for (i = 0; i < [_buttonsArray count]; i++)
	{
		UIButton *aButton = [_buttonsArray objectAtIndex:i];
		aButton.center = CGPointMake(offsetX + aButton.frame.size.width / 2.0, buttonY);
		offsetX += aButton.frame.size.width;
	}
}

#pragma mark -
#pragma mark Actions
#pragma mark -

- (void)moveLeft:(id)sender
{
	CGPoint contentOffset = [_scrollView contentOffset];
	contentOffset.x = (contentOffset.x > kButtonWidth) ? contentOffset.x - kButtonWidth : 0.0;
	[_scrollView setContentOffset:contentOffset animated:YES];
}

- (void)moveRight:(id)sender
{
	NSInteger offsetItems = [_buttonsArray count] - 4;
	CGPoint contentOffset = [_scrollView contentOffset];
	CGFloat barOffset = kButtonWidth * offsetItems + 10.0;
	contentOffset.x = (contentOffset.x < barOffset) ? contentOffset.x + kButtonWidth + 10.0 : barOffset;
	[_scrollView setContentOffset:contentOffset animated:YES];
}

- (void)showButtonController:(id)sender
{
	NSInteger tag = ((UIButton*)sender).tag;
	self.selectedBarItem = tag;
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate showControllerWithTag:tag];
}


- (void)setSelectedBarItem:(NSInteger)anItem
{
	if (anItem != _selectedBarItem)
	{
		_selectedBarItem = anItem;
		[self disableButtonWithTag:_selectedBarItem];
		[_scrollView scrollRectToVisible:CGRectMake(kButtonWidth * _selectedBarItem, 
			0.0, kButtonWidth, kFloatingPanelHeight) animated:NO];
		[self updateController];
	}
}

- (void)disableButtonWithTag:(NSInteger)aButtonTag
{	
	for (UIButton *button in _buttonsArray)
	{
		button.enabled = !(button.tag == aButtonTag);
	}
}

#pragma mark -

- (void)dealloc
{
	[_scrollView release];
	[_buttonsArray release];
	[_itemImages release];
	[_leftArrow release];
	[_rightArrow release];
	
    [super dealloc];
}

@end
