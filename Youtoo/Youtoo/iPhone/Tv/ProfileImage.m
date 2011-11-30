//
//  ProfileImage.m
//  ALN
//
//  Created by Ihor Xom on 8/24/10.
//  Copyright 2010 americanlifetv. All rights reserved.
//

#import "ProfileImage.h"

@implementation ProfileImage

@synthesize delegate;

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
	if (nil != self.delegate && [self.delegate respondsToSelector:@selector(touchIconAction:)])
	{
		[self.delegate performSelector:@selector(touchIconAction:) withObject:nil];
	}
}

- (void)dealloc
{
	self.delegate = nil;
    [super dealloc];
}

@end
