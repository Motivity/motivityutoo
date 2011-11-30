//
//  AdvertisingController.m
//  ALN
//
//  Created by Ihor Xom on 9/22/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import "AdvertisingController.h"
#import "AdvModel.h"
#import "YoutooAppDelegate.h"

@interface AdvertisingController (PrivateMethods)
- (void)applyModelToController;
- (void)showAdvertising;
@end

@implementation AdvertisingController

@synthesize model, advertisingView, delegateController, activityIndicator;

- (id)init
{
	return [super initWithNibName:@"AdvertisingController" bundle:nil];
}

- (void)dealloc
{
	[model release];
	[advertisingView release];
	[activityIndicator release];
	
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	if (nil != model && nil != self.advertisingView)
	{
		[self applyModelToController];
	}
}




- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[self showAdvertising];
}

- (void)viewDidUnload
{
    self.advertisingView = nil;
    self.activityIndicator = nil;
	
    [super viewDidUnload];
}

- (void)setModel:(AdvModel *)aModel
{
	if (aModel != model)
	{
		[model release];
		model = [aModel retain];
		if (nil != model && nil != self.advertisingView)
		{
			[self applyModelToController];
		}
	}
}

- (void)showAdvertising
{	
	NSURLRequest *wwwLinkRequest = [NSURLRequest requestWithURL:
		[NSURL URLWithString:self.model.advertisingPath]];
	[self.advertisingView loadRequest:wwwLinkRequest];	
}

- (void)applyModelToController
{

}

#pragma mark -
#pragma mark Action
#pragma mark -

- (IBAction)hideAction:(id)sender
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //[appDelegate showFloatingBar];
	[appDelegate startAdvertisingBar];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)jumpToAdvertisingSite:(id)sender
{
    if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.moreinfoPath]])
	{
		YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		[appDelegate reportError:NSLocalizedString(@"Cannot open the URL", @"Alert Title")
			description:NSLocalizedString(@"Please check the internet connection", @"Alert Description")];
	}
	else
	{
		YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		//[appDelegate showFloatingBar];
		[appDelegate startAdvertisingBar];
		[self dismissModalViewControllerAnimated:NO];
	}
}

#pragma mark -
#pragma mark UIWebView datasource methods
#pragma mark -
#pragma mark -

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{		
	[self.activityIndicator stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self.activityIndicator stopAnimating];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[YoutooAppDelegate reportError:NSLocalizedString(@"Failed to open URL %@", @"Alert title")
		description:[error localizedDescription]];
}

@end
