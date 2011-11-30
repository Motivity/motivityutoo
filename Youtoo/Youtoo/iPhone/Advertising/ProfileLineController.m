//
//  ProfileLineController.m
//  ALN
//
//  Created by Ihor Xom on 9/23/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import "ProfileLineController.h"
#import "AdvModel.h"
#import "YoutooAppDelegate.h"
#import "Constants.h"
#import "ProfileFriendView.h"
#import "AboutApp.h"
#import "ProfileController.h"
#import "LineController.h"

@interface ProfileLineController (PrivateMethods)
- (void)applyModel;
@end

@implementation ProfileLineController

@synthesize advModel, profileImage, nameLabel, messageLabel;
@synthesize backImgView;
@synthesize backButton;
@synthesize navigationController;

- (id)init
{
	return [super initWithNibName:@"ProfileLineController" bundle:nil];
}

- (void)dealloc
{
 	[profileImage release];
	[nameLabel release];
	[messageLabel release];
	[advModel release];
    [backImgView release];
    [backButton release];
    
	[super dealloc];
}

- (void)viewDidLoad
{
	if (nil != self.advModel)
	{
		[self applyModel];
	}
	[super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
}

- (void)setAdvModel:(AdvModel *)aModel
{
	if (aModel != advModel)
	{
		[advModel release];
		advModel = [aModel retain];
	}
	[self applyModel];
}

- (void)applyModel
{
	if (nil != self.advModel && nil != self.profileImage)
	{
		self.profileImage.image = self.advModel.storageImage;
		self.nameLabel.text = self.advModel.name;
		self.messageLabel.text = self.advModel.text;
	}
}

- (void)viewDidUnload
{
 	self.profileImage = nil;
	self.nameLabel = nil;
	self.messageLabel = nil;
	
   [super viewDidUnload];
}

-(IBAction) tickerAdBackButtonAction
{
   
    //YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    //NSLog(@"tickerAdBackButtonAction, appDelegate.tickerUserID: %@", appDelegate.tickerUserID);
    
    [[LineController sharedLineController] launchProfile];
    
    //ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] initWithNibName:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
	

    //[self dismissModalViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:NO];
    //[self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    //[videosDoneViewController release];
    
    //UINavigationController *navg = [[UINavigationController alloc] initWithRootViewController:videosDoneViewController];
    //[appDelegate.window addSubview:navg.view];
}

@end
