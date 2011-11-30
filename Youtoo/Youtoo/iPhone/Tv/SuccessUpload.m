//
//  SuccessUpload.m
//  Youtoo
//
//  Created by PRABAKAR MP on 24/08/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "SuccessUpload.h"
#import "RecordAfameSpot.h"
#import "WriteAtickerShout.h"
#import "YoutooAppDelegate.h"

@implementation SuccessUpload
@synthesize creditLabel;
@synthesize rssParser;
@synthesize currentElement;
@synthesize bAuthDone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [creditLabel release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Success";
    self.navigationItem.hidesBackButton = YES;
    bAuthDone = NO;
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"appDelegate.earnCredit = %@", appDelegate.earnCredit);
    creditLabel.text = (appDelegate.earnCredit!=NULL)?appDelegate.earnCredit:@"12";
    
    UIButton *fameSpotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fameSpotBtn setFrame:CGRectMake(29, 285, 130, 130)];
    [fameSpotBtn setBackgroundImage:[UIImage imageNamed:@"19-Success-createfame.png"] forState:UIControlStateNormal];
    [fameSpotBtn addTarget:self action:@selector(fameSoptAct:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:fameSpotBtn];
    UIButton *tickerShoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tickerShoutBtn setFrame:CGRectMake(156, 285, 130, 130)];
    [tickerShoutBtn setBackgroundImage:[UIImage imageNamed:@"write-a-ticker-shout.png"] forState:UIControlStateNormal];
    [tickerShoutBtn addTarget:self action:@selector(tickerSpotAct:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:tickerShoutBtn];
    

    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
    
    [self updateCredits];
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
}
- (BOOL)canShowAdvertising
{
	return YES;
}
-(void) reloadPage
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
    [appDelegate startAdvertisingBar];
    
}
-(void)fameSoptAct:(id)sender

{
    RecordAfameSpot *fameSpotViewContr = [[RecordAfameSpot alloc] initWithNibName:@"RecordAfameSpot" bundle:nil];
    [self.navigationController pushViewController:fameSpotViewContr animated:YES];
    [fameSpotViewContr release];
}
-(void)tickerSpotAct:(id)sender
{
    WriteAtickerShout *tickerSpotViewContr = [[WriteAtickerShout alloc] initWithNibName:@"WriteAtickerShout" bundle:nil :nil];
    
    [self.navigationController pushViewController:tickerSpotViewContr animated:YES];
    [tickerSpotViewContr release];
    
}
-(void)updateCredits
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/auth/%@/%@", [appDelegate readUserName], [appDelegate readLoginPassword]];
    NSLog(@"Constructed Login URL: %@", path);
    NSString *featuredString;
    NSMutableString *tempURLStr = [[NSMutableString alloc] init];
    [tempURLStr appendFormat:path];
    featuredString = [tempURLStr copy];
    NSLog(featuredString);
    [tempURLStr release];
    tempURLStr=nil;
    [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                           withObject:featuredString];
    
    
}

#pragma mark -
#pragma mark XMLParser
#pragma mark -
- (void)parseXMLFilewithData:(NSString *)strURL
{	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSURL *dataURL = [NSURL URLWithString:strURL];
	self.rssParser = [[[NSXMLParser alloc] initWithContentsOfURL:dataURL] autorelease];
	[self.rssParser setDelegate:self];
	[self.rssParser parse];
	[pool release];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{	
	[self performSelectorOnMainThread:@selector(showAlertNoConnection:) 
						   withObject:parseError waitUntilDone:NO];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName 
	attributes:(NSDictionary *)attributeDict
{
    self.currentElement = elementName;
    
    NSLog(@"success upload,self.currentElement: %@", self.currentElement);
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSString *trimmString = [string stringByTrimmingCharactersInSet:
							 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
    NSLog(@"Content: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);

    if ([self.currentElement isEqualToString:@"auth"] && [trimmString length] > 0)
	{
		NSLog(@"success upload: Auth success, go get the profile info, auth res: %@", string);
        bAuthDone = YES;
	}

    if ( ( [self.currentElement isEqualToString:@"name"] || [self.currentElement isEqualToString:@"username"]) && [trimmString length] > 0 )
    {
        appDelegate.userName = trimmString;
        NSLog(@"success upload: appDelegate.userName: %@", appDelegate.userName);
    }
    else if ([self.currentElement isEqualToString:@"user_image"] && [trimmString length] > 0)
    {
        appDelegate.userImage = trimmString;
        NSLog(@"success upload: appDelegate.userImage: %@", appDelegate.userImage);
    }
    else if ([self.currentElement isEqualToString:@"points"] && [trimmString length] > 0)
    {
        appDelegate.creditStr = trimmString;
        NSLog(@"success upload upload: appDelegate.creditStr: %@", appDelegate.creditStr);
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{	
	//[self.itemStorage downloadImages];
	[self performSelectorOnMainThread:@selector(didStopLoadData) withObject:nil waitUntilDone:NO];
}

- (void)showAlertNoConnection:(NSError *)anError
{
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
				 description:@"Internet connection is must to run this product (or) Server error."];
}

- (void)didStopLoadData
{
	if ( bAuthDone == YES)
    {
        NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/profile"];
        NSLog(@"Constructed Login URL: %@", path);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:path];
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
        [NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
        
        bAuthDone = NO;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
