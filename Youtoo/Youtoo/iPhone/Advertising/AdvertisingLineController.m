//
//  AdvertisingLineController.m
//  ALN
//
//  Created by Ihor Xom on 9/24/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import "AdvertisingLineController.h"
#import "AdvModel.h"
#import "LineController.h"
#import "Constants.h"

@interface AdvertisingLineController (PrivateMethods)
@end

@implementation AdvertisingLineController

@synthesize advModel, profileImage, nameLabel, profileImgBtn,messgLabel;;

- (id)init
{
	return [super initWithNibName:@"AdvertisingLineController" bundle:nil];
}

- (void)dealloc
{
 	[profileImage release];
	[advModel release];
	[nameLabel release];
	[profileImgBtn release];
	[super dealloc];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	if (nil != self.advModel)
	{
		[self applyModel];
	}
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

- (void) applyModel
{
	if (nil != self.advModel)
	{
		
        
        [self.profileImgBtn setImage:self.advModel.storageImage forState:UIControlStateNormal];
		self.nameLabel.text = self.advModel.name;
        self.messgLabel.text  = self.advModel.text;
	}
}

- (void)viewDidUnload
{
    self.profileImage = nil;
    self.profileImgBtn=nil;
	self.nameLabel = nil;
    [super viewDidUnload];
}

- (IBAction) ShowAdView :(id) sender
{
    if (nil != self.advModel )
        [[LineController sharedLineController] showProfileController];
}

@end
