//
//  ProfileBackground.m
//  ALN
//
//  Created by Ihor Xom on 9/25/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import "ProfileBackground.h"
#import "LineController.h"

@implementation ProfileBackground


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
    if (nil != self)
	{
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	//[[LineController sharedLineController] showProfileController];
}


@end
