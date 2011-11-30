//
//  PresentationController.m
//  ALN
//
//  Created by Ihor Xom on 8/24/10.
//  Copyright 2010 americanlifetv. All rights reserved.
//

#import "PresentationController.h"

@implementation PresentationController

- (id)init
{
	self = [super initWithNibName:@"PresentationController" bundle:nil];
	return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
