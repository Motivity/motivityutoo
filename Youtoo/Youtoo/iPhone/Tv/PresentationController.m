//
//  PresentationController.m
//  Viddy
//
//  Created by PRABAKAR MP on 16/05/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
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
