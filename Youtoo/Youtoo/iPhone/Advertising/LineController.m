    //
//  LineController.m
//  ALN
//
//  Created by Ihor Xom on 9/24/10.
//  Copyright 2010 OneHeartMovie. All rights reserved.
//

#import "LineController.h"
#import "AdvModel.h"
#import "YoutooAppDelegate.h"
#import "ProfileLineController.h"
#import "ProfileController.h"
#import "AdvertisingController.h"
#import "AdvertisingLineController.h"
#import "Constants.h"

@interface LineController (PrivateMethods)
- (void)setupController;
- (NSString *)correctString:(NSString *)originalURLString;
- (void)advertisingUpdateSelector:(NSNotification *)notification;
- (void)showAdvertisingLineWithModel:(AdvModel *)aModel;
- (void)showProfileLineWithModel:(AdvModel *)aModel;
@end

static const CGFloat kAdvLabelFontSize = 11.0;
static const CGFloat kUpdateAdvBarInterval = 4.0;
static LineController *sharedLineController = nil;

@implementation LineController

@synthesize isProfileAdvertising;
@synthesize rssParser, advModel;
@synthesize currentElement;
@synthesize profileLineController, advertisingLineController;
@synthesize selectedController;

+ (LineController *)sharedLineController
{
	if (nil == sharedLineController)
	{
		sharedLineController = [[LineController alloc] init];
	}
	return sharedLineController;	
	
}

- (id)init
{
	self = [super init];
	if (nil != self)
	{
		self.currentElement = @"";
		isNetworkOperation = NO;
		advModel = [[AdvModel alloc] init];
		[self setupController];

        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.tickerUserID = NULL;
	}
	return self;
}
- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	self.rssParser = nil;
	updateTimer = nil;
	self.currentElement = nil;
	self.advModel = nil;
	self.profileLineController = nil;
	self.advertisingLineController = nil;
    [super dealloc];
}

#pragma mark -

- (void)setupController
{	
	profileLineController = [[ProfileLineController alloc] init];
	advertisingLineController = [[AdvertisingLineController alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(advertisingUpdateSelector:) name:kAdvertisingNotification object:nil];
}

-(void) selectedController : (UIViewController *) selectController
{
    NSLog(@"set selectedController in Line controller");
    
    selectedController = selectController;
}
#pragma mark -
#pragma mark Notification selector
#pragma mark -

- (void)advertisingUpdateSelector:(NSNotification *)notification
{
	if ([[NSThread currentThread] isMainThread])
	{
		[self.profileLineController applyModel];
		[self.advertisingLineController applyModel];
	}
}

#pragma mark -
#pragma mark Action
#pragma mark -

- (void)showAdvertisingLineWithModel:(AdvModel *)aModel
{	
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if ([appDelegate canShowAdvertising])
	{
		self.advertisingLineController.advModel = aModel;
		self.isProfileAdvertising = NO;
		if (nil != self.profileLineController.view.superview)
		{
			[appDelegate changeAdvancedLine:self.profileLineController.view toLine:self.advertisingLineController.view];
		}
		else
		{
			[appDelegate showAdvancedLine:self.advertisingLineController.view];
		}
	}
}

- (void)showProfileLineWithModel:(AdvModel *)aModel
{	
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	if ([appDelegate canShowAdvertising])
	{
		self.profileLineController.advModel = aModel;
		self.isProfileAdvertising = YES;
		if (nil != self.advertisingLineController.view.superview)
		{
			[appDelegate changeAdvancedLine:self.advertisingLineController.view toLine:self.profileLineController.view];
		}
		else
		{
			[appDelegate showAdvancedLine:self.profileLineController.view];
		}
	}
}

- (IBAction)showProfileController
{	
	ProfileController *profileController = [[[ProfileController alloc] init] autorelease];
	profileController.model = advModel;
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate stopAdvertisingBar];
	//[appDelegate hideFloatingBar];
	[appDelegate.tabBarController presentModalViewController:profileController animated:YES];
}

- (IBAction)showAdvertisingController
{	
	AdvertisingController *advController = [[[AdvertisingController alloc] init] autorelease];
	advController.delegateController = self;
	advController.model = advModel;
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate stopAdvertisingBar];
	//[appDelegate hideFloatingBar];
	[appDelegate.tabBarController presentModalViewController:advController animated:YES];
}

#pragma mark -
#pragma mark XMLParser
#pragma mark -

- (void)parseXMLFilewithData:(NSString *)strURL
{
    if (strURL==NULL)
        return;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *dataURL = [NSURL URLWithString:strURL];
	self.rssParser = [[[NSXMLParser alloc] initWithContentsOfURL:dataURL] autorelease];
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
	[pool release];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	[self.advModel initializeModel];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	isNetworkOperation = NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	if ([trimmString length] > 0)
	{
		if ([self.currentElement isEqualToString:@"text"])
		{
			advModel.text =  trimmString;
		}
		else if ([self.currentElement isEqualToString:@"name"])
		{
			advModel.name = [self correctString:trimmString];
		}
		else if ([self.currentElement isEqualToString:@"image"])
		{
			advModel.imagePath = trimmString;
		}
		else if ([self.currentElement isEqualToString:@"profileurl"])
		{
			NSLog(@"ProfileURL: %@", trimmString);
            advModel.profilePath = trimmString;
		}
		else if ([self.currentElement isEqualToString:@"adurl"])
		{
			NSLog(@"AdURL: %@", trimmString);
            advModel.advertisingPath = trimmString;
		}
        else if ([self.currentElement isEqualToString:@"moreinfo"])
		{
			
            advModel.moreinfoPath = trimmString;
		}
        else if ([self.currentElement isEqualToString:@"userid"])
		{
			NSLog(@"userid: %@", trimmString);
            YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
            appDelegate.tickerUserID = trimmString;
		}
        
	}
}

- (NSString *)correctString:(NSString *)originalURLString
{
	CFStringRef preprocessedString = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, 
		(CFStringRef)originalURLString, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
	return [(NSString *)preprocessedString autorelease];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	isNetworkOperation = NO;
	if (nil != advModel.advertisingPath && advModel.advertisingPath.length > 0)
	{
		[self performSelectorOnMainThread:@selector(showAdvertisingLineWithModel:) withObject:advModel waitUntilDone:NO];
	}	
	else
	{
		[self performSelectorOnMainThread:@selector(showProfileLineWithModel:) withObject:advModel waitUntilDone:NO];
	}
}

#pragma mark end XMLParser

- (void)stopAdvertising
{
	if ([updateTimer isValid])
	{
		[updateTimer invalidate];
		updateTimer = nil;
	}
}

- (void)startAdvertising
{
	if (nil != updateTimer)
	{
		[updateTimer invalidate];
		updateTimer = nil;
	}
	[self updateBottomLine:nil];
	updateTimer = [NSTimer scheduledTimerWithTimeInterval:kUpdateAdvBarInterval 
		target:self selector:@selector(updateBottomLine:) userInfo:nil repeats:YES];
}

-(void) launchProfile
{
    NSLog(@"launchProfile in LineController");
    
    if (nil != self.selectedController && [self.selectedController respondsToSelector:@selector(callProfileFrienView)])
    {
        NSLog(@"selectedController callProfileFrienView");
        
        [self.selectedController performSelector:@selector(callProfileFrienView)];
    }
}
- (void)updateBottomLine:(NSTimer*)theTimer
{
	if (!isNetworkOperation)
	{
		isNetworkOperation = YES;
        YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
		//NSString *advURLString = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/line?sessioncookie=%@",appDelegate.sessionCookie];
		NSString *advURLString = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/line"];

		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) 
								 toTarget:self withObject:advURLString];
        
        //[appDelegate reportError:NSLocalizedString(@"Bottom line URL", @"Alert Title")
          //           description:[advURLString copy]];
	}
}

- (BOOL)isShownAdvertising
{
	return (nil != self.profileLineController.view.superview || 
			nil != self.advertisingLineController.view.superview);
}

#pragma mark -

- (void)alertView:(UIAlertView *)anAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

@end
