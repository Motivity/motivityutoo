//
//  FAQ.m
//  Youtoo
//
//  Created by PRABAKAR MP on 16/09/11.
//  Copyright 2011 CORPUS MOBILE LABS. All rights reserved.
//

#import "FAQ.h"
#import "ASIFormDataRequest.h"
//#import "ASINetworkQueue.h"
#import "YoutooAppDelegate.h"
#import "ProfileFriendView.h"
@interface FAQ (PrivateMethods)

- (void)didStopLoadData;
@end


@implementation FAQ
@synthesize rssParser;
@synthesize item;
@synthesize currentElement;
@synthesize creditLbl;
@synthesize isNetworkOperation;
@synthesize activityIndicator;
@synthesize sendResult;
@synthesize imageArray;
@synthesize aboutFaqString;
@synthesize faqTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isNetworkOperation = NO;
        self.sendResult = @"";
   //     networkQueue = [[ASINetworkQueue alloc] init];      
    }
    return self;
}

- (void)dealloc
{
   [item release];
	self.currentElement = nil;
	self.rssParser= nil;
    [activityIndicator release];
    [creditLbl release];
    [imageArray release];
 //   [networkQueue release];
    [faqTextView release];
    
    [super dealloc];
}

- (BOOL)canShowAdvertising
{
	return YES;
}
- (void)reloadPage
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view from its nib.
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.selectedController = self;
	[appDelegate startAdvertisingBar];    
    // Do any additional setup after loading the view from its nib.    
    
 /*   NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/showHelp/faq"];
    NSLog(@"Constructed Content URL: %@", path);    
    [activityIndicator startAnimating];
    self.isNetworkOperation = YES;
    NSLog(@"request auth: %@", path);
    [networkQueue cancelAllOperations];
    [networkQueue setDelegate:self];
    ASIFormDataRequest *request = [[[ASIFormDataRequest alloc] initWithURL:
                                    [NSURL URLWithString:path]] autorelease];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request setTimeOutSeconds:20];
    [networkQueue addOperation:request];
    [networkQueue go];*/
 //   NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//	NSDate *pageLastUpdate = [defaults objectForKey:@"BlogPageLastUpdate"];
    //	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
    //	NSTimeInterval elapsedTime = (pageLastUpdate) ? [pageLastUpdate timeIntervalSinceNow] : -kElapsedTime;
    //	NSTimeInterval definedTimeInterval = kUpdatePeriod;
	//if (!isNetworkOperation && ([self.item count] == 0 || elapsedTime < -definedTimeInterval))
	{
		isNetworkOperation = YES;
		[activityIndicator startAnimating];
//		[defaults setObject:[NSDate date] forKey:@"BlogPageLastUpdate"];
		[appDelegate didStartNetworking];
        // Get the current timezone in hours and send to server...
        NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
        int timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600;
        NSLog(@"sourceDate=%@ timeZoneOffset=%d", sourceDate, timeZoneOffset);
        NSString *featuredString;
        NSMutableString *tempURLStr = [[NSMutableString alloc] init];
        [tempURLStr appendFormat:@"http://www.youtoo.com/iphoneyoutoo/showHelp/faq"];
        //     NSString *path = [NSString stringWithFormat:@"http://www.youtoo.com/iphoneyoutoo/showHelp/aboutapp "];
        featuredString = [tempURLStr copy];
        NSLog(featuredString);
        [tempURLStr release];
        tempURLStr=nil;
		[NSThread detachNewThreadSelector:@selector(parseXMLFilewithData:) toTarget:self 
                               withObject:featuredString];
	}

}

-(IBAction) backAction : (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	isNetworkOperation = NO;
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	//appDelegate.selectedController = nil;
	[appDelegate didStopNetworking];
}

- (void)didReceiveMemoryWarning
{
 	if (nil != self.rssParser)
	{
		[self.rssParser abortParsing];
	}
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	isNetworkOperation = NO;
    [super didReceiveMemoryWarning];
}

-(void) callProfileFrienView
{
    YoutooAppDelegate *appDelegate = (YoutooAppDelegate *) [UIApplication sharedApplication].delegate;
    NSLog(@"callProfileFrienView in Schedule screen");
    
    ProfileFriendView *videosDoneViewController = [[ProfileFriendView alloc] setupNib:@"ProfileFriendView" bundle:[NSBundle mainBundle] :nil :(appDelegate.tickerUserID)?appDelegate.tickerUserID:nil];
    [self.navigationController pushViewController:videosDoneViewController animated:YES];
    
    [videosDoneViewController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"FAQ";
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(138, 180, 40, 40)];   
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:activityIndicator]; 
   faqTextView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, 95.0, 310.0, 350.0)];
    [faqTextView setBackgroundColor:[UIColor clearColor]];
    [faqTextView setFont:[UIFont systemFontOfSize:16.0]];
    faqTextView.textColor=[UIColor colorWithRed:0.14 green:0.29 blue:0.42 alpha:1];
    [faqTextView setScrollEnabled:YES];
    [faqTextView setText:@""];
    [faqTextView setText:self.aboutFaqString ];
    //friendTxtFld.tag = indexPath.row;
    [faqTextView setEditable:NO];
    [self.view addSubview:faqTextView];

    // Do any additional setup after loading the view from its nib.
}
#pragma mark -
#pragma mark XMLParser
#pragma mark -
//- (void)parseXMLFilewithData:(NSData *)data
//{
//    self.sendResult = @"";
//    self.rssParser = [[[NSXMLParser alloc] initWithData:data] autorelease];		
//	[self.rssParser setDelegate:self];
//	[self.rssParser parse];
//}
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
- (void)showAlertNoConnection:(NSError *)anError
{
	isNetworkOperation = NO;
	[activityIndicator stopAnimating];
	YoutooAppDelegate *appDelegate = (YoutooAppDelegate *)[UIApplication sharedApplication].delegate;
	[appDelegate didStopNetworking];
	[appDelegate reportError:NSLocalizedString(@"Please check the internet connection", @"Alert Text")
				 description:@"Internet connection is must to run this product."];
}
//- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
//{
//    [self performSelectorOnMainThread:@selector(showAlertErrorParsing) 
//                           withObject:parseError waitUntilDone:NO];
//	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
//}

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
	
    NSLog(@"Content: trimmString: %@", trimmString);
    NSLog(@"self.currentElement: %@", self.currentElement);
    
    if ([self.currentElement isEqualToString:@"content"] && [trimmString length] > 0)
    {
        self.aboutFaqString = string;
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[self performSelectorOnMainThread:@selector(didEndParsing) withObject:nil waitUntilDone:NO];
}


- (void)didEndParsing
{
    self.isNetworkOperation = NO;
	[activityIndicator stopAnimating];
    [faqTextView setText:self.aboutFaqString];    
}


#pragma mark -
#pragma mark end ASIHTTPRequest Request
#pragma mark -
/*
- (void)requestDone:(ASIHTTPRequest *)request
{    
    [networkQueue setDelegate:nil];
	[request setDelegate:nil];
	[activityIndicator stopAnimating];
	NSData *responseData = [request responseData];
	NSLog(@"Content: %@", [request responseString]);
	
    [self parseXMLFilewithData:responseData];
}

- (void)postDone:(ASIHTTPRequest *)request
{
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    
}
*/
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
