//
//  TickerShoutModel.m
//  Youtoo
//
//  Created by Subrahmanyam Chaturvedula's on 11/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "TickerShoutModel.h"


@implementation TickerShoutModel

@synthesize textShout;
@synthesize shoutLink;

- (void)dealloc
{
	self.textShout = nil;
    self.shoutLink = nil;
    
    [super dealloc];
}

@end
